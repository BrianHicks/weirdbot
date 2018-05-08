defmodule Weirdbot.MarkovTest do
  use ExUnit.Case, async: true
  import Weirdbot.Markov

  setup do
    markov = start_supervised! Weirdbot.Markov
    %{markov: markov}
  end

  describe "adding" do
    test "a single string", %{markov: markov} do
      assert add(markov, ~w(a b)) == :ok

      assert :sys.get_state(markov) == %{
        "a" => %{"b" => 1},
        "b" => %{__end_token: 1},
      }
    end

    test "incrementing a token", %{markov: markov} do
      assert add(markov, ~w(a b)) == :ok
      assert add(markov, ~w(a b)) == :ok

      assert :sys.get_state(markov) == %{
        "a" => %{"b" => 2},
        "b" => %{__end_token: 2},
      }
    end

    test "does not clobber tokens", %{markov: markov} do
      assert add(markov, ~w(a b)) == :ok
      assert add(markov, ~w(a c)) == :ok

      assert :sys.get_state(markov) == %{
        "a" => %{"b" => 1, "c" => 1},
        "b" => %{__end_token: 1},
        "c" => %{__end_token: 1},
      }
    end
  end
end
