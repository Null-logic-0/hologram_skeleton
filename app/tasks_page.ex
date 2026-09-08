defmodule HologramSkeleton.TasksPage do
  use Hologram.Page

  route "/tasks"
  layout HologramSkeleton.DefaultLayout

  alias HologramSkeleton.Task
  alias Hologram.UI.Link

  @channel :tasks

  def template do
    ~HOLO"""
    <div class="flex min-h-screen justify-center bg-slate-50 px-4 py-16">
      <div class="w-full max-w-xl rounded-2xl bg-white p-8 shadow-lg ring-1 ring-slate-200">
        <div class="mb-6 flex items-center justify-between">
          <h1 class="text-2xl font-bold text-slate-900">Tasks</h1>
          <Link
            to={HologramSkeleton.HomePage}
            class="text-sm font-semibold text-brand hover:underline"
          >
            ← Home
          </Link>
        </div>

        <TaskForm
          change_handler="form_changed"
          submit_handler="form_submitted"
          input_value={@input_value}
          validation_error={@validation_error}
        />

        <TaskList tasks={@tasks} />
      </div>
    </div>
    """
  end

  def init(_params, component, server) do
    component =
      component
      |> put_state(:tasks, Task.list_tasks())
      |> put_state(:input_value, "")
      |> put_state(:validation_error, "")

    {component, put_subscription(server, @channel)}
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
      {:ok, task} ->
        server
        |> put_action(:task_created, task: task)
        |> put_broadcast_except(
          {:instance, server.instance_id},
          @channel,
          :task_created,
          task: task
        )

      {:error, _changeset} ->
        put_action(server, :task_create_failed)
    end
  end

  def command(:delete_task, params, server) do
    params.id
    |> Task.get_tasks!()
    |> Task.delete_tasks()

    server
    |> put_action(:task_deleted, id: params.id)
    |> put_broadcast_except({:instance, server.instance_id}, @channel, :task_deleted,
      id: params.id
    )
  end
end
