defmodule Tasktracker.Repo.Migrations.CreateTime do
  use Ecto.Migration

  def change do
    create table(:time) do
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :task_id, references(:tasks, on_delete: :delete_all), null: false
      add :completed, :boolean, default: false, null: false

      timestamps()
    end

    create index(:time, [:task_id])
  end
end
