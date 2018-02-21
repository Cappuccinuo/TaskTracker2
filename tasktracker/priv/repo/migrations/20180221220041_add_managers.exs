defmodule Tasktracker.Repo.Migrations.AddManagers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :manager_id, references(:users)
    end
  end
end
