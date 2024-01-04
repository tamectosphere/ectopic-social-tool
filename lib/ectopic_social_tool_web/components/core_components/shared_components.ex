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
    <div class="fancy-background left-[40rem] fixed inset-y-0 right-0 z-0 hidden lg:block xl:left-[50rem]">
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
  attr :color, :string, default: "bg-brand hover:bg-brandHover text-white active:text-white/80"
  attr :rest, :global

  slot :inner_block, required: true

  def navigate_button(assigns) do
    ~H"""
    <a
      href={@navigate}
      class={[
        "btn py-2 px-3",
        @color,
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

  attr :id, :string, required: true

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:occurred_at]"

  attr :label, :string, default: nil

  def datetime_picker(assigns) do
    ~H"""
    <div id={@id} phx-update="ignore" phx-hook="DateTimePickerToggle">
      <EctopicSocialToolWeb.CoreComponents.input
        field={@field}
        type="text"
        phx-hook="DateTimePicker"
        label={@label}
        placeholder="Select date and time..."
      />
    </div>
    """
  end
end
