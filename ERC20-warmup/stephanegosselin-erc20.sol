pragma solidity 0.4.13;

contract IC3 {
    
    string public constant symbol = "IC3";
    uint8 public constant decimals = 18;
    string public constant name = "IC3 2017 bootcamp token";
    uint256 public IC3_supply;
    
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) allowed;      // [_owner][_spender]
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function IC3() {
        IC3_supply = 0;
    }
    
    function deposit() payable returns(bool success) {
        balances[msg.sender] += msg.value;
        IC3_supply += msg.value;
        return true;
    }
    
    function withdraw(uint256 amount) returns(bool success) {
        balances[msg.sender] -= amount;
        IC3_supply -= amount;
        return true;
    }
    
    function totalSupply() constant returns (uint256 totalSupply) {
        return IC3_supply;
    }
    
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balanceOf(msg.sender) >= _value 
            && _value > 0
            && balanceOf(_to) + _value > balanceOf(_to)) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }
    
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balanceOf(_from) >= _value
            && allowed[_from][msg.sender] >= _value
            && _value > 0 
            && balanceOf(_to) + _value > balanceOf(_to)) {
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }
    
    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
}