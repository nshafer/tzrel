defmodule TzRel.MixProject do
  use Mix.Project

  def project do
    [
      app: :tzrel,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:tz, "~> 0.26.2"},
      {:mint, "~> 1.5"},
      {:castore, "~> 1.0"},
    ]
  end
end
