defmodule AstroEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :astro_ex,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "AstroEx",
      source_url: "https://gitlab.com/nickhurst/astro_ex",
      homepage_url: "https://gitlab.com/nickhurst/astro_ex",
      docs: [
        main: "AstroEx",
        formatter_opts: [gfm: true],
        extras: ["README.md"]
      ],
      test_coverage: [tool: ExCoveralls],
      consolidate_protocols: Mix.env() != :test,
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
