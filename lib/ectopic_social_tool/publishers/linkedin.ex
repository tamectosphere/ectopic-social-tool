defmodule EctopicSocialTool.Publishers.Linkedin do
  require Logger

  def publish(args) do
    args |> inspect() |> Logger.info()
  end
end
