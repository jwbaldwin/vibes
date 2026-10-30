defmodule VibesWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use VibesWeb, :controller` and
  `use VibesWeb, :live_view`.
  """
  use VibesWeb, :html

  embed_templates "layouts/*"

  attr :preview, VibesWeb.SharePreview, required: true

  def share_tags(assigns) do
    ~H"""
    <meta name="description" content={@preview.description} />
    <meta property="og:type" content="website" />
    <meta property="og:site_name" content="Vibes" />
    <meta property="og:title" content={@preview.title} />
    <meta property="og:description" content={@preview.description} />
    <meta property="og:url" content={@preview.url} />
    <meta property="og:locale" content="en_US" />
    <meta property="og:image" content={@preview.image} />
    <meta property="og:image:type" content="image/jpeg" />
    <meta property="og:image:width" content="1200" />
    <meta property="og:image:height" content="630" />
    <meta property="og:image:alt" content={@preview.image_alt} />
    <%= if @preview.video do %>
      <meta property="og:video" content={@preview.video} />
      <meta property="og:video:secure_url" content={@preview.video} />
      <meta property="og:video:type" content="video/mp4" />
      <meta property="og:video:width" content="1200" />
      <meta property="og:video:height" content="630" />
    <% end %>
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content={@preview.title} />
    <meta name="twitter:description" content={@preview.description} />
    <meta name="twitter:image" content={@preview.image} />
    <meta name="twitter:image:alt" content={@preview.image_alt} />
    """
  end
end
