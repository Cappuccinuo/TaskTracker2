defmodule TasktrackerWeb.PageView do
  use TasktrackerWeb, :view

  def complete_status(true), do: "Finished"
  def complete_status(false), do: "Working"

  def cast_time(time) do
    dt = DateTime.truncate(time, :second)
    %DateTime{year: y, month: m, day: d} = dt
    if (y == 1970 and m == 1 and d == 1) do
      "Not end yet"
    else
      {:ok, time} = Ecto.DateTime.cast(dt)
      time
    end
  end
end
