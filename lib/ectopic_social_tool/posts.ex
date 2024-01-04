defmodule EctopicSocialTool.Posts do
  alias EctopicSocialTool.Repo
  alias EctopicSocialTool.Posts.Post
  alias EctopicSocialTool.Users.UserPost
  alias EctopicSocialTool.Publishers.Linkedin

  def get_post_by_id(post_id) do
    Post.get_post_query(
      Post,
      [
        id: post_id
      ],
      nil,
      [:social_account]
    )
    |> Repo.one()
  end

  def post_exists?(nil) do
    {:error, "Post not found"}
  end

  def post_exists?(_) do
    {:ok, true}
  end

  defp get_user_post_by_id(user_post_id) do
    UserPost
    |> UserPost.get_user_post_query(
      [
        id: user_post_id
      ],
      nil,
      post: [social_account: [:oauth_provider]]
    )
    |> Repo.one()
  end

  def get_transform_user_post(user_post_id) when is_integer(user_post_id) do
    user_post = get_user_post_by_id(user_post_id)

    %{
      id: user_post.post.id,
      type: user_post.post.type,
      status: user_post.post.status,
      scheduled_at: user_post.post.scheduled_at,
      completed_at: user_post.post.completed_at,
      return_post_id: user_post.post.return_post_id,
      inserted_at: user_post.post.inserted_at,
      provider: user_post.post.social_account.oauth_provider.name,
      user_post_id: user_post.id,
      post_link:
        get_post_link(
          user_post.post.return_post_id,
          user_post.post.social_account.oauth_provider.name
        )
    }
  end

  def get_user_posts_cursor(user_id, social_account_id) do
    query = UserPost |> UserPost.get_user_post_cursor_query(user_id, social_account_id)

    Repo.paginate(
      query,
      include_total_count: true,
      cursor_fields: [{{:post, :id}, :desc}],
      limit: 5
    )
    |> transform_user_posts()
  end

  def get_user_posts_cursor(user_id, social_account_id, cursor, :after) do
    query = UserPost |> UserPost.get_user_post_cursor_query(user_id, social_account_id)

    Repo.paginate(
      query,
      after: cursor,
      include_total_count: true,
      cursor_fields: [{{:post, :id}, :desc}],
      limit: 5
    )
    |> transform_user_posts()
  end

  def get_user_posts_cursor(user_id, social_account_id, cursor, :before) do
    query = UserPost |> UserPost.get_user_post_cursor_query(user_id, social_account_id)

    Repo.paginate(
      query,
      before: cursor,
      include_total_count: true,
      cursor_fields: [{{:post, :id}, :desc}],
      limit: 5
    )
    |> transform_user_posts()
  end

  defp transform_user_posts(%{entries: entries, metadata: metadata}) do
    updated_entries =
      Enum.map(entries, fn entry ->
        post_link = get_post_link(entry.return_post_id, entry.provider)
        Map.put(entry, :post_link, post_link)
      end)

    %{entries: updated_entries, metadata: metadata}
  end

  defp get_post_link(nil, _) do
    nil
  end

  defp get_post_link(return_post_id, "linkedin") do
    Linkedin.generate_published_post_link(return_post_id)
  end
end
