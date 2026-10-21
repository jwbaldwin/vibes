defmodule VibesWeb.ErrorHTMLTest do
  use VibesWeb.ConnCase, async: true

  test "renders 404.html" do
    assert VibesWeb.ErrorHTML.render("404.html", %{}) == "Not Found"
  end

  test "renders 500.html" do
    assert VibesWeb.ErrorHTML.render("500.html", %{}) == "Internal Server Error"
  end
end
