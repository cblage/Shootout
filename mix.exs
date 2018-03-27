defmodule BenchCrunch_010_SNAPSHOT.Mixfile do
  use Mix.Project

  def project do
    [app: :bench_crunch, version: "0.1.0-SNAPSHOT", elixir: "~> 1.6", deps: deps(Mix.env())]
  end

  def application, do: []

  defp inch_ex,
    do:
      {:inch_ex, github: "cblage/inch_ex", branch: "master", only: [:dev, :test], runtime: false}

  defp ex_doc, do: {:ex_doc, "~> 0.16", only: :dev, runtime: false}

  def deps(:test) do
    [
      ex_doc(),
      inch_ex(),
      {:json, git: "git@github.com:cblage/elixir-json.git", branch: "develop", override: true},
      {:poison, git: "git@github.com:cblage/poison.git", branch: "master"},
      {:jason, git: "git@github.com:michalmuskala/jason.git", branch: "master"}
    ]
  end

  def deps(:docs) do
    [
      ex_doc(),
      inch_ex(),
      {:credo, github: "cblage/credo", branch: "master", only: [:dev, :test], runtime: false}
    ]
  end

  def deps(:dev) do
    [
      ex_doc(),
      inch_ex(),
      {:json, git: "git@github.com:cblage/elixir-json.git", branch: "develop", override: true},
      {:poison, git: "git@github.com:cblage/poison.git", branch: "master"},
      {:jason, git: "git@github.com:michalmuskala/jason.git", branch: "master"}
    ]
  end

  def deps(:prod) do
    [
      {:json, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:poison, "~> 3.1"}
    ]
  end
end
