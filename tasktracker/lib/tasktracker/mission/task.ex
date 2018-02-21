defmodule Tasktracker.Mission.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Mission.Task


  schema "tasks" do
    field :description, :string
    field :title, :string
    field :completed, :boolean, default: false
    field :time, :integer, default: 0
    belongs_to :user, Tasktracker.Accounts.User
    belongs_to :worker, Tasktracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :completed, :time, :user_id, :worker_id])
    |> validate_required([:title, :description, :completed, :time, :user_id, :worker_id])
  end
end
