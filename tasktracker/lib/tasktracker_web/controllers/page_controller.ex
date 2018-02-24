defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def feed(conn, _params) do
    tasks = Tasktracker.Mission.my_todo_tasks(conn.assigns.current_user.id)
    users = Tasktracker.Accounts.list_users()
    times = Tasktracker.Mission.times_map_for()
    completed = Tasktracker.Mission.completed_map_for()
    render conn, "feed.html", tasks: tasks, users: users, times: times, completed: completed
  end

  def release(conn, _params) do
    tasks = Tasktracker.Mission.my_assigned_tasks(conn.assigns.current_user.id)
    users = Tasktracker.Accounts.list_users()
    render conn, "release.html", tasks: tasks, users: users
  end

  def profile(conn, _params) do
    manager = Tasktracker.Accounts.get_manager(conn.assigns.current_user.id)
    workers = Tasktracker.Accounts.list_workers(conn.assigns.current_user.id)
    render conn, "profile.html", manager: manager, workers: workers
  end
end
