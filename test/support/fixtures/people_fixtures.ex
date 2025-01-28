defmodule AutocompleteTestbed.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AutocompleteTestbed.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> AutocompleteTestbed.People.create_person()

    person
  end
end
