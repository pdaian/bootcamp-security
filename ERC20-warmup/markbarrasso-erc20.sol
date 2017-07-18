pragma solidity ^0.4.8;

contract IC3Token {
    string public constant symbol = "IC3";
    string public constant name = "IC3 2017 Bootcamp Token";
    uint8 public constant decimals = 18;
    uint256 _totalSupply;

    // balances for each account
    mapping(address => uint256) balances;
    
    // approve the transfer of an amount to another account
    mapping(address => mapping (address => uint256)) allowed;
    
    // transfer and approval events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    // constructor
    function IC3Token() {
        _totalSupply = 0;
    }
    
    function totalSupply() constant returns (uint256 totalSupply) {
        totalSupply = _totalSupply;
    }
    
    // what is balance of a particular account
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    
    // transfer the balance from one owner's account to another account
    function transfer(address _to, uint256 _amount) returns (bool success) {
        if (balances[msg.sender] >= _amount
            && _amount > 0 
            && balances[_to] + _amount > balances[_to]) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) returns (bool success) {
        if (balances[_from] >= _amount
            && allowed[_from][msg.sender] >= _amount
            && _amount > 0
            && balances[_to] + _amount > balances[_to]) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    } 
    
    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _amount) returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }
    
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    // user can deposit 1 wei for 1 IC3 token
    function deposit() payable returns (bool success) {
        if (msg.value == 0) return false;
        balances[msg.sender] += msg.value;
        _totalSupply += msg.value;
        return true;
    }
    
    // user can withdraw 1 IC3 token for 1 wei
    function withdraw(uint256 _amount) returns (bool success) {
        if (balances[msg.sender] < _amount) return false;
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        _totalSupply -= _amount;
        return true;
    }
}