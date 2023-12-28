defmodule EctopicSocialTool.Posts do
  alias EctopicSocialTool.Repo
  alias EctopicSocialTool.Posts.Post

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
end
