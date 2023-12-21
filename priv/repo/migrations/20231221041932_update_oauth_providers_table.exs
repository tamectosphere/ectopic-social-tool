defmodule EctopicSocialTool.Repo.Migrations.UpdateOauthProvidersTable do
  use Ecto.Migration

  def change do
    alter table(:oauth_providers) do
      add :is_active, :boolean, default: true, null: false
    end
  end
end
