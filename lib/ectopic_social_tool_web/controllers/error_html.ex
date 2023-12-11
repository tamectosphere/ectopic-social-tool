defmodule EctopicSocialToolWeb.ErrorHTML do
  use EctopicSocialToolWeb, :html

  # If you want to customize your error pages,
  # uncomment the embed_templates/1 call below
  # and add pages to the error directory:
  #
  #   * lib/ectopic_social_tool_web/controllers/error_html/404.html.heex
  #   * lib/ectopic_social_tool_web/controllers/error_html/500.html.heex
  #
  embed_templates "error_html/*"

  # The default is to render a plain text page based on
  # the template name. For example, "404.html" becomes
  # "Not Found".
  # def render("404.html", _assigns) do
  #   "Page Not Found"
  # end
end
