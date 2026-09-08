defmodule HologramSkeleton.DefaultLayout do
  use Hologram.Component

  def template do
    ~HOLO"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Hologram Skeleton</title>
        <link rel="stylesheet" href="/assets/app.css" />
        <Hologram.UI.Runtime />
      </head>
      <body class="bg-slate-50 font-sans text-slate-900 antialiased">
        <slot />
      </body>
    </html>
    """
  end
end
