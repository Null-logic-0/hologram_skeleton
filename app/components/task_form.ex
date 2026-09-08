defmodule TaskForm do
  use Hologram.Component

  prop :input_value, :string
  prop :validation_error, :string
  prop :change_handler, :function
  prop :submit_handler, :function

  def template do
    ~HOLO"""
    <form class="mb-6" $change={@change_handler} $submit={@submit_handler}>
      <div class="flex gap-2">
        <input
          type="text"
          name="title"
          placeholder="Create task..."
          value={@input_value}
          class="flex-1 rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand"
        />
        <button
          type="submit"
          class="rounded-lg bg-brand px-4 py-2 text-sm font-semibold text-white transition hover:opacity-90"
        >
          Create
        </button>
      </div>
      {%if @validation_error != ""}
        <div class="mt-2 text-sm font-medium text-red-500">{@validation_error}</div>
      {/if}
    </form>
    """
  end
end
