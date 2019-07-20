defmodule DscanWeb.PageController do
  use DscanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
