defmodule Tasktracker.Repo.Migrations.AddWorkerIdInTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :worker_id, references(:users)
    end
  end
end
