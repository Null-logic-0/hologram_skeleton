defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  route "/"
  alias Hologram.UI.Link

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
      <div class="flex items-center justify-center px-4">
      <div class="rounded-2xl bg-base-200 p-8 text-center shadow-lg">
        <h1 class="text-2xl font-bold">Hello from Hologram!</h1>

        <p class="mt-6 text-5xl font-extrabold tabular-nums text-brand">{@count}</p>
        <p class="mt-1 text-sm font-medium uppercase tracking-wide text-slate-400">Count</p>

        <div class="mt-6 flex items-center justify-center gap-2">
          <button
            $click={:decrement, by: 1}
            class="btn btn-primary"
          >
            −
          </button>
          <button
            $click={:reset, by: 0}
            class="btn btn-outline"
          >
            Reset
          </button>
          <button
            $click={:increment, by: 1}
            class="btn btn-primary"
          >
            +
          </button>
        </div>

        <div class="divider"></div>

        <Link
          to={HologramSkeleton.TasksPage}
          class="btn btn-primary btn-outline"
        >
          Tasks →
        </Link>

      </div>
    </div>
    """
  end

  def init(_params, component, _server) do
    put_state(component, :count, 0)
  end

  def action(:increment, params, component) do
    put_state(component, :count, component.state.count + params.by)
  end

  def action(:decrement, params, component) when component.state.count - params.by < 0 do
    put_state(component, :count, 0)
  end

  def action(:decrement, params, component) do
    put_state(component, :count, component.state.count - params.by)
  end

  def action(:reset, _params, component) do
    put_state(component, :count, 0)
  end
end
