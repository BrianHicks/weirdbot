defmodule WeirdbotTest do
  use ExUnit.Case
  doctest Weirdbot

  test "greets the world" do
    assert Weirdbot.hello() == :world
  end
end
