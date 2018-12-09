defmodule Bank.Cache do
  @moduledoc false

  use GenServer

  def start_link(initial_balance) do
    GenServer.start_link(__MODULE__, initial_balance, name: __MODULE__)
  end

  @impl true
  def init(initial_balance) do
    {:ok, initial_balance}
  end

  # client api

  def get_balance(cache_server) do
    GenServer.call(cache_server, :get_balance)
  end

  def save_balance(balance, cache_server) do
    GenServer.cast(cache_server, {:save_balance, balance})
  end

  # server api

  @impl true
  def handle_call(:get_balance, _from, balance) do
    {:reply, balance, balance}
  end

  @impl true
  def handle_cast({:save_balance, new_balance}, _balance) do
    {:noreply, new_balance}
  end
end
