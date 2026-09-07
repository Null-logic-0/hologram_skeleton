defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  route "/"
  alias Hologram.UI.Link

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <h1>Hello from Hologram!</h1>
    <p>Count: {@count}</p>
    <button $click={:increment, by: 1}>Increment</button>
    <button $click={:reset, by: 0}>Reset</button>
    <button $click={:decrement, by: 1}>Decrement</button>

    <Link to={HologramSkeleton.TasksPage}>Tasks</Link>

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
