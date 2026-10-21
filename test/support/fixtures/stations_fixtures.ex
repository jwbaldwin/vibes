defmodule Vibes.StationsFixtures do
  def station_named(name), do: Vibes.Repo.get_by!(Vibes.Stations.Station, name: to_string(name))

  def station_attrs(attrs \\ %{}) do
    Map.merge(
      %{
        "name" => "Night train",
        "category" => "Travel",
        "shortcut" => "n",
        "position" => 20,
        "image_url" => "https://example.com/train.webp",
        "effect" => "none",
        "videos" => [%{"video_id" => "abcdefghijk", "title" => "First video"}]
      },
      attrs
    )
  end
end
