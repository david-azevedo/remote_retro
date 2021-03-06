defmodule FirstTimeUserExperienceTest do
  use RemoteRetro.IntegrationCase, async: false
  alias RemoteRetro.{Participation}

  import ShorterMaps


  describe "a user with no prior retro experience" do
    setup [:remove_any_prior_participations_in_retros]

    test "is welcomed as a new user who can create a retrospective", ~M{session} do
      visit(session, "/retros")

      assert_has(session, Query.css("body", text: "Welcome, Test!"))
      assert_user_can_create_their_first_retrospective(session)
    end
  end

  defp remove_any_prior_participations_in_retros(%{facilitator: user} = context) do
    user_id = user.id
    from(p in Participation, where: p.user_id == ^user_id) |> Repo.delete_all

    context
  end

  defp assert_user_can_create_their_first_retrospective(session) do
    # the blue retro creation button isn't visible on page load due to javascript-managed delay
    session
    |> click(Query.css("form .blue.button[type='submit']", visible: false))
    |> assert_has(Query.css(".center.aligned.header", text: "Share the retro link below with teammates!"))
  end
end
