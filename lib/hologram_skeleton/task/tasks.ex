defmodule HologramSkeleton.Task.Tasks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tasks, attrs) do
    tasks
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
