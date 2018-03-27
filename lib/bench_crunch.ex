defmodule BenchCrunch do
  @moduledoc """
  Providers a general benchmarker and profiler for Elixir
  """

  @decode :decode
  @encode :encode

  defp env(:bs) do
    case Mix.env() do
      :dev -> "bleeding_edge"
      :prod -> "stable"
    end
  end

  defp env(:cl) do
    case Mix.env() do
      :dev -> 'bleeding_edge'
      :prod -> 'stable'
    end
  end

  defp fprof_file_name(input, encode_or_decode) when is_atom(encode_or_decode),
    do: input ++ ':' ++ Atom.to_charlist(encode_or_decode) ++ ':' ++ env(:cl) ++ '.fprof'

  defp fprof_file_name(input, @decode), do: input ++ ':decode:' ++ env(:cl) ++ '.fprof'

  def profile_encode(lib, test_file) do
    IO.puts("Preparing to profile encoding.")
    IO.puts("Loading test file: #{test_file}...")
    {:ok, binary} = File.read(test_file)
    IO.puts("Test file loaded, decoding file...")
    json_decode_result = lib.decode!(binary)
    IO.puts("Decoding completed, starting profiling...")
    :fprof.start()
    :fprof.trace([:start])
    json_encode_result = lib.encode!(json_decode_result)
    :fprof.trace([:stop])
    :fprof.profile()
    :fprof.analyse({:dest, fprof_file_name(lib |> to_string() |> Macro.underscore(), @encode)})
    :fprof.stop()

    if json_encode_result == binary do
      IO.puts("encode result equals original binary")
      :ok
    else
      IO.puts("encode result differs from original binary")
      :err
    end
  end
end
