defmodule EctopicSocialTool.UsersFixture do
  alias EctopicSocialTool.Repo
  alias EctopicSocialTool.Users.User
  alias EctopicSocialTool.SocialAccounts.SocialAccount
  alias EctopicSocialTool.SocialAccounts.OauthProvider
  alias EctopicSocialTool.Utils

  def user_fixture() do
    %User{}
    |> User.registration_changeset(%{
      email: "example@gmail.com",
      hash_password: Bcrypt.hash_pwd_salt("oKNdMds9!iJibpdh")
    })
    |> Repo.insert!()
  end

  def oauth_provider_fixture() do
    struct = %OauthProvider{
      name: "linkedin"
    }

    Repo.insert!(struct)
  end

  def social_account_fixture(oauth_provider_id, user_id) do
    struct = %SocialAccount{
      social_account_id: Ecto.UUID.generate(),
      title: "John",
      type: :personal,
      access_token: "access_token",
      token_expired_at: Utils.current_utc_datetime(),
      metadata: %{},
      oauth_provider_id: oauth_provider_id,
      user_id: user_id
    }

    Repo.insert!(struct)
  end
end
