defmodule Mnesiac.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :mnesiac,
      version: "0.3.14",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.travis": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        plt_add_apps: [:mnesia],
        flags: [
          "-Wunmatched_returns",
          "-Werror_handling",
          "-Wrace_conditions",
          "-Wno_opaque",
          "-Wunderspecs"
        ]
      ],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: [
        description: "Auto clustering for Mnesia made easy!",
        files: ["lib", ".formatter.exs", "mix.exs", "README.md", "LICENSE", "CHANGELOG.md"],
        maintainers: ["beardedeagle"],
        licenses: ["MIT"],
        links: %{GitHub: "https://github.com/beardedeagle/mnesiac"}
      ],
      docs: [
        main: "readme",
        extras: ["README.md", "CHANGELOG.md"],
        formatters: ["html", "epub"]
      ],
      aliases: [
        check: [
          "format --check-formatted --dry-run",
          "compile --warning-as-errors --force",
          "doctor",
          "credo --strict --all"
        ],
        "purge.db": &purge_db/1
      ],
      name: "Mnesiac",
      source_url: "https://github.com/beardedeagle/mnesiac",
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      included_applications: []
    ]
  end

  defp elixirc_paths(env) when env in [:dev, :test], do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp deps do
    [
      {:libcluster, "~> 3.3", optional: true},
      {:credo, "~> 1.7", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:doctor, "~> 0.21", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.29", only: [:dev], runtime: false},
      {:ex_unit_clustered_case, "~> 0.5", only: [:test]},
      {:excoveralls, "~> 0.16", only: [:test], runtime: false}
    ]
  end

  defp purge_db(_) do
    if Mix.env() in [:dev, :test] do
      Mix.shell().cmd("rm -rf ./test0* ./Mnesia.nonode@nohost")
    else
      Mix.shell().info("[mnesiac:#{node()}] purge.db can only be used in dev and test env")
    end
  end
end
