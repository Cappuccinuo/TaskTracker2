defmodule TasktrackerWeb.UserController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User

  #plug :check_user_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    users = Accounts.list_users()
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    users = Accounts.list_users()
    %{"manager_id" => manager_id} = user_params
    if manager_id != "" and Tasktracker.Repo.get(Tasktracker.Accounts.User, manager_id) == nil do
      conn
      |> put_flash(:error, "manager_id invalid")
      |> redirect(to: user_path(conn, :new))
      |> halt()
    else
      case Accounts.create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User #{user.name} created successfully.")
          |> redirect(to: user_path(conn, :show, user))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset, users: users)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    users = Accounts.list_users()
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    %{"manager_id" => manager_id} = user_params
    if Tasktracker.Repo.get(Tasktracker.Accounts.User, manager_id) == nil do
      conn
      |> put_flash(:error, "manager_id invalid")
      |> redirect(to: user_path(conn, :index))
      |> halt()
    else
      user = Accounts.get_user!(id)

      case Accounts.update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: user_path(conn, :show, user))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def check_user_owner(conn, %{"id" => id}) do
    if id == conn.assigns.current_user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: user_path(conn, :index))
      |> halt()
    end
  end
end
