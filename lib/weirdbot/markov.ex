defmodule Weirdbot.Markov do
  @moduledoc """
  TODO I guess?
  """
  use GenServer

  @start_token :__start_token
  @end_token :__end_token

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def add(server, tokens) do
    GenServer.cast(server, {:add, tokens})
  end

  ## Server callbacks

  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:add, tokens}, state) do
    {:noreply, increment(tokens, state)}
  end

  ## Psuedo-Private stuff
  ##
  ## So I want to use property-based tests to test this, but the nice Elixir
  ## library (StreamData) does not allow for testing stateful things like
  ## GenServers. So this is staying public (can you make Elixir stuff private?)
  ## for now until they add that or I find a better solution.

  def increment(tokens, state) do
    increment_pairs([@start_token | tokens], state)
  end

  def increment_pairs([first | [next | rest]], state) do
    increment_pairs(
      [next | rest],
      Map.update(state, first, %{next => 1}, fn current ->
        Map.update(current, next, 1, &(&1 + 1))
      end)
    )
  end

  def increment_pairs([last], state) do
    Map.update(state, last, %{@end_token => 1}, fn current ->
      Map.update(current, @end_token, 1, &(&1 + 1))
    end)
  end

  def increment_pairs(_, state) do
    state
  end
end
