defmodule EctopicSocialToolWeb.CoreComponents.SharedComponents do
  use Phoenix.Component
  alias EctopicSocialToolWeb.CoreComponents

  # alias Phoenix.LiveView.JS
  import EctopicSocialToolWeb.Gettext

  slot :inner_block, required: true

  def left_half_layout(assigns) do
    ~H"""
    <div class="px-4 py-10 sm:px-6 sm:py-28 lg:px-8 xl:px-28 xl:py-32">
      <div class="mx-auto max-w-xl lg:mx-0">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def right_half_layout(assigns) do
    ~H"""
    <div class="left-[40rem] fixed inset-y-0 right-0 z-0 hidden lg:block xl:left-[50rem]">
      <svg
        viewBox="0 0 1480 957"
        fill="none"
        aria-hidden="true"
        class="absolute inset-0 h-full w-full"
        preserveAspectRatio="xMinYMid slice"
      >
        <path fill="#EE7868" d="M0 0h1480v957H0z" />
        <path
          d="M137.542 466.27c-582.851-48.41-988.806-82.127-1608.412 658.2l67.39 810 3083.15-256.51L1535.94-49.622l-98.36 8.183C1269.29 281.468 734.115 515.799 146.47 467.012l-8.928-.742Z"
          fill="#FF9F92"
        />
        <path
          d="M371.028 528.664C-169.369 304.988-545.754 149.198-1361.45 665.565l-182.58 792.025 3014.73 694.98 389.42-1689.25-96.18-22.171C1505.28 697.438 924.153 757.586 379.305 532.09l-8.277-3.426Z"
          fill="#FA8372"
        />
        <path
          d="M359.326 571.714C-104.765 215.795-428.003-32.102-1349.55 255.554l-282.3 1224.596 3047.04 722.01 312.24-1354.467C1411.25 1028.3 834.355 935.995 366.435 577.166l-7.109-5.452Z"
          fill="#E96856"
          fill-opacity=".6"
        />
        <path
          d="M1593.87 1236.88c-352.15 92.63-885.498-145.85-1244.602-613.557l-5.455-7.105C-12.347 152.31-260.41-170.8-1225-131.458l-368.63 1599.048 3057.19 704.76 130.31-935.47Z"
          fill="#C42652"
          fill-opacity=".2"
        />
        <path
          d="M1411.91 1526.93c-363.79 15.71-834.312-330.6-1085.883-863.909l-3.822-8.102C72.704 125.95-101.074-242.476-1052.01-408.907l-699.85 1484.267 2837.75 1338.01 326.02-886.44Z"
          fill="#A41C42"
          fill-opacity=".2"
        />
        <path
          d="M1116.26 1863.69c-355.457-78.98-720.318-535.27-825.287-1115.521l-1.594-8.816C185.286 163.833 112.786-237.016-762.678-643.898L-1822.83 608.665 571.922 2635.55l544.338-771.86Z"
          fill="#A41C42"
          fill-opacity=".2"
        />
      </svg>
    </div>
    """
  end

  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"

  attr :kind, :atom,
    values: [:success, :info, :warning, :error],
    doc: "used for styling and flash lookup"

  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def toast(assigns) do
    assigns = assign_new(assigns, :id, fn -> "toast-#{assigns.kind}" end)
    assigns = assign_new(assigns, :button_id, fn -> "close-toast-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      class="toast toast-top toast-center flashhits z-50"
      phx-hook="OnToastOpen"
      {@rest}
    >
      <div
        role="alert"
        class={[
          "alert",
          @kind == :success && "alert-success",
          @kind == :info && "alert-info",
          @kind == :warning && "alert-warning",
          @kind == :error && "alert-error"
        ]}
      >
        <CoreComponents.icon
          :if={@kind == :success}
          name="hero-check-circle-mini"
          class="stroke-current shrink-0 w-6 h-6"
        />
        <CoreComponents.icon
          :if={@kind == :info}
          name="hero-information-circle-mini"
          class="stroke-current shrink-0 w-6 h-6"
        />
        <CoreComponents.icon
          :if={@kind == :warning}
          name="hero-exclamation-circle-mini"
          class="stroke-current shrink-0 w-6 h-6"
        />
        <CoreComponents.icon
          :if={@kind == :error}
          name="hero-x-circle-mini"
          class="stroke-current shrink-0 w-6 h-6"
        />
        <span><%= msg %></span>
        <button type="button" id={@button_id} aria-label={gettext("close")} phx-hook="OnToastClose">
          <CoreComponents.icon name="hero-x-mark-mini" class="stroke-current shrink-0 w-6 h-6" />
        </button>
      </div>
    </div>
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def toast_group(assigns) do
    ~H"""
    <div id={@id}>
      <.toast kind={:success} flash={@flash} />
      <.toast kind={:info} flash={@flash} />
      <.toast kind={:warning} flash={@flash} />
      <.toast kind={:error} flash={@flash} />
    </div>
    """
  end

  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def ectopic_button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "btn py-2 px-3",
        "bg-brand hover:bg-brandHover text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  attr :navigate, :any, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def navigate_button(assigns) do
    ~H"""
    <a
      href={@navigate}
      class={[
        "btn py-2 px-3",
        "bg-brand hover:bg-brandHover text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </a>
    """
  end

  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"
  attr :class, :string, default: nil

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart class),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def ectopic_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest} class={[@class]}>
      <div class="mt-10 space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end
end
