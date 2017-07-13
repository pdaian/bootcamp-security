pragma solidity ^0.4.13;

contract IC3Token {
    struct Allowance {
        address target;
        uint256 total_value;
    }
    uint8 public constant decimals = 18;
    string public constant name = "IC3 2012 bootcamp token";
    string public constant symbol = "IC3";

    uint256 public supply = 0;

    mapping(address => mapping(address => uint256)) private approvals;
    mapping(address => uint256) private balances;

    event Transfer(address indexed_from, address indexed_to, uint256 _value);
    event Approval(address indexed_owner, address indexed_spender, uint256 _value);


    function totalSupply() constant returns(uint256 totalSupply){
        return supply;
    }

    function balanceOf(address _owner) constant returns(uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint _value) returns(bool success){
        if(balances[msg.sender] >= _value){
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool success){
        mapping(address => uint256) allowed = approvals[_from];
        if (allowed[msg.sender] >= 0){
            balances[_from] -= _value;
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            return true;
        }
        return false;
    }

    function approve(address _spender, uint256 _value) returns (bool success){
        if (_value > balances[_spender]) {
            return false;
        }
        approvals[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining){
        return approvals[_owner][_spender];
    }

    function deposit() payable returns (bool success){
        balances[msg.sender] += msg.value;
        supply += msg.value;
        return true;
    }

    function withdraw(uint256 _amount) returns (bool success){
        if (balances[msg.sender] >= _amount){
            balances[msg.sender] -= _amount;
            msg.sender.transfer(_amount);
            supply -= _amount;
            return true;
        }
        return false;
    }
}