defmodule JeffWeb.Router do
  use Plug.Router

  plug JeffWeb.CodeReloader
  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "hello, world")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
