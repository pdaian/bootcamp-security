ERC20 Warmup
------------

Task: IC3 would like to launch a crowdsale on the Ethereum network.  To do so,
they heard they need this thing called an "ERC20".  They would like you, the
protege new secure Solidity contract developer, to make sure they can launch
this without losing money.


The task is to implement the following API: https://github.com/ethereum/EIPs/issues/20

With the additional constraints:

- The token is called "IC3"
- The token has fields `uint8 public constant decimals = 18`, `string public constant name` = "IC3 2017 bootcamp token", `string public constant symbol = "IC3"`.
- Total supply is initially 0.
- Users can deposit 1 wei with a function `deposit() payable returns(bool success)` for 1 IC3 token.
- Users can withdraw 1 IC3 token for 1 wei with a function `withdraw(uint256 amount) returns(bool success)`


Good luck!  Hope the crowdsale makes $150M, and it stays in the contract ;).
