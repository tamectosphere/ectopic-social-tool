defmodule EctopicSocialTool.Utils do
  def get_app_url do
    System.get_env("APP_URL") || "http://localhost:4000"
  end

  # def handle_http_response(body) do
  #   decoded_body = Jason.decode!(body)

  #   case decoded_body["status"] do
  #     200 ->
  #       {:success, decoded_body}

  #     _ ->
  #       {:failed, decoded_body}
  #   end
  # end
end
