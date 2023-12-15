defmodule EctopicSocialTool.Utils do
  def get_app_url do
    System.get_env("APP_URL") || "http://localhost:4000"
  end
end
