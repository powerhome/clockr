defmodule Clockr.PageController do
  use Clockr.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
