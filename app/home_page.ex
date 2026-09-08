defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  route "/"
  alias Hologram.UI.Link

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <div class="flex min-h-screen items-center justify-center bg-slate-50 px-4">
      <div class="w-full max-w-sm rounded-2xl bg-white p-8 text-center shadow-lg ring-1 ring-slate-200">
        <h1 class="text-2xl font-bold text-slate-900">Hello from Hologram!</h1>

        <p class="mt-6 text-5xl font-extrabold tabular-nums text-brand">{@count}</p>
        <p class="mt-1 text-sm font-medium uppercase tracking-wide text-slate-400">Count</p>

        <div class="mt-6 flex justify-center gap-2">
          <button
            $click={:decrement, by: 1}
            class="rounded-lg bg-slate-100 px-4 py-2 font-semibold text-slate-700 transition hover:bg-slate-200"
          >
            −
          </button>
          <button
            $click={:reset, by: 0}
            class="rounded-lg bg-slate-100 px-4 py-2 font-semibold text-slate-700 transition hover:bg-slate-200"
          >
            Reset
          </button>
          <button
            $click={:increment, by: 1}
            class="rounded-lg bg-brand px-4 py-2 font-semibold text-white transition hover:opacity-90"
          >
            +
          </button>
        </div>

        <Link
          to={HologramSkeleton.TasksPage}
          class="mt-8 inline-block text-sm font-semibold text-brand hover:underline"
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
