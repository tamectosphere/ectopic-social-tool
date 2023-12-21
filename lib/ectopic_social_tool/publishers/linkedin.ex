defmodule EctopicSocialTool.Publishers.Linkedin do
  require Logger

  @x_restli_protocol_version "2.0.0"

  def publish(args) do
    body_params =
      get_body_params(args["data"]["urn"], args["data"]["text"], args["data"]["visibility"])

    case make_request(body_params) do
      {:ok, %Finch.Response{body: _, status: 200}} ->
        :ok

      {:ok, %Finch.Response{body: body, status: status}} ->
        {:error, %{status: status, message: Jason.decode!(body)["message"]}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp make_request(body_params) do
    url = "#{get_linkedin_api_url()}/#{get_linkedin_api_version()}/ugcPosts"

    Finch.build(:post, url, get_header_request(), body_params)
    |> Finch.request(EctopicSocialTool.Finch)
  end

  defp get_body_params(urn, text, visibility) do
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

  defp get_header_request() do
    [
      {"X-Restli-Protocol-Version", @x_restli_protocol_version}
    ]

    #   {"Authorization",
    #    "Bearer AQVb6EU9fOV8MWM-DVuUjLXNR1sVZGfAl5pp92Xdsx4rT33YJ6sguIW0fD49hXUjvoj3tViygRbPI8vb0sn-p-Q1Rw5MVuIk8Nv1p_LUZeNu-we1pxlZKFi3df1XzgYbQPAyLnV918EPzWuFsxTZgok210qELfjsoqZqEOk8BY7_iqGVCLwULhxK7hLhvaPgTwPxBS9PyeY-un5Y6Dk365YopFXxJsKfisGTGDGYrwBF6YBjiWt8D3ApchYj0oQgB6eztLtmzoWqnSeiPxVCBsGwo0atqSmT4gwMG_wxlj2bUtSUrwbTKAtDSbxXmZo2MH8aK0jvHizCfhA1xs2rEwSaHfMKhw"}
    # ]
  end

  defp get_linkedin_base_url, do: System.fetch_env!("LINKEDIN_BASE_URL")
  defp get_linkedin_api_url, do: System.fetch_env!("LINKEDIN_API_URL")
  defp get_linkedin_api_version, do: System.fetch_env!("LINKEDIN_API_VERSION")
end
