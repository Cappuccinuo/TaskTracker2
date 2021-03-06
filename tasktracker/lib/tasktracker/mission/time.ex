defmodule Tasktracker.Mission.Time do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Mission.Time
  alias Tasktracker.Mission.Task

  schema "time" do
    field :end_time, :utc_datetime, default: nil
    field :start_time, :utc_datetime, default: nil
    field :completed, :boolean, default: false
    belongs_to :task, Task

    timestamps()
  end

  @doc false
  def changeset(%Time{} = time, attrs) do
    time
    |> cast(attrs, [:start_time, :end_time, :completed, :task_id])
    |> validate_required([:start_time, :end_time, :completed, :task_id])
  end
end
