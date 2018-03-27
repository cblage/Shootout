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
  defp json(:dev), do: {:json, github: "cblage/elixir-json", branch: "develop", override: true}
  defp json(:prod), do: {:json, "~> 1.0"}
  defp poison(:dev), do: {:poison, github: "cblage/poison", branch: "master", override: true}
  defp poison(:prod), do: {:poison, "~> 3.1"}
  defp jason(:dev), do: {:jason, github: "michalmuskala/jason", branch: "master", override: true}
  defp jason(:prod), do: {:jason, "~> 1.0"}

  defp credo,
    do: {:credo, github: "cblage/credo", branch: "master", only: [:dev, :test], runtime: false}

  def deps(:test), do: [ex_doc(), inch_ex(), json(:dev),  poison(:dev),  jason(:dev)]
  def deps(:docs), do: [ex_doc(), inch_ex(), credo()]
  def deps(:dev), do: [ex_doc(), inch_ex(), json(:dev),  poison(:dev),  jason(:dev)]
  def deps(:prod), do: [json(:prod),  poison(:prod),  jason(:prod)]
end
