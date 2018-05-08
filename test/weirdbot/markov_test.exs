defmodule Weirdbot.MarkovTest do
  use ExUnit.Case, async: true
  import Weirdbot.Markov

  setup do
    markov = start_supervised!(Weirdbot.Markov)
    %{markov: markov}
  end

  describe "adding" do
    test "a single string", %{markov: markov} do
      assert add(markov, ~w(a b)) == :ok

      assert :sys.get_state(markov) == %{
               :__start_token => %{"a" => 1},
               "a" => %{"b" => 1},
               "b" => %{__end_token: 1}
             }
    end

    test "incrementing a token", %{markov: markov} do
      assert add(markov, ~w(a b)) == :ok
      assert add(markov, ~w(a b)) == :ok

      assert :sys.get_state(markov) == %{
               :__start_token => %{"a" => 2},
               "a" => %{"b" => 2},
               "b" => %{__end_token: 2}
             }
    end

    test "does not clobber tokens", %{markov: markov} do
      assert add(markov, ~w(a b)) == :ok
      assert add(markov, ~w(a c)) == :ok

      assert :sys.get_state(markov) == %{
               :__start_token => %{"a" => 2},
               "a" => %{"b" => 1, "c" => 1},
               "b" => %{__end_token: 1},
               "c" => %{__end_token: 1}
             }
    end

    test "does not clobber start tokens", %{markov: markov} do
      assert add(markov, ~w(a c)) == :ok
      assert add(markov, ~w(b c)) == :ok

      assert :sys.get_state(markov) == %{
               :__start_token => %{"a" => 1, "b" => 1},
               "a" => %{"c" => 1},
               "b" => %{"c" => 1},
               "c" => %{__end_token: 2}
             }
    end
  end
end
