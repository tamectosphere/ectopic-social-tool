# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

IO.inspect("Start running seeds")

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin2"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin3"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin4"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin5"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin6"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin7"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin8"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin9"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin10"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin11"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin12"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin13"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin14"
})

EctopicSocialTool.Repo.insert!(%EctopicSocialTool.SocialAccounts.OauthProvider{
  name: "linkedin15"
})

IO.inspect("End seeds")
