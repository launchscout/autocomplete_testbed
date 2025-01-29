{:ok, _} = Application.ensure_all_started(:wallaby)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(AutocompleteTestbed.Repo, :manual)
Application.put_env(:phoenix_test, :base_url, AutocompleteTestbedWeb.Endpoint.url())
