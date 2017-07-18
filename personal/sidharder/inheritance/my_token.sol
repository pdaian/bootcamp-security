pragma solidity ^0.4.0;

import "./deposit_withdraw_token.sol";
import "./escape_hatch.sol";

contract MyToken is EscapeHatch, DepositWithdrawToken {

    string public name = "Bad Token";
    string public symbol = "BDTKN";
    uint8 public decimals = 18;
    uint256 public totalSupply = 8000000;

    function MyToken()
        EscapeHatch(name, symbol, decimals, totalSupply)
        DepositWithdrawToken(name, symbol, decimals, totalSupply) {

    }

}
