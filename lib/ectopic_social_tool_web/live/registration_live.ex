defmodule EctopicSocialToolWeb.RegistrationLive do
  use EctopicSocialToolWeb, :live_view

  alias EctopicSocialTool.Users
  alias EctopicSocialTool.Users.User

  def render(assigns) do
    ~H"""
    <.right_half_layout />
    <.left_half_layout>
      <.header class="text-center">
        Log in
      </.header>
      <div class="space-y-8">
        <div>
          <.ectopic_form
            for={@form}
            class="space-y-8"
            id="registration_form"
            phx-submit="save"
            phx-change="validate"
            phx-trigger-action={@trigger_submit}
            action={~p"/login?_action=registered"}
            method="post"
          >
            <.input
              field={@form[:email]}
              class="input"
              type="email"
              label="Email"
              required
              phx-debounce="blur"
            />
            <.input field={@form[:password]} type="password" label="Password" required />

            <:actions>
              <.ectopic_button phx-disable-with="Creating account..." class="w-full animate-none">
                Create an account
              </.ectopic_button>
            </:actions>
          </.ectopic_form>
        </div>
        <div>
          Already registered?
          <.link navigate={~p"/login"} class="font-semibold text-brand hover:underline">
            Login
          </.link>
        </div>
      </div>
    </.left_half_layout>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Users.get_user_registration_changeset(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil], layout: false}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    with false <- duplicated_email?(user_params, socket) do
      case Users.register_user(user_params) do
        {:ok, user} ->
          changeset = Users.get_user_registration_changeset(user)
          {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
      end
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.get_user_registration_changeset(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  defp duplicated_email?(user_params, socket) do
    case Users.get_user_by_email(user_params["email"]) do
      nil ->
        false

      _ ->
        changeset =
          Users.get_user_registration_changeset(%User{}, user_params)
          |> Ecto.Changeset.add_error(:email, "Email is already used.")

        {:noreply,
         socket
         |> assign(check_errors: true)
         |> assign_form(Map.put(changeset, :action, :validate))}
    end
  end
end
