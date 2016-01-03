defmodule Changelog.Podcast do
  use Changelog.Web, :model

  alias Changelog.Regexp

  schema "podcasts" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :vanity_domain, :string
    field :keywords, :string
    field :twitter_handle, :string

    has_many :episodes, Changelog.Episode, on_delete: :delete_all
    has_many :podcast_hosts, Changelog.PodcastHost, on_delete: :delete_all
    has_many :hosts, through: [:podcast_hosts, :person]

    timestamps
  end

  @required_fields ~w(name slug)
  @optional_fields ~w(vanity_domain description keywords twitter_handle)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:vanity_domain, Regexp.http, message: Regexp.http_message)
    |> validate_format(:slug, Regexp.slug, message: Regexp.slug_message)
    |> unique_constraint(:slug)
    |> cast_assoc(:podcast_hosts, required: true)
  end
end
