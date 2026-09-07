defmodule HologramSkeleton.TasksPage do
  use Hologram.Page

  route "/tasks"
  layout HologramSkeleton.DefaultLayout

  alias HologramSkeleton.Task
  alias Hologram.UI.Link

  def template do
    ~HOLO"""
    <h1>Tasks</h1>

    <form $change="form_changed" $submit="form_submitted">
      <input type="text" name="title" placeholder="Create task..." value={@input_value} />
      <div>{@validation_error}</div>
      <button type="submit">Create</button>
    </form>

    <ul>
      {%for task <- @tasks}
        <li>
        <Link to={HologramSkeleton.TaskPage, id: task.id}>
          {task.title}
        </Link>

        <button $click={:delete_task, id: task.id}>Delete</button>
        </li>
      {/for}
    </ul>

    """
  end

  def init(_params, component, _server) do
    component
    |> put_state(:tasks, Task.list_tasks())
    |> put_state(:input_value, "")
    |> put_state(:validation_error, "")
  end

  def action(:form_changed, params, component) do
    validation_error =
      cond do
        params.event["title"] == "" -> "Title is required"
        true -> ""
      end

    component
    |> put_state(:validation_error, validation_error)
    |> put_state(:input_value, params.event["title"])
  end

  def action(:form_submitted, params, component) do
    put_command(component, :create_task, title: params.event["title"])
  end

  def action(:task_created, params, component) do
    component
    |> put_state(:tasks, component.state.tasks ++ [params.task])
    |> put_state(:validation_error, "")
    |> put_state(:input_value, "")
  end

  def action(:task_create_failed, _params, component) do
    component
    |> put_state(:validation_error, "Title is required")
    |> put_state(:input_value, "")
  end

  def action(:delete_task, params, component) do
    put_command(component, :delete_task, id: params.id)
  end

  def action(:task_deleted, params, component) do
    updated_tasks = Enum.reject(component.state.tasks, &(&1.id == params.id))
    put_state(component, :tasks, updated_tasks)
  end

  def command(:create_task, params, server) do
    case Task.create_tasks(%{title: params.title}) do
      {:ok, task} -> put_action(server, :task_created, task: task)
      {:error, _changeset} -> put_action(server, :task_create_failed)
    end
  end

  def command(:delete_task, params, server) do
    params.id
    |> Task.get_tasks!()
    |> Task.delete_tasks()

    put_action(server, :task_deleted, id: params.id)
  end
end
