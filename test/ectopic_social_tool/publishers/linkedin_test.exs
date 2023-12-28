defmodule EctopicSocialToolWeb.EctopicSocialTool.Publishers.LinkedinTest do
  alias EctopicSocialTool.Publishers.Linkedin

  use ExUnit.Case, async: true
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  describe("transform_return_post_id/1") do
    test("success", _) do
      assert(
        Linkedin.transform_return_post_id("urn:li:share:123456789") ==
          "123456789"
      )
    end
  end
end
