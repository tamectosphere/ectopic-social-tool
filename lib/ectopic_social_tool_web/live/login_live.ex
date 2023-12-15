defmodule EctopicSocialToolWeb.LoginLive do
  use EctopicSocialToolWeb, :live_view

  alias EctopicSocialTool.Users

  def render(assigns) do
    ~H"""
    <.toast_group flash={@flash} />
    <.right_half_layout />
    <.left_half_layout>
      <.header class="text-center">
        Log in
      </.header>
      <.ectopic_form
        for={@form}
        id="login_form"
        phx-submit="login"
        phx-trigger-action={@trigger_submit}
        action={~p"/login"}
        method="post"
      >
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.link navigate={~p"/register"} class="text-sm font-semibold">
            Create an account
          </.link>
        </:actions>
        <:actions>
          <.ectopic_button type="submit" phx-disable-with="Signing in..." class="w-full animate-none">
            Log in →
          </.ectopic_button>
        </:actions>
      </.ectopic_form>
    </.left_half_layout>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")

    socket =
      socket
      |> assign(trigger_submit: false)

    {:ok, assign(socket, form: form), layout: false, temporary_assigns: [form: form]}
  end

  def handle_event(
        "login",
        %{"user" => %{"email" => email, "password" => password}},
        socket
      ) do
    :timer.sleep(500)

    case Users.login(email, password) do
      true ->
        form = to_form(%{"email" => email, "password" => password}, as: "user")
        socket = socket |> assign(trigger_submit: true) |> assign(form: form)
        {:noreply, socket |> assign(trigger_submit: true) |> assign(form: form)}

      false ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid email or password")}
    end
  end
end
