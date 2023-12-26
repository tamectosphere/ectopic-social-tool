defmodule EctopicSocialTool.Publishers do
  alias EctopicSocialTool.Workers.Publisher

  require Logger

  def enqueue_job(social_account, currect_user, published_content) do
    IO.inspect(social_account, label: "social_account")
    IO.inspect(currect_user, label: "currect_user")
    IO.inspect(published_content, label: "published_content")
  end

  # def enqueue_job(provider) do
  #   Logger.info("✨ Enqueued from #{provider}! ✨")

  #   %{
  #     provider: provider,
  #     data: %{
  #       urn: "mNcXGNZ5kF",
  #       visibility: "PUBLIC",
  #       text: "Hello from Phoenix Elixir! This is my first Share on LinkedIn!"
  #     }
  #   }
  #   |> Publisher.new(tags: [provider])
  #   |> Oban.insert()
  #   |> inspect()
  #   |> Logger.info()
  # end

  # def enqueue_job(provider, scheduled_at) do
  #   Logger.info("✨ Enqueued from #{provider}! ✨")

  #   %{provider: provider, message: "Hello, test"}
  #   |> Publisher.new(scheduled_at: scheduled_at, tags: [provider])
  #   |> Oban.insert()
  #   |> inspect()
  #   |> Logger.info()
  # end
end
