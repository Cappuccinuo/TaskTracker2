defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Mission
  alias Tasktracker.Mission.Task
  alias Tasktracker.Accounts
  alias Tasktracker.Repo
  alias Tasktracker.Accounts.User

  plug :check_task_owner when action in [:update, :edit, :delete]
  plug :check_manager when action in [:create]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
            [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _current_user) do
    tasks = Mission.list_tasks()
    users = Accounts.list_users()
    task_initiator_map = Mission.task_initiator_map_for()
    task_worker_map = Mission.task_worker_map_for()
    render(conn, "index.html", tasks: tasks, users: users, timap: task_initiator_map, twmap: task_worker_map)
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

  def new(conn, _params, current_user) do
    changeset = Mission.change_task(%Task{})
    users = Accounts.list_workers(current_user.id)
    workers = Accounts.list_workers(conn.assigns.current_user.id)
    render(conn, "new.html", users: users, changeset: changeset, workers: workers)
  end

  def create(conn, %{"task" => task_params}, _current_user) do
    %{"worker_id" => worker_id} = task_params
    user = Accounts.User |> Repo.get!(worker_id)
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
    workers = Accounts.list_workers(conn.assigns.current_user.id)
    render(conn, "edit.html", task: task, users: users, workers: workers, changeset: changeset)
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

  def check_manager(conn, _params) do
    %{"task" => task_params} = conn.body_params
    %{"worker_id" => worker_id} = task_params
    case Repo.get(User, worker_id) do
      nil ->
        conn
        |> put_flash(:error, "Invalid Worker_id")
        |> redirect(to: task_path(conn, :new))
        |> halt()
      user ->
        if user.manager_id == conn.assigns.current_user.id do
          conn
        else
          conn
          |> put_flash(:error, "You are not manager")
          |> redirect(to: task_path(conn, :index))
          |> halt()
        end
    end
  end

  def check_task_owner(conn, _params) do
    %{params: %{"id" => task_id}} = conn

    if Repo.get(Task, task_id).user_id == conn.assigns.current_user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: task_path(conn, :index))
      |> halt()
    end
  end
end
