defmodule TaskListItem do
  use Hologram.Component

  alias HologramSkeleton.Task
  alias Hologram.UI.Link

  prop :task, Task

  def template do
    ~HOLO"""
    <li class="flex items-center justify-between gap-4 py-3">
      <Link
        to={HologramSkeleton.TaskPage, id: @task.id}
        class="truncate text-sm font-medium text-slate-700 hover:text-brand hover:underline"
      >
        {@task.title}
      </Link>
      <button
        $click={:delete_task, id: @task.id}
        class="shrink-0 rounded-lg px-2 py-1 text-xs font-semibold text-slate-400 transition hover:bg-red-50 hover:text-red-500"
      >
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4">
        <path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
      </svg>

      </button>
    </li>
    """
  end
end
