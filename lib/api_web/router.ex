defmodule ApiWeb.Router do
  use ApiWeb, :router

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

  #scope "/", ApiWeb do
  #  pipe_through :browser
  #
  #  get "/", PageController, :index
  #end

  #Other scopes may use custom stacks.
  scope "/:repository", ApiWeb do
    pipe_through :api

    get  "/", RepoController, :index
    post "/", RepoController, :index
  end
end
