defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession   # checks for a token existence in a session
    plug Guardian.Plug.LoadResource    # fetches a value from token's sub field and
                                       # serializes it with the serializer module
                                       # we've created earlier
    plug TasktrackerWeb.CurrentUser
  end

  scope "/", TasktrackerWeb do
    pipe_through [:browser, :with_session] # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/tasks", TaskController
    resources "/sessions", SessionController
    get "/feed", PageController, :feed
    get "/release", PageController, :release

  end

  # Other scopes may use custom stacks.
  # scope "/api", TasktrackerWeb do
  #   pipe_through :api
  # end
end
