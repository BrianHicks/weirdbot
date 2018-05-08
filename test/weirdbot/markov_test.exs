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
      check all tokens <- list_of(term()),
                head <- term() do
        %{:__start_token => starts} = increment([head|tokens], %{})

        assert starts == %{head => 1}
      end
    end
  end
end
