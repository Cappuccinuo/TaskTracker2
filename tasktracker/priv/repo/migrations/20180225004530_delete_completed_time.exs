defmodule Tasktracker.Repo.Migrations.DeleteCompletedTime do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      remove :completed
      remove :time
    end
  end
end
