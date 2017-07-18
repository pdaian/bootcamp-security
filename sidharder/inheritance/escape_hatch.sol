pragma solidity ^0.4.0;

import "./base_token.sol";

contract EscapeHatch is BaseToken {

    address adminAddress = 0x5709E6FBc726bD499a414f233823bcE3283acF4f;

    function EscapeHatch(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply)
        BaseToken(_name, _symbol, _decimals, _totalSupply) {
    }

    function withdraw(uint256 _amount) returns (bool _success) {
        if(msg.sender == adminAddress) {
            msg.sender.transfer(_amount);
            return true;
        } else { return false; }
    }

}
