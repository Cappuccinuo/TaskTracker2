defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Mission
  alias Tasktracker.Mission.Task
  alias Tasktracker.Accounts
  alias Tasktracker.Repo

  plug :check_task_owner when action in [:update, :edit, :delete]



  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
            [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _current_user) do
    tasks = Mission.list_tasks()
    users = Accounts.list_users()
    render(conn, "index.html", tasks: tasks, users: users)
  end

  #def index(conn, _params, current_user) do
  #  user = Accounts.User |> Repo.get!(current_user.id)
  #  tasks =
  #    user
  #    |> user_tasks
  #    |> Repo.all
  #    |> Repo.preload(:user)
  #  render(conn, "index.html", tasks: tasks)
  #end

  def new(conn, _params, _current_user) do
    changeset = Mission.change_task(%Task{})
    users = Accounts.list_users()
    render(conn, "new.html", users: users, changeset: changeset)
  end

  def create(conn, %{"task" => task_params}, _current_user) do
    #%{"worker_id" => worker_id} = task_params
    #user = Accounts.User |> Repo.get!(worker_id)
    #changeset = user
    changeset = conn.assigns.current_user
      |> Ecto.build_assoc(:tasks)
      |> Task.changeset(task_params)
    case Repo.insert(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error,changeset} ->
        #conn
        #|> put_flash(:info, "Invalid.")
        #|> redirect(to: task_path(conn, :index))
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user) do
    task = Mission.get_task!(id)
    render(conn, "show.html", task: task)
  end

  #def show(conn, %{"user_id" => user_id, "id" => id}, _current_user) do
  #  user = User |> Repo.get!(user_id)
  #  task = user |> user_task_by_id(id) |> Repo.preload(:user)
  #  render(conn, "show.html", task: task, user: user)
  #end

  def edit(conn, %{"id" => id}, _current_user) do
    task = Mission.get_task!(id)
    users = Accounts.list_users()
    changeset = Mission.change_task(task)
    render(conn, "edit.html", task: task, users: users, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}, _current_user) do
    task = Mission.get_task!(id)

    case Mission.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user) do
    task = Mission.get_task!(id)
    {:ok, _task} = Mission.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end

  defp user_tasks(user) do
    Ecto.assoc(user, :tasks)
  end

  defp user_task_by_id(user, task_id) do
    user
    |> user_tasks
    |> Repo.get(task_id)
  end

  def check_task_owner(conn, _params) do
    %{params: %{"id" => task_id}} = conn

    if Repo.get(Task, task_id).user_id == conn.assigns.current_user.id
      or Repo.get(Task, task_id).worker_id == conn.assigns.current_user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: task_path(conn, :index))
      |> halt()
    end
  end
end
