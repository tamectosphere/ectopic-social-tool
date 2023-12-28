defmodule EctopicSocialTool.ExternalApi.LinkedinBehaviour do
  @callback post_content(map(), binary) ::
              {:ok, Finch.Response.t()} | {:error, Exception.t()}
end
