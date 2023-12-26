defmodule EctopicSocialTool.Repo.Migrations.AddPostsTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :map, default: "{}", null: false
      add :type, :string, null: false
      add :status, :string, null: false
      add :result, :map, default: "{}", null: false
      add :return_post_id, :string, null: false
      add :scheduled_at, :utc_datetime, null: true
      add :completed_at, :utc_datetime, null: true
      add :social_account_id, references(:social_accounts, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:posts, [:social_account_id])

    create table(:users_posts) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :post_id, references(:posts, on_delete: :nothing), null: false

      timestamps(updated_at: false, type: :utc_datetime)
    end

    create unique_index(:users_posts, [:user_id, :post_id])
  end
end
