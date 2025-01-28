# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AutocompleteTestbed.Repo.insert!(%AutocompleteTestbed.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias AutocompleteTestbed.Organizations.Organization
alias AutocompleteTestbed.Repo

# Create 10 organizations
organizations = [
  "Acme Corporation",
  "Globex Industries",
  "Stark Enterprises",
  "Wayne Enterprises",
  "Umbrella Corporation",
  "Cyberdyne Systems",
  "Oscorp Industries",
  "Initech",
  "Hooli",
  "Pied Piper"
]

Enum.each(organizations, fn name ->
  Repo.insert!(%Organization{
    name: name
  })
end)

IO.puts "Created #{length(organizations)} organizations"
