defmodule Jeff.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      Jeff.Watcher,
      {Plug.Cowboy, plug: JeffWeb.Router, scheme: :http, options: [port: 4000]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClaimsApiUk.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
