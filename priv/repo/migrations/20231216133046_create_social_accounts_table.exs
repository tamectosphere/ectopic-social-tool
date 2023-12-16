defmodule EctopicSocialTool.Repo.Migrations.CreateSocialAccountsTable do
  use Ecto.Migration

  def change do
    create table(:oauth_providers) do
      add :name, :string, null: false
      add :logo_url, :string, null: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:oauth_providers, :name)

    create table(:social_accounts) do
      add :social_account_id, :string, null: false
      add :title, :string, null: false
      add :type, :string, null: false
      add :access_token, :text, null: false
      add :refresh_token, :text, null: true
      add :token_expired_at, :utc_datetime, null: false
      add :metadata, :map, default: "{}", null: false
      add :oauth_provider_id, references(:oauth_providers, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:social_accounts, [:social_account_id, :oauth_provider_id])
    create index(:social_accounts, :user_id)
  end
end
