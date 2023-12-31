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
  name: "linkedin"
})

IO.inspect("End seeds")
