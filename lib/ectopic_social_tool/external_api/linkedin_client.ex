defmodule EctopicSocialTool.ExternalApi.LinkedinClient do
  @x_restli_protocol_version "2.0.0"
  @request_name EctopicSocialTool.Finch

  @behaviour EctopicSocialTool.ExternalApi.LinkedinBehaviour

  @impl true
  def post_content(body_params, access_token) do
    url = "#{get_linkedin_api_url()}/#{get_linkedin_api_version()}/ugcPosts"

    Finch.build(:post, url, build_header_request(access_token), body_params |> Jason.encode!())
    |> Finch.request(@request_name)
  end

  defp build_header_request(access_token) do
    [
      {"X-Restli-Protocol-Version", @x_restli_protocol_version},
      {"Authorization", "Bearer #{access_token}"}
    ]
  end

  defp get_linkedin_api_url, do: System.fetch_env!("LINKEDIN_API_URL")
  defp get_linkedin_api_version, do: System.fetch_env!("LINKEDIN_API_VERSION")
end
