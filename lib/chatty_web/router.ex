defmodule ChattyWeb.Router do
  use ChattyWeb, :router
  use Coherence.Router

  defp put_user_token(conn, _) do
    current_user = Coherence.current_user(conn).id
    user_id_token = Phoenix.Token.sign(conn, "user_id",
      Coherence.current_user(conn).id)
    conn
    |> assign(:user_id, user_id_token)
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", ChattyWeb do
    pipe_through :browser # Use the default browser stack


  end

  scope "/", ChattyWeb do
    pipe_through :protected
    # Add protected routes below
    get "/", PageController, :index
  end
end
