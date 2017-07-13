pragma solidity ^0.4.10;

import "./SafeMathLib.sol";

contract IC3Token {

  uint8 public constant decimals = 18;
  string public constant name = "IC3 2017 Bootcamp Token";
  string public constant symbol = "IC3";

  uint256 public totalSupply;

  mapping (address => uint256) public balances; // token balances
  mapping (address => mapping (address => uint256)) public approvals; // approval allotments

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }

  /* deposit 1 wei for 1 ic3 */
  function deposit () payable returns (bool success) {
    if (msg.value == 0) return false;
    balances[msg.sender] = SafeMathLib.safeAdd(msg.value, balances[msg.sender]);
    totalSupply += msg.value;
    return true;
  }

  /* withdraw 1 eth for 1 ic3 */
  function withdraw (uint256 amount) returns (bool success) {
    if (amount == 0) return false;
    if (balances[msg.sender] < amount) return false;
    balances[msg.sender] -= amount;
    totalSupply -= amount;
    bool rv = msg.sender.send(amount);
    if (!rv) {
      balances[msg.sender] += amount;
      totalSupply += amount;
    }
    return rv;
  }

  /* send _value amount of tokens to _to */
  function transfer (address _to, uint256 _value) returns (bool success) {
    if (_value == 0) return false;
    if (balances[msg.sender] < _value) return false;
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /* send _value amount of tokens from address _from to address _to */
  function transferFrom (address _from, address _to, uint256 _value) returns (bool success) {
    if (_value == 0) return false;
    if (msg.sender == _from) return false;
    if (balances[_from] < _value) return false;
    if (allowance(_from, msg.sender) < _value) return false;
    approvals[_from][msg.sender] -= _value;
    balances[_from] -= _value;
    balances[_to] += _value;
    Transfer(_from, _to, _value);
    return true;
  }

  /* allow _spender to withdraw from your account. overwrites _value */
  function approve (address _spender, uint256 _value) returns (bool success) {
    if (msg.sender == _spender) return false;
    approvals[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

    /* returns the amount which _spender is still allowed to withdraw from _owner */
  function allowance (address _owner, address _spender) constant returns (uint256 remaining) {
    return approvals[_owner][_spender];
  }

}
