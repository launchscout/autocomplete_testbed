defmodule AutocompleteTestbedWeb.OrganizationLive.Show do
  use AutocompleteTestbedWeb, :live_view

  alias AutocompleteTestbed.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:organization, Organizations.get_organization!(id))}
  end

  defp page_title(:show), do: "Show Organization"
  defp page_title(:edit), do: "Edit Organization"
end
