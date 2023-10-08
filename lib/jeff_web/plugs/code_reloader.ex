defmodule JeffWeb.CodeReloader do
  @behaviour Plug
  import Plug.Conn

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    # Stolen from https://github.com/phoenixframework/phoenix/blob/7b5cd358aadb507cd90aa3a52e013f9e9e947ac4/lib/phoenix/code_reloader/server.ex#L73-L82
    {:module, Mix.Task} = Code.ensure_loaded(Mix.Task)

    config = Mix.Project.config()
    config[:app]

    for compiler <- Mix.compilers() do
      Mix.Task.reenable("compile.#{compiler}")

      compile_args = [
        "--purge-consolidation-path-if-stale",
        Mix.Project.consolidation_path(config)
      ]

      {_status, _diagnostics} = Mix.Task.run("compile.#{compiler}", compile_args)
    end

    Mix.Task.reenable("compile.protocols")
    Mix.Task.run("compile.protocols")

    conn
  catch
    kind, reason ->
      exn = Exception.format(kind, reason, __STACKTRACE__)
      IO.puts(exn)

      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(500, exn)
      |> halt()
  end
end
