pragma solidity ^0.4.0;

contract coin {

    string public constant name = "IC3 Token";
    string public constant symbol = "IC3";
    uint8 public constant decimals = 18;
    uint256 public totalSupply = 0;

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function deposit() payable returns (bool _success) {
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
        return true;
    }

    function withdraw(uint _amount) returns (bool _success) {
        if(balances[msg.sender] >= _amount) {
            balances[msg.sender] -= _amount;
            totalSupply -= _amount;
        } else { return false; }
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

}
