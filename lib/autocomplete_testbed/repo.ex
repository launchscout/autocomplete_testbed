defmodule AutocompleteTestbed.Repo do
  use Ecto.Repo,
    otp_app: :autocomplete_testbed,
    adapter: Ecto.Adapters.Postgres
end
