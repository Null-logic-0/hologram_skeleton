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
      <body>
       <main class="px-4 py-20 sm:px-6 lg:px-8 antialiased">
          <div class="mx-auto max-w-2xl space-y-4">
            <slot />
          </div>
        </main>
      </body>
    </html>
    """
  end
end
