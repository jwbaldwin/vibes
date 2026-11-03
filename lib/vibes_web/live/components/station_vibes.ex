defmodule VibesWeb.StationVibes do
  @moduledoc "Each built-in station's accent colour and the small weather shown on its picker tile."

  use VibesWeb, :html

  @vibes %{
    "spring" => {"#ff8fd0", :petals},
    "summer" => {"#ffcc33", :sun},
    "autumn" => {"#ff7a1a", :leaves},
    "winter" => {"#8fd8ff", :snow},
    "blade_runner" => {"#ff2bd6", :neon},
    "christmas" => {"#ff4d4d", :lights},
    "cozy" => {"#ffa64d", :candle},
    "locked_in" => {"#4dff88", :focus},
    "rainy_day" => {"#7fb2ff", :rain},
    "morning_coffee" => {"#d9a066", :steam},
    "azeroth" => {"#ffc94d", :runes}
  }

  # Stations added in the admin have no seed key, so they get the site's green and no weather.
  @fallback {"#4ade80", nil}

  def accent(seed_key), do: @vibes |> Map.get(seed_key, @fallback) |> elem(0)

  attr :seed_key, :string, required: true

  def weather(assigns) do
    assigns = assign(assigns, :kind, @vibes |> Map.get(assigns.seed_key, @fallback) |> elem(1))

    ~H"""
    <span :if={@kind} class={"station-weather weather-#{@kind}"} aria-hidden="true">
      <i :for={particle <- particles(@kind)} style={particle.style}>{particle.glyph}</i>
    </span>
    """
  end

  defp particles(:snow), do: falling(~w(❄ · *), 12, "4.2s")
  defp particles(:leaves), do: falling(~w(❦ ✦ ❧), 8, "4s")
  defp particles(:petals), do: falling(~w(✿ · ❀), 9, "4.6s")

  defp particles(:rain) do
    for i <- 0..13, do: particle("--x:#{rem(i * 29, 100)}%;--delay:-#{i * 0.11}s")
  end

  defp particles(:steam) do
    for i <- 0..3, do: particle("--x:#{35 + i * 9}%;--delay:-#{i * 0.7}s")
  end

  defp particles(:lights) do
    colors = ~w(#ff4d4d #4dff88 #ffd24d)

    for i <- 0..9 do
      particle(
        "--x:#{6 + i * 9.5}%;--y:#{10 + rem(i, 2) * 6}%;--delay:-#{rem(i, 3) * 0.47}s;--c:#{Enum.at(colors, rem(i, 3))}"
      )
    end
  end

  defp particles(:runes) do
    for {glyph, i} <- Enum.with_index(~w(ᚠ ᚱ ᛟ ᚹ ᛉ ᚦ)),
        do: particle("--x:#{10 + i * 15}%;--delay:-#{i * 0.5}s", glyph)
  end

  defp particles(:focus), do: [particle("", "> focus ")]
  defp particles(_glow), do: []

  defp falling(glyphs, count, duration) do
    for i <- 0..(count - 1) do
      particle(
        "--x:#{rem(i * 37, 100)}%;--delay:-#{Float.round(i * 0.43, 2)}s;--d:#{duration};" <>
          "--drift:#{if rem(i, 2) == 1, do: 10, else: -6}px;--spin:#{if rem(i, 2) == 1, do: 200, else: -160}deg;" <>
          "--s:#{9 + rem(i, 3) * 2}px",
        Enum.at(glyphs, rem(i, length(glyphs)))
      )
    end
  end

  defp particle(style, glyph \\ nil), do: %{style: style, glyph: glyph}
end
