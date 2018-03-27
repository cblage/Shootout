defmodule BenchCrunch do
  @moduledoc """
  Providers a general benchmarker and profiler for Elixir
  """

  @decode :decode
  @encode :encode

  @doc """
    Profiles elixir-json lib (JSON)
  """
  def profile_json(file), do: profile_lib(JSON, file)

  @doc """
    Profiles jason lib (Jason)
  """
  def profile_jason(file), do: profile_lib(Jason, file)

  @doc """
    Profiles Poison lib
  """
  def profile_poison(file), do: profile_lib(Poison, file)

  def profile_lib(lib, file) do
    IO.puts("Profiling #{lib} encoding with file: #{file}")
    profile_encode(lib, file)
    IO.puts("Profiling #{lib} decoding with file: #{file}")
    profile_decode(lib, file)
  end

  defp validate_and_profile(module, tag, prepare_cb, bench_cb, validate_cb) do
    module_str = module |> to_string() |> Macro.underscore()
    IO.puts("#{module_str}:#{tag}] Preparing data...")
    data = prepare_cb.()
    IO.puts("#{module_str}:#{tag}] Data ready, starting profiling...")
    :fprof.start()
    :fprof.trace([:start])
    bench_result = bench_cb.(data)
    :fprof.trace([:stop])
    :fprof.profile()
    :fprof.analyse({:dest, fprof_file_name(module_str, tag)})
    :fprof.stop()
    IO.puts("#{module_str}:#{tag}] data inspect:")
    IO.inspect(data)
    IO.puts("#{module_str}:#{tag}] bench_result inspect:")
    IO.inspect(bench_result)
    case validate_cb.(data, bench_result) do
      :ok -> IO.puts("#{module_str}:#{tag}] Profiled code behaved as expected")
      :error -> IO.puts("#{module_str}:#{tag}] Profiled code errored out")
    end
  end

  defp profile_encode(lib, test_file) do
    prepare_cb = fn () ->
      IO.puts("Loading test file: #{test_file}...")
      {:ok, binary} = File.read(test_file)
      IO.puts("Test file loaded, decoding file...")
      lib.decode!(binary)
    end

    bench_cb = fn(data) ->
      lib.encode!(data)
    end

    validate_cb = fn(data, bench_result) ->
      if bench_result == data do
        IO.puts("encode result equals original binary")
        :ok
      else
        IO.puts("encode result differs from original binary")
        :err
      end
    end

    validate_and_profile(lib, @encode, prepare_cb, bench_cb, validate_cb)
  end

  defp profile_decode(lib, test_file) do
    data_cb = fn () ->
      IO.puts("Loading test file: #{test_file}...")
      {:ok, binary} = File.read(test_file)
      binary
    end

    bench_cb = fn(data) ->
      lib.decode!(data)
    end

    validate_cb = fn(data, bench_result) ->
      if bench_result == lib.encode!(data) do
        IO.puts("decode result equals original binary")
        :ok
      else
        IO.puts("decode result differs from original binary")
        :err
      end
    end

    validate_and_profile(lib, @decode, data_cb, bench_cb, validate_cb)
  end

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

  defp fprof_file_name(input, encode_or_decode) when is_atom(encode_or_decode) do
    input ++ '--' ++ Atom.to_charlist(encode_or_decode) ++ '--' ++ env(:cl) ++ '.fprof'
  end
end
