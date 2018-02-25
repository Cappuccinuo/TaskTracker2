defmodule TasktrackerWeb.PageView do
  use TasktrackerWeb, :view

  def complete_status(true), do: "Finished"
  def complete_status(false), do: "Working"
end
