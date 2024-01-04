defmodule EctopicSocialTool.Publishers do
  alias EctopicSocialTool.Repo
  alias EctopicSocialTool.Workers.Publisher
  alias EctopicSocialTool.SocialAccounts
  alias EctopicSocialTool.Posts.Post
  alias EctopicSocialTool.Users.UserPost

  require Logger

  def enqueue_job(social_account, currect_user, published_content) do
    is_scheduled_post = published_content["is_scheduled_post"] === "true"

    with current_social_account <- SocialAccounts.get_social_account_by_id(social_account["id"]),
         {:ok, true} <- SocialAccounts.social_account_exists?(current_social_account),
         {:ok, true} <-
           SocialAccounts.belong_to_user?(current_social_account.user_id, currect_user.id),
         post_changeset <-
           get_post_changeset(social_account["id"], published_content, is_scheduled_post),
         multi <-
           build_create_post_multi(
             post_changeset,
             currect_user.id,
             is_scheduled_post,
             published_content["scheduled_at"],
             social_account["provider_name"]
           ) do
      case Repo.transaction(multi) do
        {:ok,
         %{
           create_post: post,
           create_user_post: user_post,
           create_queue_worker: _
         }} ->
          {:ok,
           %{
             id: post.id,
             scheduled_at: post.scheduled_at,
             status: :pending,
             type: post.type,
             completed_at: nil,
             post_link: nil,
             user_post_id: user_post.id,
             inserted_at: post.inserted_at
           }}

        {:error, failed_operation, _, _changes_so_far} ->
          {:error, failed_operation}
      end
    end
  end

  defp get_post_changeset(social_account_id, published_content, is_scheduled_post) do
    post_type = is_scheduled_post |> get_post_type()

    attrs = %{
      content: published_content,
      type: post_type,
      status: :pending,
      scheduled_at: published_content["scheduled_at"],
      social_account_id: social_account_id
    }

    %Post{} |> Post.changeset(attrs, post_type)
  end

  defp get_post_type(false), do: :now
  defp get_post_type(true), do: :scheduled

  defp build_create_post_multi(
         post_changeset,
         user_id,
         is_scheduled_post,
         scheduled_at,
         provider_name
       ) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:create_post, post_changeset)
    |> Ecto.Multi.insert(:create_user_post, fn %{
                                                 create_post: post
                                               } ->
      %UserPost{} |> UserPost.changeset(%{user_id: user_id, post_id: post.id})
    end)
    |> Ecto.Multi.run(:create_queue_worker, fn _repo, %{create_post: post} ->
      insert_worker(post.id, provider_name, scheduled_at, is_scheduled_post)
    end)
  end

  defp insert_worker(post_id, provider_name, _, false) do
    %{post_id: post_id, provider: provider_name}
    |> Publisher.new(tags: [provider_name])
    |> Oban.insert()
  end

  defp insert_worker(post_id, provider_name, scheduled_at, true) do
    %{post_id: post_id, provider: provider_name}
    |> Publisher.new(scheduled_at: scheduled_at, tags: [provider_name])
    |> Oban.insert()
  end
end
