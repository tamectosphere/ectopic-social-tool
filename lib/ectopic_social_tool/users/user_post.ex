defmodule EctopicSocialTool.Users.UserPost do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "users_posts" do
    belongs_to :user, EctopicSocialTool.Users.User
    belongs_to :post, EctopicSocialTool.Posts.Post

    timestamps(updated_at: false)
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

  # def get_user_post_cursor_query(query, user_id) do
  #   query
  #   |> join(:inner, [sa], op in assoc(sa, :oauth_provider))
  #   |> where([sa], sa.user_id == ^user_id)
  #   |> select([sa, op], %{id: sa.id, title: sa.title, provider_name: op.name})
  #   |> order_by([sa], asc: sa.id)
  # end

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
