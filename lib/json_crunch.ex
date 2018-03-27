defmodule JSONCrunch do

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


  defp fprof_file_name(input, :encode),
       do: input <> ':encode:' <> env(:cl) <> '.fprof'

  defp fprof_file_name(input, :decode),
       do: input <> ':decode:'<> env(:cl) <> '.fprof'

	def profile_json_decode do
		IO.puts "Preparing to test encoding and decoding."
		#{:ok, binary} = File.read "test.json"
		{:ok, binary} = File.read "big.json"
		IO.puts "Test file loaded,test begins..."

		:fprof.start()
    :fprof.trace([:start])

    {:ok, json_decode_result} = JSON.decode(binary)

    :fprof.trace([:stop])

    :fprof.profile()
    :fprof.analyse({:dest, fprof_file_nane('json', @decode)})
    :fprof.stop()
	end

  def profile_json_encode do
    IO.puts "Preparing to profile encoding."
    #{:ok, binary} = File.read "test.json"
    {:ok, binary} = File.read "big.json"
    IO.puts "Test file loaded, test begins..."
    {:ok, json_decode_result} = JSON.decode(binary)
    :fprof.start()
    :fprof.trace([:start])
    {:ok, json_encode_result} = JSON.encode(json_decode_result)

    :fprof.trace([:stop])

    :fprof.profile()
    :fprof.analyse({:dest,  })
    :fprof.stop()

    if (json_encode_result ==  binary) do
      IO.puts "encode result equals original binary"
    else
      IO.puts "encode result differs from original binary"
    end
  end

	def profile_posion_decode do
		IO.puts "Preparing to profile decoding."
		#{:ok, binary} = File.read "test.json"
		{:ok, binary} = File.read "big.json"
		IO.puts "Test file loaded, test begins..."

	  :fprof.start()
    :fprof.trace([:start])

    {:ok, json_decode_result} = Poison.decode(binary)

    :fprof.trace([:stop])

    :fprof.profile()
    :fprof.analyse({:dest, 'poison_decode.fprof'})
    :fprof.stop()

    {:ok, json_encode_result} = Poison.encode(json_decode_result)

    if (json_encode_result ==  binary) do
      IO.puts "encode result equals original binary"
    else
      IO.puts "encode result differs from original binary"
    end
	end

  def profile_posion_encode do
    IO.puts "Preparing to profile encoding."
    #{:ok, binary} = File.read "test.json"
    {:ok, binary} = File.read "big.json"
    IO.puts "Test file loaded, test begins..."
    {:ok, json_decode_result} = Poison.decode(binary)
    :fprof.start()
    :fprof.trace([:start])

    {:ok, json_encode_result} = Poison.encode(json_decode_result)

    :fprof.trace([:stop])

    :fprof.profile()
    :fprof.analyse({:dest, 'poison_encode.fprof'})
    :fprof.stop()

    if (json_encode_result ==  binary) do
      IO.puts "encode result equals original binary"
    else
      IO.puts "encode result differs from original binary"
    end
  end


	def jsonator do
		IO.puts "Preparing to profile decoding."
		{:ok, binary} = File.read "test.json"
		IO.puts "Test file loaded, test begins..."
		#{:ok, binary} = String.to_char_list(binary)
		json_decode_start = :erlang.now()
    {ok, json_decode_result} = JSON.decode(binary)
		json_decode_stop = :erlang.now()

		IO.puts("done decoding, encoding now...")

		json_encode_result = JSON.encode(json_decode_result)
		json_encode_stop = :erlang.now()
		decode_time = :timer.now_diff(json_decode_stop, json_decode_start) / 1000000
		encode_time = :timer.now_diff(json_encode_stop, json_decode_stop) / 1000000
		IO.puts "Test finished, Decode: #{decode_time}s Encode: #{encode_time}s"
	end

	def jiffy do
		IO.puts "Preparing to test JIFFY encoding and decoding."
		{:ok, binary} = File.read "test.json"
		IO.puts "Test file loaded, test begins..."
		json_decode_start = :erlang.now()
    json_decode_result = :jiffy.decode(binary)
		json_decode_stop = :erlang.now()
		json_encode_result = :jiffy.encode(json_decode_result)
		json_encode_stop = :erlang.now()
		decode_time = :timer.now_diff(json_decode_stop, json_decode_start) / 1000000
		encode_time = :timer.now_diff(json_encode_stop, json_decode_stop) / 1000000
		IO.puts "JIFFY finished, Decode: #{decode_time}s Encode: #{encode_time}s"
	end

	def jiffy do
		IO.puts "Preparing to test JIFFY encoding and decoding."
		{:ok, binary} = File.read "test.json"
		IO.puts "Test file loaded, test begins..."
		json_decode_start = :erlang.now()
    json_decode_result = :jiffy.decode(binary)
		json_decode_stop = :erlang.now()
		json_encode_result = :jiffy.encode(json_decode_result)
		json_encode_stop = :erlang.now()
		decode_time = :timer.now_diff(json_decode_stop, json_decode_start) / 1000000
		encode_time = :timer.now_diff(json_encode_stop, json_decode_stop) / 1000000
		IO.puts "JIFFY finished, Decode: #{decode_time}s Encode: #{encode_time}s"
	end

end
