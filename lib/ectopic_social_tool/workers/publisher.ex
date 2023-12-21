defmodule EctopicSocialTool.Workers.Publisher do
  use Oban.Worker,
    queue: :publishers,
    max_attempts: 3

  require Logger
  alias EctopicSocialTool.Publishers.Linkedin

  @impl Worker
  def backoff(%Job{attempt: attempt}) do
    trunc(:math.pow(attempt, 4) + 15 + :rand.uniform(30) * attempt)
  end

  @impl Worker
  def perform(%Oban.Job{args: %{"provider" => provider} = args}) do
    # Logger.info("processing the job")

    case provider do
      "linkedin" ->
        Linkedin.publish(args)
    end
  end
end
