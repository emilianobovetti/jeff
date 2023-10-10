defmodule Jeff.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      Jeff.CodeWatcher,
      {Plug.Cowboy, plug: JeffWeb.Router, scheme: :http, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: Jeff.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
