defmodule HologramSkeleton.TasksPage do
  use Hologram.Page

  route "/tasks"
  layout HologramSkeleton.DefaultLayout

  alias HologramSkeleton.Task
  alias Hologram.UI.Link

  @channel :tasks

  def template do
    ~HOLO"""
    <div class="rounded-2xl bg-base-200 p-8 shadow-lg">
      <h1 class="text-2xl font-bold">Todo</h1>
      <Link
        to={HologramSkeleton.HomePage}
        class="text-sm font-semibold text-brand hover:underline"
      >
        ← Home
      </Link>

      <form $submit={:form_submitted} class="my-6 flex items-center gap-2">
        <input
          type="text"
          name="title"
          placeholder="Create task..."
          value={@input_value}
          $change={:input_changed}
          class="flex-1 input"
        />
        <button type="submit" class="btn btn-primary">Add</button>

      </form>
      {%if @validation_error != ""}
        <p class="mt-2 text-sm font-medium text-red-500">{@validation_error}</p>
      {/if}

      {%if @tasks == []}
        <p class="py-6 text-center text-sm text-slate-400">No tasks yet.</p>
      {%else}
        <ul class="divide-y divide-slate-200">
          {%for task <- @tasks}
            <li class="flex items-center justify-between gap-4 py-3">
              <span class="text-sm">{task.title}</span>
              <button
                $click={:delete_task, id: task.id}
                class="btn btn-ghost shrink-0 text-slate-400 hover:text-red-600"

              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="size-4"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"
                  />
                </svg>
              </button>
            </li>
          {/for}
        </ul>
      {/if}
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

  # Input-level $change: the event carries only this element's value,
  # under the :value key. There is no :title key here.
  def action(:input_changed, params, component) do
    title = params.event.value

    component
    |> put_state(:input_value, title)
    |> put_state(:validation_error, validate(title))
  end

  # Form-level $submit: the event carries every field, keyed by input
  # name as an atom. The input is synchronized, so state is already the
  # source of truth and the event isn't needed.
  def action(:form_submitted, _params, component) do
    title = component.state.input_value

    case validate(title) do
      "" -> put_command(component, :create_task, title: title)
      error -> put_state(component, :validation_error, error)
    end
  end

  def action(:task_created, params, component) do
    component
    |> put_state(:tasks, component.state.tasks ++ [params.task])
    |> put_state(:input_value, "")
    |> put_state(:validation_error, "")
  end

  # Keep what the user typed so they can correct it.
  def action(:task_create_failed, params, component) do
    put_state(component, :validation_error, params.error)
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

      {:error, changeset} ->
        put_action(server, :task_create_failed, error: changeset_error(changeset))
    end
  end

  def command(:delete_task, params, server) do
    # The row may already be gone if another instance deleted it first.
    # Let that case fall through to the same success path so this client
    # still drops the task from its list.
    try do
      params.id
      |> Task.get_tasks!()
      |> Task.delete_tasks()
    rescue
      Ecto.NoResultsError -> :ok
    end

    server
    |> put_action(:task_deleted, id: params.id)
    |> put_broadcast_except(
      {:instance, server.instance_id},
      @channel,
      :task_deleted,
      id: params.id
    )
  end

  # Runs client-side and server-side alike.
  defp validate(title) do
    if String.trim(title || "") == "" do
      "Title is required"
    else
      ""
    end
  end

  defp changeset_error(changeset) do
    case changeset.errors do
      [{_field, {message, _opts}} | _rest] -> message
      [] -> "Could not create task"
    end
  end
end
