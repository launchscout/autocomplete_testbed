defmodule AutocompleteTestbedWeb.AutocompleteTest do
  use ExUnit.Case
  use Wallaby.Feature

  import Wallaby.Query

  import AutocompleteTestbed.OrganizationsFixtures

  feature "selecting an organization", %{session: session} do
    _organization = organization_fixture(name: "Acme Foods")
    _organization2 = organization_fixture(name: "Acme Stuff")
    session = session
    |> visit("/people/new")
    |> assert_has(css("h1", text: "New Person"))
    |> find(css("autocomplete-input"))
    |> shadow_root()
    |> click(css("span", text: "Choose an organization"))
    |> fill_in(css("input"), with: "Acme")
    |> assert_has(css("li", text: "Acme Foods"))
    |> assert_has(css("li", text: "Acme Stuff"))
    |> click(css("li", text: "Acme Foods"))
    |> assert_has(css("span", text: "Acme Foods"))
    |> refute_has(css("li", text: "Acme Stuff"))
  end

end
