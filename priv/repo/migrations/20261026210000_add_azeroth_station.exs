defmodule Vibes.Repo.Migrations.AddAzerothStation do
  use Ecto.Migration

  @videos [
    %{
      "video_id" => "eoHFwSsMbsw",
      "title" => "World of Warcraft but it's lofi beats ~ Collector's Edition",
      "duration_seconds" => 7200,
      "start_seconds" => 30,
      "tune_in" => true,
      "verified_at" => "2026-10-26T21:00:00Z"
    },
    %{
      "video_id" => "Oeo2VCCtUZQ",
      "title" => "Alliance Taverns - Music & Ambience - World of Warcraft",
      "duration_seconds" => 3600,
      "start_seconds" => 30,
      "tune_in" => true,
      "verified_at" => "2026-10-26T20:45:00Z"
    },
    %{
      "video_id" => "-uxi6_5cFqw",
      "title" => "WoW Lofi Beats To Chill To | Waiting for BlizzCon",
      "duration_seconds" => 10969,
      "start_seconds" => 30,
      "tune_in" => true,
      "verified_at" => "2026-10-26T20:45:00Z"
    }
  ]

  def up do
    repo().query!(
      """
      INSERT INTO stations
        (name, seed_key, shortcut, position, image_url, effect, category, videos, inserted_at, updated_at)
      VALUES
        ('azeroth', 'azeroth', 'q', 10, '/images/themes/vibes/azeroth/thumbs/1.webp', 'none', 'vibes',
         $1::jsonb, now(), now())
      """,
      [@videos]
    )
  end

  def down do
    execute("DELETE FROM stations WHERE seed_key = 'azeroth'")
  end
end
