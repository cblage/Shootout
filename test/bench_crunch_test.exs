Code.require_file("test_helper.exs", __DIR__)

defmodule BenchCrunchTest do
  use ExUnit.Case

  doctest BenchCrunch

  test "must succeed" do
    assert true
  end
end
