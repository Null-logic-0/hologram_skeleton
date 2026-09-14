# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HologramSkeleton.Repo.insert!(%HologramSkeleton.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HologramSkeleton.Repo
alias HologramSkeleton.Task.Tasks

[
  "Smoke the Hologram docs",
  "Catch the BEAM in 4K",
  "Run the code, not your mouth",
  "Ship the damn feature",
  "Hunt the bug",
  "Catch up with the codebase",
  "Put the PRs on trial",
  "Merge or die trying",
  "Break the compiler",
  "Make the machine talk"
]
|> Enum.each(fn title ->
  Repo.insert!(%Tasks{title: title})
end)
