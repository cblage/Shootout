defmodule BenchCrunch_010_SNAPSHOT.Mixfile do
  use Mix.Project

  def project do
    elixirc_defaults = [debug_info: true, ignore_module_conflict: true, docs: true]
    [ app: :bench_crunch,
      version: "0.1.0-SNAPSHOT",
      elixir: "~> 1.6",
      escript: [main_module: BenchCrunch],
      elixirc_options: elixirc_defaults ++ options(Mix.env()),
      deps: deps(Mix.env())]
  end

  defp options(env) when env in [:dev, :test], do: [exlager_level: :debug, exlager_truncation_size: 8096]
  defp options(_), do: []

  def application, do: [env: [mix_env: Mix.env()]]

  defp inch_ex, do: {:inch_ex, github: "cblage/inch_ex", branch: "master", only: [:dev, :test], runtime: false}
  defp ex_doc, do: {:ex_doc, "~> 0.16", only: :dev, runtime: false}
  defp json(:dev), do: {:json, github: "cblage/elixir-json", branch: "develop", override: true}
  defp json(:prod), do: {:json, "~> 1.0"}
  defp poison(:dev), do: {:poison, github: "cblage/poison", branch: "master", override: true}
  defp poison(:prod), do: {:poison, "~> 3.1"}
  defp jason(:dev), do: {:jason, github: "michalmuskala/jason", branch: "master", override: true}
  defp jason(:prod), do: {:jason, "~> 1.0"}
  defp credo, do: {:credo, github: "cblage/credo", branch: "master", only: [:dev, :test], runtime: false}

  def deps(:test), do: [ex_doc(), inch_ex(), json(:dev), poison(:dev), jason(:dev)]
  def deps(:docs), do: [ex_doc(), inch_ex(), credo()]
  def deps(:dev), do: [ex_doc(), inch_ex(), json(:dev), poison(:dev), jason(:dev), credo()]
  def deps(:prod), do: [json(:prod), poison(:prod), jason(:prod)]
end
