defmodule Tasktracker.Repo.Migrations.AddCompleted do
  use Ecto.Migration

  def change do
    alter table(:time) do
      add :completed, :boolean, default: false, null: false
    end
  end
end
