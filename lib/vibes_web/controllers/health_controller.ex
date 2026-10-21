defmodule VibesWeb.HealthController do
  use VibesWeb, :controller

  def show(conn, _params) do
    Ecto.Adapters.SQL.query!(Vibes.Repo, "SELECT 1", [])
    text(conn, "ok")
  end
end
