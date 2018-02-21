defmodule Tasktracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do

      add :email, :string, null: false
      add :name, :string, null: false

      timestamps()
    end
    # add unique index in order to allow only unique email be stored in the db
    create unique_index(:users, [:email])
  end
end
