defmodule EctopicSocialTool.Workers.Publisher do
  use Oban.Worker,
    queue: :publishers,
    max_attempts: 3

  require Logger

  alias EctopicSocialTool.Posts
  alias EctopicSocialTool.Publishers.Linkedin

  @impl Worker
  def backoff(%Job{attempt: attempt}) do
    trunc(:math.pow(attempt, 4) + 15 + :rand.uniform(30) * attempt)
  end

  @impl Worker
  def perform(%Oban.Job{attempt: attempt, args: %{"provider" => provider, "post_id" => post_id}}) do
    post = Posts.get_post_by_id(post_id)

    case post do
      nil ->
        {:cancel, "Post not found"}

      _ ->
        case provider do
          "linkedin" ->
            Linkedin.publish(post, attempt)
        end
    end
  end
end
