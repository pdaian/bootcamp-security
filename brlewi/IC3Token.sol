pragma solidity ^0.4.8;

contract IC3Token 
{
    //this could use less gas if i merged mappings
    //struct Approvals
    //{
        //mapping (address => bool) approved;
        //mapping (address => uint256) approvalAmount;
    //}

    struct Approvals
    {
        mapping (address => uint256) approvedAmounts;
    }

    address minter;

    //this is result of simplification
    mapping (address => Approvals) approvals;

    //this could be condensed to one mapping
    //mapping (address => bool) public registeredUsers;
    //mapping (address => uint256) private balances;

    mapping (address => uint256) private balances;

    uint256 private totalTokens = 0;

    uint8 public constant decimals = 18;
    string public constant name = "IC3 2017 Bootcamp Token";
    string public constant symbol = "IC3";

    //Events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function IC3Token()
    {
        minter = msg.sender;
    }

    //Functions from ERC20
    function totalSupply() constant returns (uint256 total)
    {
        if(msg.sender != minter)
        {
            return;
        }
        total = totalTokens;
    }

    //get balance of another account with address owner
    function balanceOf(address _owner) constant returns (uint256 balance)
    {
        balance = balances[_owner];
    }

    function transfer(address _to, uint256 _value) returns (bool result)
    {
        if(balances[msg.sender] >= _value)
        {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            result = true;
        }
        result = false;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) returns (bool result)
    {
        if(approvals[msg.sender].approvedAmounts[_from] >= _value && balances[_from] >= _value)
        {
            approvals[msg.sender].approvedAmounts[_from] -= _value;
            balances[_from] -= _value;

            balances[_to] += _value;
            result = true;
        }
        result = false;
    }

    function approve(address _spender, uint256 _value) returns (bool result)
    {
        approvals[msg.sender].approvedAmounts[_spender] = _value;
        result = true;
    }
    
    function allowance(address _owner, address _spender) constant returns (uint256 remaining)
    {
        remaining = approvals[_owner].approvedAmounts[_spender];
    }

    //functions from whiteboard
    function deposit() payable returns (bool result)
    {
        totalTokens += msg.value;
        balances[msg.sender] += msg.value;
        result = true;
    }

    function withdraw(uint256 _amount) returns (bool result)
    {
        if(balances[msg.sender] >= _amount && totalTokens >= _amount)
        {
            balances[msg.sender] -= _amount;
            totalTokens -= _amount;
            
            msg.sender.transfer(_amount);
            result = true;
        }
        result = false;
    }
}

