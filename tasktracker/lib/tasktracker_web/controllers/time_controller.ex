defmodule TasktrackerWeb.TimeController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Mission
  alias Tasktracker.Mission.Time

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    time = Mission.list_time()
    render(conn, "index.json", time: time)
  end

  def create(conn, %{"time" => time_params}) do
    with {:ok, %Time{} = time} <- Mission.create_time(time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", time_path(conn, :show, time))
      |> render("show.json", time: time)
    end
  end

  def show(conn, %{"id" => id}) do
    time = Mission.get_time!(id)
    render(conn, "show.json", time: time)
  end

  def update(conn, %{"id" => id, "time" => time_params}) do
    time = Mission.get_time!(id)

    with {:ok, %Time{} = time} <- Mission.update_time(time, time_params) do
      render(conn, "show.json", time: time)
    end
  end

  def delete(conn, %{"id" => id}) do
    time = Mission.get_time!(id)
    with {:ok, %Time{}} <- Mission.delete_time(time) do
      send_resp(conn, :no_content, "")
    end
  end
end
