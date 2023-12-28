defmodule EctopicSocialTool.Publishers.Linkedin do
  require Logger
  alias EctopicSocialTool.Repo
  alias EctopicSocialTool.Utils

  def publish(post, attempt) do
    social_account = post.social_account

    body_params =
      build_body_params(
        social_account.social_account_id,
        post.content.text,
        post.content.visibility
      )

    case EctopicSocialTool.http_client(:linkedin).post_content(
           body_params,
           social_account.access_token
         ) do
      {:error, reason} ->
        handle_publish_error(post, reason, attempt)

      {:ok, %Finch.Response{body: body, status: status}} ->
        handle_publish_response(post, Jason.decode!(body), status, attempt)
    end
  end

  defp build_body_params(urn, text, visibility) do
    Jason.encode!(%{
      author: "urn:li:person:#{urn}",
      lifecycleState: "PUBLISHED",
      specificContent: %{
        "com.linkedin.ugc.ShareContent": %{
          shareCommentary: %{text: text},
          shareMediaCategory: "NONE"
        }
      },
      visibility: %{
        "com.linkedin.ugc.MemberNetworkVisibility": visibility
      }
    })
  end

  defp handle_publish_response(post, body, 200, _) do
    case Repo.update(
           Ecto.Changeset.change(post, %{
             status: :completed,
             result: body,
             completed_at: Utils.current_utc_datetime(),
             return_post_id: transform_return_post_id(body["id"])
           })
         ) do
      {:ok, _} ->
        {:ok, true}

      {:error, changeset} ->
        {:cancel, changeset}
    end
  end

  defp handle_publish_response(post, body, _, attempt)
       when attempt >= 3 do
    case Repo.update(
           Ecto.Changeset.change(post, %{
             status: :failed,
             result: body,
             completed_at: Utils.current_utc_datetime()
           })
         ) do
      {:ok, _} ->
        {:ok, true}

      {:error, changeset} ->
        {:cancel, changeset}
    end
  end

  defp handle_publish_response(_, body, status, attempt)
       when attempt < 3 do
    {:error, %{status: status, message: body["message"]}}
  end

  defp handle_publish_error(post, reason, attempt) when attempt >= 3 do
    case Repo.update(
           Ecto.Changeset.change(post, %{
             status: :failed,
             result: %{reason: reason},
             completed_at: Utils.current_utc_datetime()
           })
         ) do
      {:ok, _} ->
        {:ok, true}

      {:error, changeset} ->
        {:cancel, changeset}
    end
  end

  defp handle_publish_error(_, reason, attempt) when attempt < 3 do
    {:error, %{reason: reason}}
  end

  def transform_return_post_id(id) when is_binary(id), do: String.split(id, ":") |> List.last()
end
