defmodule UssdEmulator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UssdEmulatorWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:ussd_emulator, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UssdEmulator.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: UssdEmulator.Finch},
      # Start a worker by calling: UssdEmulator.Worker.start_link(arg)
      # {UssdEmulator.Worker, arg},
      # Start to serve requests, typically the last entry
      UssdEmulatorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UssdEmulator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UssdEmulatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
