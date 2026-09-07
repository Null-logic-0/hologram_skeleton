defmodule HologramSkeleton.TaskFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HologramSkeleton.Task` context.
  """

  @doc """
  Generate a tasks.
  """
  def tasks_fixture(attrs \\ %{}) do
    {:ok, tasks} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> HologramSkeleton.Task.create_tasks()

    tasks
  end
end
