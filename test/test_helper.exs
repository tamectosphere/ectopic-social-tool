ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(EctopicSocialTool.Repo, :manual)

Mox.defmock(EctopicSocialTool.ExternalApi.LinkedinBehaviourMock,
  for: EctopicSocialTool.ExternalApi.LinkedinBehaviour
)

Application.put_env(
  :ectopic_social_tool,
  :http_linkedin_client,
  EctopicSocialTool.ExternalApi.LinkedinBehaviourMock
)
