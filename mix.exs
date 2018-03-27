defmodule Shootout.Mixfile do
  use Mix.Project

  def project do
    [ app: :shootout,
      version: "0.0.1",
      elixir: "~> 1.6",
      deps: deps() ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      # JSON.encode type API (comment out the ones you're not testing.)
      #{ :json, "~> 1.0"},
      { :json, github: "cblage/elixir-json", branch: "master"},

      #{ :jazz, github: "meh/jazz"},
      #{:exjson, github: "guedes/exjson"},
      {:jason, "~> 1.0"},
      # THEMSELVES.encode type API
      {:exjsx, "~> 4.0"},
      #{:poison, "~> 3.1"},
      {:poison, github: "cblage/poison", branch: "master"},
      {:jsx, "~> 2.8"},
      #{:mochijson2, github: "bjnortier/mochijson2"},
      #{:exon, github: "betawaffle/exon"}
    ]
  end
end
# betawaffle/exon guedes/exjson