defmodule EctopicSocialTool.Repo.Migrations.AlterPostsTable do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      modify :return_post_id, :string, null: true, from: {:string, null: false}
    end
  end
end
