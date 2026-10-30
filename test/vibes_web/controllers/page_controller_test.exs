defmodule VibesWeb.PageControllerTest do
  use VibesWeb.ConnCase
  import Vibes.StationsFixtures

  test "GET / includes sharing metadata without JavaScript", %{conn: conn} do
    html = conn |> get(~p"/") |> html_response(200) |> LazyHTML.from_document()

    expected = %{
      "og:type" => "website",
      "og:site_name" => "Vibes",
      "og:title" => "Vibes — Good vibes for every occasion",
      "og:url" => "https://vibes.jwbaldwin.com/",
      "og:image" => "https://vibes.jwbaldwin.com/images/vibes-og.jpg",
      "og:image:type" => "image/jpeg",
      "og:image:width" => "1200",
      "og:image:height" => "630",
      "twitter:card" => "summary_large_image"
    }

    for {key, value} <- expected do
      assert meta(html, key) == [value]
    end

    for field <- ~w(title description image image:alt) do
      assert [value] = meta(html, "og:#{field}")
      assert value != ""
      assert meta(html, "twitter:#{field}") == [value]
    end

    assert [_description] = meta(html, "description")
  end

  test "a station link shares its own title and address", %{conn: conn} do
    {:ok, _} = Vibes.Stations.create_station(station_attrs())
    html = conn |> get("/night-train") |> html_response(200) |> LazyHTML.from_document()

    assert meta(html, "og:url") == ["https://vibes.jwbaldwin.com/night-train"]
    assert [title] = meta(html, "og:title")
    assert title =~ "Night Train"
    assert meta(html, "twitter:title") == [title]
    assert meta(html, "og:image") == ["https://vibes.jwbaldwin.com/images/vibes-og.jpg"]
    assert meta(html, "og:video") == []
  end

  test "a station with preview art shares its image and looping video", %{conn: conn} do
    # The azeroth station comes from its migration.
    html = conn |> get("/azeroth") |> html_response(200) |> LazyHTML.from_document()
    video = "https://vibes.jwbaldwin.com/images/og/azeroth.mp4"

    assert meta(html, "og:image") == ["https://vibes.jwbaldwin.com/images/og/azeroth.jpg"]
    assert meta(html, "twitter:image") == meta(html, "og:image")
    assert meta(html, "og:video") == [video]
    assert meta(html, "og:video:secure_url") == [video]
    assert meta(html, "og:video:type") == ["video/mp4"]

    for {path, type} <- [
          {"/images/og/azeroth.jpg", "image/jpeg"},
          {"/images/og/azeroth.mp4", "video/mp4"}
        ] do
      assert build_conn() |> get(path) |> get_resp_header("content-type") == [type]
    end
  end

  test "an unknown station link sends visitors home", %{conn: conn} do
    assert redirected_to(get(conn, "/no-such-station")) == ~p"/"
  end

  test "sharing image is served publicly as JPEG", %{conn: conn} do
    conn = get(conn, "/images/vibes-og.jpg")
    assert get_resp_header(conn, "content-type") == ["image/jpeg"]
    assert response(conn, 200) == File.read!("priv/static/images/vibes-og.jpg")
  end

  defp meta(html, key) do
    html
    |> LazyHTML.query("head meta[property='#{key}'], head meta[name='#{key}']")
    |> LazyHTML.attribute("content")
  end
end
