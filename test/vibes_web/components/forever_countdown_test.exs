defmodule VibesWeb.ForeverCountdownTest do
  use VibesWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias VibesWeb.ForeverCountdown

  test "counts down to 6 PM ET on November 4" do
    html =
      render_component(&ForeverCountdown.countdown/1, now: ~U[2026-11-03 19:37:50Z])

    assert html =~ ~s(data-state="counting")
    assert html =~ "1d 03h 22m 10s"
  end

  test "drops the day once launch is under a day away" do
    assert ForeverCountdown.format_clock(59) == "00h 00m 59s"
  end

  test "switches to the live state at launch" do
    html = render_component(&ForeverCountdown.countdown/1, now: ~U[2026-11-04 23:00:00Z])
    assert html =~ ~s(data-state="live")
  end
end
