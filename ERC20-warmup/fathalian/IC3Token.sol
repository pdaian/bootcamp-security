pragma solidity ^0.4.10;


contract IC3Token {

    uint8 public constant decimals = 18;

    string public constant name = "IC3 2017 Bootcamp Token";

    string public constant symbol = "IC3";

    mapping (address => uint256) public balances;

    mapping (address => mapping (address => uint256)) public approvals;

    uint256 public totalSupply;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }


    function approve(address _spender, uint256 _value) returns (bool success){
        if (msg.sender == _spender) return false;

        approvals[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);
        return true;
    }


    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        remaining = approvals[_owner][_spender];
        return remaining;
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] < _value) return false;
        balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (msg.sender == _from) return false;
        if (allowance(_from, msg.sender) < _value) return false;
        if (balances[_from] < _value) return false;

        approvals[_from][msg.sender] = safeSubtract(approvals[_from][msg.sender], _value);
        balances[_from] = safeSubtract(balances[_from], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        Transfer(_from, _to, _value);
        return true;
    }

    function deposit() payable returns (bool success){
        if (msg.value == 0) return false;
        balances[msg.sender] = safeAdd(balances[msg.sender], msg.value);
        totalSupply = safeAdd(totalSupply, msg.value);
        return true;
    }

    function withdraw(uint256 amount) returns (bool success) {
        if (balances[msg.sender] < amount) return false;

        balances[msg.sender] = safeSubtract(balances[msg.sender], amount);
        totalSupply = safeSubtract(totalSupply, amount);
        bool rv = msg.sender.send(amount);
        if (!rv){
            balances[msg.sender] = safeAdd(balances[msg.sender], amount);
            totalSupply = safeAdd(totalSupply, amount);
        }
        return rv;
    }

    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
        uint256 z = x + y;
        assert((z >= x) && (z >= y));
        return z;
    }

    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
        assert(x >= y);
        uint256 z = x - y;
        return z;
    }
}


