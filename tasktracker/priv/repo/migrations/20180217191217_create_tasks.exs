defmodule Tasktracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :text, null: false
      add :description, :text, null: false
      add :completed, :boolean, default: false, null: false
      add :time, :integer, default: 0, null: false
      add :user_id, references(:users)

      timestamps()
    end
    create index(:tasks, [:user_id])
  end
end
