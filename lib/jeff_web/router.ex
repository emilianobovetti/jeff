defmodule JeffWeb.Router do
  use Plug.Router

  plug JeffWeb.CORS, origins: ["*"]
  plug Plug.Parsers, parsers: [:urlencoded]
  plug Plug.Logger
  plug :match
  plug :dispatch

  defp definitions do
    [
      "definitions/fdmprinter.def.json",
      "definitions/creality_base.def.json",
      "definitions/creality_ender3.def.json",
      "definitions/fdmextruder.def.json",
      "extruders/creality_base_extruder_0.def.json"
    ]
  end

  defp settings do
    %{
      cool_min_temperature: "0",
      roofing_layer_count: "0",
      roofing_monotonic: "true"
    }
  end

  get "/slice" do
    %{"stl" => stl_url} = conn.query_params
    sha256 = :crypto.hash(:sha256, stl_url) |> Base.encode16(case: :lower)
    tmp_stl = Path.join(System.tmp_dir!(), "#{sha256}.stl")
    tmp_gcode = Path.join(System.tmp_dir!(), "#{sha256}.gcode")

    if not File.exists?(tmp_stl) do
      :httpc.request(:get, {stl_url, []}, [], stream: to_charlist(tmp_stl))
    end

    {out, status} =
      System.cmd(
        "CuraEngine",
        ["slice"] ++
          Enum.flat_map(definitions(), &["-j", Path.join("/opt/cura/resources", &1)]) ++
          Enum.flat_map(settings(), &["-s", "#{elem(&1, 0)}=#{elem(&1, 1)}"]) ++
          ["-m5", "-e0", "-l", tmp_stl, "-o", tmp_gcode],
        env: [{"CURA_ENGINE_SEARCH_PATH", "/opt/cura/resources/definitions:/opt/cura/resources/extruders"}],
        stderr_to_stdout: true
      )

    if status == 0 do
      send_file(conn, 200, tmp_gcode)
    else
      send_resp(conn, 500, out)
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
