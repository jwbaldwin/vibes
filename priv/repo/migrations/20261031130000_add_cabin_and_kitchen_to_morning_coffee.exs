defmodule Vibes.Repo.Migrations.AddCabinAndKitchenToMorningCoffee do
  use Ecto.Migration

  @videos [
    %{
      "video_id" => "MmGkstX4v6s",
      "title" => "Saturday Morning Coffee Cabin Ambience With Fireplace And Snowfall",
      "duration_seconds" => 42898,
      "start_seconds" => 30,
      "tune_in" => true,
      "verified_at" => "2026-10-31T13:00:00Z"
    },
    %{
      "video_id" => "oqEpbAOZBEg",
      "title" =>
        "Full Autumn Cinnamon Roll Morning \u{1F342} Cozy Cottage Kitchen & Relaxing Music (5 Hours)",
      "duration_seconds" => 17963,
      "start_seconds" => 30,
      "tune_in" => true,
      "verified_at" => "2026-10-31T13:00:00Z"
    }
  ]

  # Appends rather than replaces, so edits made in the admin page survive.
  def up do
    for video <- @videos do
      repo().query!(
        """
        UPDATE stations
        SET videos = videos || jsonb_build_array($1::jsonb),
            lock_version = lock_version + 1,
            updated_at = now()
        WHERE seed_key = 'morning_coffee'
          AND NOT videos @> jsonb_build_array(jsonb_build_object('video_id', $2::text))
        """,
        [video, video["video_id"]]
      )
    end
  end

  def down do
    ids = Enum.map(@videos, & &1["video_id"])

    repo().query!(
      """
      UPDATE stations
      SET videos = (
            SELECT coalesce(jsonb_agg(video ORDER BY position), '[]'::jsonb)
            FROM jsonb_array_elements(videos) WITH ORDINALITY AS lineup(video, position)
            WHERE NOT video->>'video_id' = ANY($1)
          ),
          lock_version = lock_version + 1,
          updated_at = now()
      WHERE seed_key = 'morning_coffee'
      """,
      [ids]
    )
  end
end
