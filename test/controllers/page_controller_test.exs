defmodule Clockr.PageControllerTest do
  use Clockr.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "elm_target"
  end
end
