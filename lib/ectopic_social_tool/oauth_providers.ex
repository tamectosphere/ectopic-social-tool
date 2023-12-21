defmodule EctopicSocialTool.OauthProviders do
  alias EctopicSocialTool.Repo
  alias EctopicSocialTool.SocialAccounts.OauthProvider

  def get_oauth_providers_cursor() do
    query = OauthProvider |> OauthProvider.get_oauth_provider_cursor_query()

    Repo.paginate(
      query,
      include_total_count: true,
      cursor_fields: [:id],
      limit: 5
    )
  end

  def get_oauth_providers_cursor(cursor, :after) do
    query = OauthProvider |> OauthProvider.get_oauth_provider_cursor_query()

    Repo.paginate(
      query,
      after: cursor,
      include_total_count: true,
      cursor_fields: [:id],
      limit: 5
    )
  end

  def get_oauth_providers_cursor(cursor, :before) do
    query = OauthProvider |> OauthProvider.get_oauth_provider_cursor_query()

    Repo.paginate(
      query,
      before: cursor,
      include_total_count: true,
      cursor_fields: [:id],
      limit: 5
    )
  end
end
