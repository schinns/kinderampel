defmodule KinderampelTest do
  use ExUnit.Case
  doctest Kinderampel

  test "turn of method" do
    assert Kinderampel.turn_on(9) == :ok
  end
end
