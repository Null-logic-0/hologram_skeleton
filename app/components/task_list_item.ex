defmodule TaskListItem do
  use Hologram.Component

  alias HologramSkeleton.Task
  alias Hologram.UI.Link

  prop :task, Task

  def template do
    ~HOLO"""
    <li>
      <Link to={HologramSkeleton.TaskPage, id: @task.id}>
        {@task.title}
      </Link>
      <button $click={:delete_task, id: @task.id}>Delete</button>
    </li>
    """
  end
end
