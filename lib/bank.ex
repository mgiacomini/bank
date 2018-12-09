defmodule Bank do
  use GenServer

  def start_link(cache_server) do
    GenServer.start_link(Bank, cache_server, name: Bank)
  end

  @impl true
  def init(cache_server) do
    balance = Bank.Cache.get_balance(cache_server)
    initial_state = %{cache_server: cache_server, balance: balance}
    {:ok, initial_state}
  end

  # client api

  def get_balance do
    GenServer.call(Bank, :get_balance)
  end

  def deposit(amount) do
    GenServer.cast(Bank, {:deposit, amount})
  end

  def withdraw(amount) do
    transaction = GenServer.call(Bank, {:withdraw, amount})

    case transaction do
      :ok -> get_balance()
      error -> error
    end
  end

  # server api

  @impl true
  def handle_call(:get_balance, _from, current_state) do
    {:reply, current_state.balance, current_state}
  end

  @impl true
  def handle_call({:withdraw, amount}, _from, %{balance: balance} = current_state)
      when balance >= amount do
    GenServer.cast(Bank, {:withdraw, amount})
    {:reply, :ok, current_state}
  end

  @impl true
  def handle_cast({:deposit, amount}, %{balance: balance} = current_state) do
    {:noreply, %{current_state | balance: balance + amount}}
  end

  @impl true
  def handle_cast({:withdraw, amount}, %{balance: balance} = current_state)
      when balance >= amount do
    {:noreply, %{current_state | balance: balance - amount}}
  end

  @impl true
  def terminate(reason, %{balance: balance, cache_server: cache_server} = _current_state) do
    IO.inspect(reason, label: :reason)
    Bank.Cache.save_balance(balance, cache_server)
  end
end
