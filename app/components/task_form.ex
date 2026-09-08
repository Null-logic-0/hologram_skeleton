defmodule TaskForm do
  use Hologram.Component

  prop :input_value, :string
  prop :validation_error, :string
  prop :change_handler, :function
  prop :submit_handler, :function

  def template do
    ~HOLO"""
    <form $change={@change_handler} $submit={@submit_handler}>
        <input type="text" name="title" placeholder="Create task..." value={@input_value} />
        <div>{@validation_error}</div>
        <button type="submit">Create</button>
      </form>
    """
  end
end
