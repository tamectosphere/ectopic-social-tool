defmodule EctopicSocialToolWeb.ProviderAuthController do
  use EctopicSocialToolWeb, :controller

  alias EctopicSocialToolWeb.ProvidersAuth

  def provider_login(conn, %{"provider" => provider}) do
    with {:error, _} <- ProvidersAuth.request(conn, provider) do
      conn
      |> put_flash(:error, "Something went wrong generating the request authorization url")
      |> redirect(to: ~p"/publishing")
    end
  end

  def provider_callback(conn, %{"provider" => provider}) do
    case ProvidersAuth.callback(conn, provider) do
      :ok ->
        conn
        |> put_flash(:success, "Connect #{provider} account success")
        |> redirect(to: ~p"/publishing")

      :error ->
        conn
        |> put_flash(:error, "Failed login with #{provider} account")
        |> redirect(to: ~p"/publishing")
    end
  end
end
