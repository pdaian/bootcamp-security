pragma solidity ^0.4.0;

import "./base_token.sol";

contract DepositWithdrawToken is BaseToken {

    function DepositWithdrawToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply)
        BaseToken(_name, _symbol, _decimals, _totalSupply) {
    }

    function deposit() payable returns (bool _success) {
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
        return true;
    }

    function withdraw(uint256 _amount) returns (bool _success) {
        if(balances[msg.sender] >= _amount) {
            balances[msg.sender] -= _amount;
            totalSupply -= _amount;
            msg.sender.transfer(_amount);
            return true;
        } else { return false; }
    }

}
