defmodule Spike.MixProject do
  use Mix.Project

  def project do
    [
      app: :spike,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :stripity_stripe],
      mod: {Spike.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:amnesia, "~> 0.2.8"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:stripity_stripe, "~> 2.0"}
    ]
  end
end
