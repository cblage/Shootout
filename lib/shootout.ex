defmodule Shootout do
	def profile_json do
		IO.puts "Preparing to test encoding and decoding."
		#{:ok, binary} = File.read "test.json"
		{:ok, binary} = File.read "issue90.json"
		IO.puts "Test file loaded, test begins..."

		:fprof.start()
    :fprof.trace([:start])

    {:ok, json_decode_result} = JSON.decode(binary)
    #{:ok, json_encode_result} = JSON.encode(json_decode_result)

    :fprof.trace([:stop])

    :fprof.profile()
    :fprof.analyse({:dest, 'json.fprof'})
    :fprof.stop()
	end

	def test_json do
		IO.puts "Preparing to test encoding and decoding."
		#{:ok, binary} = File.read "test.json"
		{:ok, binary} = File.read "issue90.json"
		IO.puts "Test file loaded, test begins..."

		{:ok, json_decode_result} = JSON.decode(binary)
	end

	def profile_posion do
		IO.puts "Preparing to test encoding and decoding."
		#{:ok, binary} = File.read "test.json"
		{:ok, binary} = File.read "issue90.json"
		IO.puts "Test file loaded, test begins..."

	  :fprof.start()
    :fprof.trace([:start])

    {:ok, json_decode_result} = Poison.decode(binary)
    #{:ok, json_encode_result} = Poison.encode(json_decode_result)

    :fprof.trace([:stop])

    :fprof.profile()
    :fprof.analyse({:dest, 'poison.fprof'})
    :fprof.stop()
	end


	def jsonator do
		IO.puts "Preparing to test encoding and decoding."
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

	def charlist_jsonator do
		IO.puts "Preparing to test encoding and decoding."
		{:ok, binary} = File.read "test.json"
		IO.puts "Test file loaded, test begins..."
		binary = String.to_char_list(binary)
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

	def mochi do
		IO.puts "Preparing to test mochi encoding and decoding."
		{:ok, binary} = File.read "test.json"
		IO.puts "Test file loaded, test begins..."
		json_decode_start = :erlang.now()
    json_decode_result = :mochijson2.decode(binary)
		json_decode_stop = :erlang.now()
		json_encode_result = :mochijson2.encode(json_decode_result)
		json_encode_stop = :erlang.now()
		decode_time = :timer.now_diff(json_decode_stop, json_decode_start) / 1000000
		encode_time = :timer.now_diff(json_encode_stop, json_decode_stop) / 1000000
		IO.puts "mochi finished, Decode: #{decode_time}s Encode: #{encode_time}s"
	end

	def poison do
		IO.puts "Preparing to test poison encoding and decoding."
		{:ok, binary} = File.read "test.json"
		IO.puts "Test file loaded, test begins..."
		json_decode_start = :erlang.now()
    json_decode_result = Poison.decode(binary)
		json_decode_stop = :erlang.now()
		json_encode_result = Poison.encode(json_decode_result)
		json_encode_stop = :erlang.now()
		decode_time = :timer.now_diff(json_decode_stop, json_decode_start) / 1000000
		encode_time = :timer.now_diff(json_encode_stop, json_decode_stop) / 1000000
		IO.puts "posion finished, Decode: #{decode_time}s Encode: #{encode_time}s"
	end

	def charlist_poison do
		IO.puts "Preparing to test poison encoding and decoding."
		{:ok, binary} = File.read "test.json"
		IO.puts "Test file loaded, test begins..."
    binary = String.to_char_list(binary)
		json_decode_start = :erlang.now()
    json_decode_result = Poison.decode(binary)
		json_decode_stop = :erlang.now()
		json_encode_result = Poison.encode(json_decode_result)
		json_encode_stop = :erlang.now()
		decode_time = :timer.now_diff(json_decode_stop, json_decode_start) / 1000000
		encode_time = :timer.now_diff(json_encode_stop, json_decode_stop) / 1000000
		IO.puts "posion finished, Decode: #{decode_time}s Encode: #{encode_time}s"
	end
end
