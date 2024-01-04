defmodule EctopicSocialTool.Users.UserPost do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "users_posts" do
    belongs_to :user, EctopicSocialTool.Users.User
    belongs_to :post, EctopicSocialTool.Posts.Post

    timestamps(updated_at: false, type: :utc_datetime)
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [
      :user_id,
      :post_id
    ])
    |> validate_required([
      :user_id,
      :post_id
    ])
  end

  def get_user_post_cursor_query(query, user_id, social_account_id) do
    query
    |> join(:inner, [up], p in assoc(up, :post), as: :post)
    |> join(:inner, [up, p], sa in assoc(p, :social_account))
    |> join(:inner, [up, p, sa], op in assoc(sa, :oauth_provider))
    |> where(
      [up, p, sa, op],
      up.user_id == ^user_id and p.social_account_id == ^social_account_id
    )
    |> select([up, p, sa, op], %{
      id: p.id,
      type: p.type,
      status: p.status,
      scheduled_at: p.scheduled_at,
      completed_at: p.completed_at,
      return_post_id: p.return_post_id,
      inserted_at: p.inserted_at,
      provider: op.name,
      user_post_id: up.id
    })
    |> order_by([p], desc: p.id)
  end

  def get_user_post_query(query, where, select \\ nil, preload \\ []) do
    query
    |> apply_where(where)
    |> apply_preload(preload)
    |> apply_select(select)
  end

  defp apply_where(query, where) when is_list(where) do
    where(query, ^where)
  end

  defp apply_where(query, _), do: query

  defp apply_preload(query, preload) when is_list(preload) do
    preload(query, ^preload)
  end

  defp apply_preload(query, _), do: query

  defp apply_select(query, select) when is_list(select) do
    select(query, ^select)
  end

  defp apply_select(query, _), do: query
end
