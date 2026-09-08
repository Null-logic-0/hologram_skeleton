defmodule TaskList do
  use Hologram.Component

  prop :tasks, List

  def template do
    ~HOLO"""
    <ul>
        {%for task <- @tasks}
        
          <TaskListItem task={task} />
        {/for}
      </ul>
    """
  end
end
