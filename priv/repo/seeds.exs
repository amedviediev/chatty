# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Chatty.Repo.insert!(%Chatty.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Chatty.Repo.delete_all Chatty.Coherence.User

Chatty.Coherence.User.changeset(%Chatty.Coherence.User{}, %{name: "Test User", email: "test@test.com", password: "1111", password_confirmation: "1111"})
|> Chatty.Repo.insert!
|> Coherence.ControllerHelpers.confirm!
