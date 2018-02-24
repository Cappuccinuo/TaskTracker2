defmodule TasktrackerWeb.TimeView do
  use TasktrackerWeb, :view
  alias TasktrackerWeb.TimeView

  def render("index.json", %{time: time}) do
    %{data: render_many(time, TimeView, "time.json")}
  end

  def render("show.json", %{time: time}) do
    %{data: render_one(time, TimeView, "time.json")}
  end

  def render("time.json", %{time: time}) do
    %{id: time.id,
      start_time: time.start_time,
      end_time: time.end_time}
  end
end
