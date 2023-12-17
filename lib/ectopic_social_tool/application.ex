defmodule EctopicSocialTool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EctopicSocialToolWeb.Telemetry,
      EctopicSocialTool.Repo,
      {DNSCluster,
       query: Application.get_env(:ectopic_social_tool, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EctopicSocialTool.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EctopicSocialTool.Finch},
      # Start a worker by calling: EctopicSocialTool.Worker.start_link(arg)
      # {EctopicSocialTool.Worker, arg},
      # Start to serve requests, typically the last entry
      {Oban, Application.fetch_env!(:ectopic_social_tool, Oban)},
      EctopicSocialToolWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EctopicSocialTool.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EctopicSocialToolWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
