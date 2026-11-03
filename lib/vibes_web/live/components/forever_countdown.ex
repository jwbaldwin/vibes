defmodule VibesWeb.ForeverCountdown do
  @moduledoc "Counts down to the World of Warcraft: Forever launch on the Azeroth station."

  use VibesWeb, :html

  # 3 PM PT / 6 PM ET on Wednesday, November 4, 2026.
  @launch_at ~U[2026-11-04 23:00:00Z]

  @tips [
    "the innkeeper in goldshire is polishing every mug",
    "murlocs are warming up their vocals. mrglglgl.",
    "hogger has been told. hogger is ready.",
    "pack extra linen bandages",
    "your hearthstone is set to: right here",
    "barrens chat is already arguing about something",
    "leeroy is stretching",
    "fishing counts as a lifestyle",
    "do not stand in the fire",
    "the kobolds still want their candles back",
    "stay hydrated. the boar quests are long."
  ]

  attr :now, DateTime, default: nil

  def countdown(assigns) do
    seconds_left = max(DateTime.diff(@launch_at, assigns.now || DateTime.utc_now()), 0)

    assigns =
      assign(assigns,
        launch_at: DateTime.to_iso8601(@launch_at),
        state: if(seconds_left == 0, do: "live", else: "counting"),
        clock: format_clock(seconds_left),
        tips: @tips
      )

    ~H"""
    <div
      id="forever-countdown"
      phx-hook="ForeverCountdown"
      phx-update="ignore"
      data-launch-at={@launch_at}
      data-state={@state}
      data-tips={Jason.encode!(@tips)}
      class="ascii-surface forever-countdown"
    >
      <VibesWeb.AsciiFrame.border />
      <div class="forever-heading">-=[ wow: forever ]=-</div>
      <div class="forever-counting">
        <div class="forever-label">the gates of azeroth open in</div>
        <div class="forever-clock" data-clock role="timer">{@clock}</div>
        <div class="forever-label">wed nov 4 · 6pm et</div>
      </div>
      <div class="forever-live">
        <div class="forever-clock">the gates are open</div>
        <div class="forever-label">see you in elwynn forest</div>
      </div>
      <button type="button" class="forever-tip" data-tip title="another tip">
        tip: {hd(@tips)}
      </button>
    </div>
    """
  end

  def format_clock(seconds) do
    days = div(seconds, 86_400)
    hours = seconds |> rem(86_400) |> div(3600)

    clock =
      "~2..0Bh ~2..0Bm ~2..0Bs"
      |> :io_lib.format([hours, div(rem(seconds, 3600), 60), rem(seconds, 60)])
      |> IO.iodata_to_binary()

    if days > 0, do: "#{days}d #{clock}", else: clock
  end
end
