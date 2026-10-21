defmodule VibesWeb.FeedbackController do
  use VibesWeb, :controller
  def index(conn, _params), do: redirect(conn, to: "/?feedback=open")
end
