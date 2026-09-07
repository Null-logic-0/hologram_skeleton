[
  import_deps: [:ecto, :ecto_sql, :phoenix, :hologram],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,app,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
