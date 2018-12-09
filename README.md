# Bank

Just a test to retrieve GenServer state after termination.

When call `Bank#withdraw/1` with an amount greater than Bank (server) balance, 
raise an error, invoke `Bank#terminate` to save the balance in the cache process (server).

When the `Bank.Supervisor` restart the `Bank` process, the `Bank#init/1` will use the cache process to restore the state from the crashed `Bank`
