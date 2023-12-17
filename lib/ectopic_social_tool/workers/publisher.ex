defmodule EctopicSocialTool.Workers.Publisher do
  use Oban.Worker,
    queue: :publishers,
    max_attempts: 3

  require Logger
  alias EctopicSocialTool.Publishers.{Linkedin}

  @impl Worker
  def backoff(%Oban.Job{attempt: attempt}) do
    trunc(:math.pow(attempt, 4) + 15 + :rand.uniform(30) * attempt)
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"provider" => provider} = args}) do
    Logger.info("processing the job")

    case provider do
      "linkedin" ->
        Linkedin.publish(args)
        :ok

      _ ->
        {:error, "invalid provider: #{provider}"}
    end
  end
end
