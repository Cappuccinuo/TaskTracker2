defmodule Tasktracker.Mission.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Mission.Task
  alias Tasktracker.Mission.Time


  schema "tasks" do
    field :description, :string
    field :title, :string
    belongs_to :user, Tasktracker.Accounts.User
    belongs_to :worker, Tasktracker.Accounts.User
    has_many :task_time, Time, foreign_key: :task_id

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :user_id, :worker_id])
    |> validate_required([:title, :description, :user_id, :worker_id])
  end
end
