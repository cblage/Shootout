defmodule Mix.Tasks.Crunch do
  @moduledoc false

  @big_json "./res/json/big.json"
  @regular_json "./res/json/test.json"
  @default_json "./res/json/test_small.json"

  @shortdoc "Runs different JSON modules through fprof or benchee"
  def run(args) do
    Application.put_env(:bench_crunch, :mix_env, Mix.env())
    IO.inspect(args)
    {opts, _} = OptionParser.parse!(args, switches: [cruncher: :string, lib: :string, type: :string])
    IO.inspect(opts)
    json_file = case opts[:type] do
      "light" -> @default_json
      "regular" -> @regular_json
      "heavy" -> @big_json
      _ -> raise ArgumentError
    end

    case {opts[:lib], opts[:cruncher]} do
      {"JSON", "fprof"} -> _ = BenchCrunch.profile_json(json_file)
      {"Jason", "fprof"} -> _= BenchCrunch.profile_jason(json_file)
      {"Poison", "fprof"} -> _= BenchCrunch.profile_poison(json_file)
      {"JSON", "benchee"} -> _ = BenchCrunch.bench_json(json_file)
      {"Jason", "benchee"} -> _= BenchCrunch.bench_jason(json_file)
      {"Poison", "benchee"} -> _= BenchCrunch.bench_poison(json_file)
      _ -> raise ArgumentError
    end
  end
end
