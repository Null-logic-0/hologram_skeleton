defmodule HologramSkeleton.TaskPage do
  use Hologram.Page

  route "/tasks/:id"
  param :id, :integer

  layout HologramSkeleton.DefaultLayout

  alias Hologram.UI.Link
  alias HologramSkeleton.Task

  def template do
    ~HOLO"""
    <h1>Task {@task.id}</h1>
    <p>{@task.title}</p>
    <Link to={HologramSkeleton.TasksPage}>Back</Link>
    """
  end

  def init(params, component, _server) do
    put_state(component, :task, Task.get_tasks!(params.id))
  end
end
