defmodule EctopicSocialTool.Utils do
  def get_app_url do
    System.get_env("APP_URL") || "http://localhost:4000"
  end

  def current_utc_datetime() do
    DateTime.utc_now() |> DateTime.truncate(:second)
  end

  def count_characters(text) do
    {:ok, cwd} = File.cwd()

    System.cmd(Path.join([cwd, "priv/bin/wc-tool"]), ["-ignore-pipe", "-text", text])
  end
end
