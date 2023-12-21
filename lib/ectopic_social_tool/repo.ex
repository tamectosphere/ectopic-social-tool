defmodule EctopicSocialTool.Repo do
  use Ecto.Repo,
    otp_app: :ectopic_social_tool,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
