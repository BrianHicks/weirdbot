defmodule Weirdbot.MarkovTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import Weirdbot.Markov

  setup do
    markov = start_supervised!(Weirdbot.Markov)
    %{markov: markov}
  end

  describe "increment" do
    property "start is always set on the first item" do
      check all head <- term() do
        %{:__start_token => starts} = increment(%{}, [head])

        assert starts == %{head => 1}
      end
    end

    property "start is tracked separately for separate first items" do
      check all a <- term(),
                b <- term(),
                a != b do
        %{:__start_token => starts} =
          %{}
          |> increment([a])
          |> increment([b])

        assert starts == %{a => 1, b => 1}
      end
    end

    property "given `[a, b]`, tracks counts of b in terms of a" do
      check all a <- term(),
                b <- term() do
        %{^a => %{^b => count}} = increment(%{}, [a, b])

        assert count == 1
      end
    end
  end
end
