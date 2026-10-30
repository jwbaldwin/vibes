defmodule VibesWeb.SharePreview do
  @moduledoc """
  The link preview that chat apps and social sites read from a page's first
  server render. A station uses its own `/images/og/<slug>.jpg` and
  `/images/og/<slug>.mp4` when those files exist.
  """

  alias Vibes.Stations.Station

  # Previews always point at production, even from dev or test renders.
  @origin "https://vibes.jwbaldwin.com"

  defstruct [:title, :description, :url, :image, :image_alt, :video]

  def site do
    %__MODULE__{
      title: "Vibes — Good vibes for every occasion",
      description: "Music and ambient videos for focus, relaxation, and everything in between.",
      url: @origin <> "/",
      image: @origin <> "/images/vibes-og.jpg",
      image_alt:
        "Ivory ceramic Vibes lettering in front of a listener surrounded by autumn leaves, snow, coffee, and a pink sunset. Good vibes for every occasion."
    }
  end

  def station(%Station{} = station) do
    slug = Station.slug(station)
    name = station.name |> String.split() |> Enum.map_join(" ", &String.capitalize/1)

    preview = %{
      site()
      | title: "#{name} — Vibes",
        description: "Tune in to #{name} on Vibes. Music and ambient video, always on.",
        url: "#{@origin}/#{slug}",
        video: asset_url(slug, "mp4")
    }

    case asset_url(slug, "jpg") do
      nil -> preview
      image -> %{preview | image: image, image_alt: "Artwork for the #{name} station on Vibes."}
    end
  end

  defp asset_url(slug, extension) do
    path = "/images/og/#{slug}.#{extension}"
    if File.exists?(Application.app_dir(:vibes, "priv/static" <> path)), do: @origin <> path
  end
end
