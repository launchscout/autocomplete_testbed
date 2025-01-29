defmodule AutocompleteTestbedWeb.PersonLive.FormComponent do
  use AutocompleteTestbedWeb, :live_component

  alias AutocompleteTestbed.People
  alias AutocompleteTestbed.Organizations
  alias AutocompleteTestbed.Organizations.Organization
  alias AutocompleteTestbed.People.Person

  use LiveElements.CustomElementsHelpers
  custom_element(:autocomplete_input, events: ["autocomplete-search", "autocomplete-commit"])

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage person records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="person-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:first_name]} type="text" label="First name" />
        <.input field={@form[:last_name]} type="text" label="Last name" />
        <div phx-feedback-for="organization_id">
          <.label for="autocomplete-organization">Organization</.label>
          <.autocomplete_input name="person[organization_id]" display-value={@organization_name} id="autocomplete-organization" phx-target={@myself} items={@organizations}>
          </.autocomplete_input>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Person</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{person: person} = assigns, socket) do
    organizations = Organizations.list_organizations()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:organizations, [])
     |> assign(:organization_name, organization_name(person))
     |> assign_new(:form, fn ->
       to_form(People.change_person(person))
     end)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset = People.change_person(socket.assigns.person, person_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("autocomplete-search", %{"query" => value}, socket) do
    {:noreply, assign(socket, organizations: Organizations.search_organizations(value))}
  end

  def handle_event("autocomplete-commit", %{"value" => value}, socket) do
    {:noreply, assign(socket, organizations: [])}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case People.update_person(socket.assigns.person, person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_person(socket, :new, person_params) do
    case People.create_person(person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp organization_name(%Person{organization: %Organization{name: name}}), do: name
  defp organization_name(%Person{}), do: "Choose an organization"

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
