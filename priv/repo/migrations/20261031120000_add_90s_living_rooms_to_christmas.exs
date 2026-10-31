defmodule Vibes.Repo.Migrations.Add90sLivingRoomsToChristmas do
  use Ecto.Migration

  @videos [
    %{
      "video_id" => "-6OKHIQQqIc",
      "title" =>
        "90s Christmas Ambience \u{1F384} Cozy Retro Living Room with Crackling Fireplace & Snowy Night | 3 Hours",
      "duration_seconds" => 10896,
      "start_seconds" => 30,
      "tune_in" => true,
      "verified_at" => "2026-10-31T12:00:00Z"
    },
    %{
      "video_id" => "cWRJ9xST2-M",
      "title" => "Christmas 1994 \u{1F384} Cozy 90s Living Room, Piano & Fireplace (3 Hours)",
      "duration_seconds" => 10800,
      "start_seconds" => 30,
      "tune_in" => true,
      "verified_at" => "2026-10-31T12:00:00Z"
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
        WHERE seed_key = 'christmas'
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
      WHERE seed_key = 'christmas'
      """,
      [ids]
    )
  end
end
