defmodule AutocompleteTestbed.People.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :first_name, :string
    field :last_name, :string
    belongs_to :organization, AutocompleteTestbed.Organizations.Organization

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:first_name, :last_name, :organization_id])
    |> validate_required([:first_name, :last_name])
  end
end
