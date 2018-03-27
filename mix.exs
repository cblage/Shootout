defmodule JSONShootout_010_SNAPSHOT.Mixfile do
  use Mix.Project

  def project do
    [ app: :json_shootout,
      version: "0.1.0-SNAPSHOT",
      elixir: "~> 1.6",
      deps: deps(Mix.env()) ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  def deps(:dev) do
    [
      {:json, git: "git@github.com:cblage/elixir-json.git", branch: "develop"},
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
# betawaffle/exon guedes/exjson