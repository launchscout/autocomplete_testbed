defmodule AutocompleteTestbedWeb.AutocompleteTest do
  use PhoenixTest.Case
  # @moduletag :playwright

  # @moduletag playwright: [headless: false, slow_mo: 1_000]

  test "heading", %{conn: conn} do
    conn
    |> visit("/people/new")
    |> assert_has("h1", text: "New person")
  end
end
