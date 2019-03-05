import Ecto.Changeset

defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  alias Rumbl.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name, username), [])
    |> validate_length(:username, min: 1, max: 20)
  end

  def index(conn, _params) do
    users = Repo.all(Rumbl.User)
    render(conn, "index.html", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    # IO.puts("params passed in: #{user_params}")

    changeset = User.changeset(%User{}, user_params)
    {:ok, user} = Repo.insert(changeset)

    conn
    |> put_flash(:info, "#{user.name} created")
    |> redirect(to: user_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumbl.User, id)
    render(conn, "show.html", user: user)
  end
end
