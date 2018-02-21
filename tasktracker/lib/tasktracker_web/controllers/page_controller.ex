defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def feed(conn, _params) do
    tasks = Tasktracker.Mission.list_tasks()
    users = Tasktracker.Accounts.list_users()
    render conn, "feed.html", tasks: tasks, users: users
  end

  def release(conn, _params) do
    tasks = Tasktracker.Mission.list_tasks()
    users = Tasktracker.Accounts.list_users()
    render conn, "release.html", tasks: tasks, users: users
  end
end
