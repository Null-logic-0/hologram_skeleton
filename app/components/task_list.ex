defmodule TaskList do
  use Hologram.Component

  prop :tasks, List

  def template do
    ~HOLO"""
    {%if @tasks == []}
      <p class="py-6 text-center text-sm text-slate-400">No tasks yet.</p>
    {/if}
    <ul class="divide-y divide-slate-200">
      {%for task <- @tasks}
        <TaskListItem task={task} />
      {/for}
    </ul>
    """
  end
end
