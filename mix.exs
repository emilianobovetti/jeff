defmodule Jeff.MixProject do
  use Mix.Project

  def project do
    [
      app: :jeff,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        flags: [
          :error_handling,
          :extra_return,
          :missing_return,
          :underspecs,
          :unmatched_returns,
          :unknown
        ]
      ]
    ]
  end

  def application do
    [
      mod: {Jeff.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:plug_cowboy, "~> 2.6"},
      {:plug, "~> 1.15"}
    ]
  end
end
