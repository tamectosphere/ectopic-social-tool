defmodule EctopicSocialToolWeb.ProvidersAuth do
  import Plug.Conn

  alias Assent.Config
  alias EctopicSocialTool.Utils

  def request(conn, provider) do
    config = config!(provider)
    strategy = config[:strategy]

    case config |> strategy.authorize_url() do
      {:ok, %{url: url, session_params: session_params}} ->
        # Session params (used for OAuth 2.0 and OIDC strategies) will be
        # retrieved when user returns for the callback phase
        conn = put_session(conn, :session_params, session_params)

        # Redirect end-user to Github to authorize access to their account
        conn
        |> put_resp_header("location", url)
        |> send_resp(302, "")

      {:error, error} ->
        {:error, error}
    end
  end

  def callback(conn, provider) do
    %{params: params} = fetch_query_params(conn)
    session_params = get_session(conn, :session_params)

    config = config!(provider)
    updated_config = Assent.Config.put(config, :session_params, session_params)
    strategy = updated_config[:strategy]

    case updated_config |> strategy.callback(params) do
      {:ok, %{user: user, token: token} = result} ->
        :ok

      {:error, error} ->
        :error
    end
  end

  defp config!(provider) when is_binary(provider) do
    config = get_provider_config(provider)

    config
    |> Config.put(:redirect_uri, "#{Utils.get_app_url()}/auth/#{provider}/callback")
    |> Config.put(:http_adapter, {Assent.HTTPAdapter.Finch, supervisor: EctopicSocialTool.Finch})
  end

  defp get_provider_config(provider) when is_binary(provider) do
    case provider do
      "linkedin" ->
        [
          client_id: System.fetch_env!("LINKEDIN_CLIENT_ID"),
          client_secret: System.fetch_env!("LINKEDIN_CLIENT_SECRET"),
          authorization_params: [scope: "openid email profile w_member_social"],
          strategy: Assent.Strategy.Linkedin
        ]

      _ ->
        raise "invalid provider"
    end
  end
end
