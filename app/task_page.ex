defmodule HologramSkeleton.TaskPage do
  use Hologram.Page

  route "/tasks/:id"
  param :id, :integer

  layout HologramSkeleton.DefaultLayout

  alias Hologram.UI.Link
  alias HologramSkeleton.Task

  def template do
    ~HOLO"""
    <div class="flex min-h-screen items-center justify-center bg-slate-50 px-4">
      <div class="w-full max-w-sm rounded-2xl bg-white p-8 text-center shadow-lg ring-1 ring-slate-200">
        <p class="text-sm font-medium uppercase tracking-wide text-slate-400">Task {@task.id}</p>
        <h1 class="mt-2 text-2xl font-bold text-slate-900">{@task.title}</h1>

        <Link
          to={HologramSkeleton.TasksPage}
          class="mt-8 inline-block text-sm font-semibold text-brand hover:underline"
        >
          ← Back
        </Link>
      </div>
    </div>
    """
  end

  def init(params, component, _server) do
    put_state(component, :task, Task.get_tasks!(params.id))
  end
end
