defmodule BenchCrunch do
  @moduledoc """
  Providers a general benchmarker and profiler for Elixir
  """
  @decode :decode
  @encode :encode


  defp read_test_file(file) do
    IO.puts("Loading test file: #{file}...")
    {:ok, binary} = File.read(file)
    IO.puts("Test file loaded, decoding file...")
    binary
  end

  def bench_json(file) do
    json = read_test_file(file)
    Benchee.run(%{
      "JSON"  => fn() -> JSON.decode!(json) end
    }, time: 10)
  end

  def bench_jason(file) do
    json = read_test_file(file)
    Benchee.run(%{
      "Jason"  => fn() -> Jason.decode!(json) end
    }, time: 10)
  end

  def bench_poison(file) do
    json = read_test_file(file)
    Benchee.run(%{
      "Poison"  => fn() -> Poison.decode!(json) end
    }, time: 10)
  end

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
    IO.puts("[#{module_str}:#{tag}] Preparing data...")
    data = prepare_cb.()
    IO.puts("[#{module_str}:#{tag}] Data ready, starting profiling...")
    fprof_out = fprof_file_name(module, tag)
    IO.puts("[#{module_str}:#{tag}] FPROF out: #{fprof_out}")
    :fprof.start()
    :fprof.trace([:start])
    bench_result = bench_cb.(data)
    :fprof.trace([:stop])
    :fprof.profile()
    :fprof.analyse({:dest, fprof_out})
    :fprof.stop()
    case validate_cb.(data, bench_result) do
      :ok -> IO.puts("[#{module_str}:#{tag}] Profiled code behaved as expected")
      :err -> IO.puts("[#{module_str}:#{tag}] Profiled code errored out")
    end
  end

  defp profile_encode(lib, test_file) do
    data_cb = fn () -> read_test_file(test_file) |> lib.decode!() end
    bench_cb = fn(data) -> lib.encode!(data) end
    validate_cb = fn(data, bench_result) ->
      if lib.decode!(bench_result) == data do
        IO.puts("encode result equals original binary")
        :ok
      else
        IO.puts("encode result differs from original binary")
        :err
      end
    end

    validate_and_profile(lib, @encode, data_cb, bench_cb, validate_cb)
  end

  defp profile_decode(lib, test_file) do
    data_cb = fn() -> read_test_file(test_file) end
    bench_cb = fn(data) -> lib.decode!(data) end
    validate_cb = fn(data, bench_result) ->
      if bench_result == lib.decode!(data) do
        IO.puts("decode result equals original binary")
        :ok
      else
        IO.puts("decode result differs from original binary")
        :err
      end
    end

    validate_and_profile(lib, @decode, data_cb, bench_cb, validate_cb)
  end

  defp env(), do: Application.get_env(:bench_crunch, :mix_env)
  defp env(:bs) do
    case env() do
      :dev -> "bleeding_edge"
      :prod -> "stable"
    end
  end

  defp env(:cl) do
    case env() do
      :dev -> 'bleeding_edge'
      :prod -> 'stable'
    end
  end

  defp fprof_file_name(input, tag) when is_atom(tag) do
    fprof_file = '_fprof/' ++ String.to_charlist(to_string(input)) ++ '--' ++ Atom.to_charlist(tag) ++ '--' ++ env(:cl) ++ '.fprof'
    IO.puts(fprof_file)
    fprof_file
  end
end
