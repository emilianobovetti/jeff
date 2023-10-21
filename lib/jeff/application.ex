defmodule Jeff.Application do
  use Application

  @dialyzer {:no_underspecs, {:children, 1}}
  @dialyzer {:no_match, {:children, 1}}

  @env Mix.env()

  @impl Application
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Jeff.Supervisor]
    Supervisor.start_link(children(@env), opts)
  end

  @spec children(atom) :: [Supervisor.child_spec() | {module, any} | module]
  defp children(:dev) do
    [Jeff.CodeWatcher | children(:prod)]
  end

  defp children(_env) do
    [
      {Plug.Cowboy, plug: JeffWeb.Router, scheme: :http, options: [ip: {0, 0, 0, 0}, port: 8080]}
    ]
  end
end
