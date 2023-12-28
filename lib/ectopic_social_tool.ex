defmodule EctopicSocialTool do
  @moduledoc """
  EctopicSocialTool keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def http_client(:linkedin) do
    Application.get_env(:ectopic_social_tool, :http_linkedin_client)
  end
end
