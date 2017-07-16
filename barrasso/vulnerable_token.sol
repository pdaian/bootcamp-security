pragma solidity^0.4.11;

library SafeMath {
  function mul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint a, uint b) internal returns (uint) {
    uint c = a / b;
    return c;
  }

  function sub(uint a, uint b) internal returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function add(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c >= a);
    return c;
  }

  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a < b ? a : b;
  }

  function assert(bool assertion) internal {
    if (!assertion) {
      throw;
    }
  }
}

contract ERC20Basic {
  uint public totalSupply;
  function balanceOf(address who) constant returns (uint);
  function transfer(address to, uint value);
  event Transfer(address indexed from, address indexed to, uint value);
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) constant returns (uint);
  function transferFrom(address from, address to, uint value);
  function approve(address spender, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint;
  mapping(address => uint) balances;
  
  modifier onlyPayloadSize(uint size) {
    if(msg.data.length < size) {
        throw;
    }
    _;
  }

  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
  }

  function balanceOf(address _owner) constant returns (uint balance) {
    return balances[_owner];
  }
}

contract StandardToken is BasicToken, ERC20 {

  mapping (address => mapping (address => uint)) allowed;

  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
    var _allowance = allowed[_from][msg.sender];
    balances[_to] = balances[_to].add(_value);
    balances[_from] = balances[_from].sub(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
    Transfer(_from, _to, _value);
  }

  function approve(address _spender, uint _value) {
    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
  }

  function allowance(address _owner, address _spender) constant returns (uint remaining) {
    return allowed[_owner][_spender];
  }
}

contract ERCToken is StandardToken {
	using SafeMath for uint256;
	
	event CreatedERC(address indexed _creator, uint256 _amountOfERC);
	event ERCRefundedForWei(address indexed _refunder, uint256 _amountOfWei);
	
	string public constant name = "ERC Token";
	string public constant symbol = "ERC";
	uint256 public constant decimals = 18;
	string public version = "1.0";
	
	address public executor;
	address public devETHDestination;
	address public devERCDestination;
	address public reserveERCDestination;
	
	bool public saleHasEnded;
	bool public minCapReached;
	bool public allowRefund;
	mapping (address => uint256) public ETHContributed;
	uint256 public totalETHRaised;
	uint256 public saleStartBlock;
	uint256 public saleEndBlock;
	uint256 public saleFirstEarlyBirdEndBlock;
	uint256 public saleSecondEarlyBirdEndBlock;
	uint256 public constant DEV_PORTION = 20;  // In percentage
	uint256 public constant RESERVE_PORTION = 1;  // In percentage
	uint256 public constant ADDITIONAL_PORTION = DEV_PORTION + RESERVE_PORTION;
	uint256 public constant SECURITY_ETHER_CAP = 1000000 ether;
	uint256 public constant ERC_PER_ETH_BASE_RATE = 300;
	uint256 public constant ERC_PER_ETH_FIRST_EARLY_BIRD_RATE = 330;
	uint256 public constant ERC_PER_ETH_SECOND_EARLY_BIRD_RATE = 315;
	
	function ERCToken(
		address _devETHDestination,
		address _devERCDestination,
		address _reserveERCDestination,
		uint256 _saleStartBlock,
		uint256 _saleEndBlock
	) {
		if (_devETHDestination == address(0x0)) throw;
		if (_devERCDestination == address(0x0)) throw;
		if (_reserveERCDestination == address(0x0)) throw;
		if (_saleEndBlock <= block.number) throw;
		if (_saleEndBlock <= _saleStartBlock) throw;
		executor = msg.sender;
		saleHasEnded = false;
		minCapReached = false;
		allowRefund = false;
		devETHDestination = _devETHDestination;
		devERCDestination = _devERCDestination;
		reserveERCDestination = _reserveERCDestination;
		totalETHRaised = 0;
		saleStartBlock = _saleStartBlock;
		saleEndBlock = _saleEndBlock;
		saleFirstEarlyBirdEndBlock = saleStartBlock + 6171;  // Equivalent to 24 hours later, assuming 14 second blocks
		saleSecondEarlyBirdEndBlock = saleFirstEarlyBirdEndBlock + 12342;  // Equivalent to 48 hours later after first early bird, assuming 14 second blocks
		totalSupply = 0;
	}
	
	function createTokens() payable external {
		if (saleHasEnded) throw;
		if (block.number < saleStartBlock) throw;
		if (block.number > saleEndBlock) throw;
		uint256 newEtherBalance = totalETHRaised.add(msg.value);
		if (newEtherBalance > SECURITY_ETHER_CAP) throw; 
		if (0 == msg.value) throw;
		
		uint256 curTokenRate = ERC_PER_ETH_BASE_RATE;
		if (block.number < saleFirstEarlyBirdEndBlock) {
			curTokenRate = ERC_PER_ETH_FIRST_EARLY_BIRD_RATE;
		}
		else if (block.number < saleSecondEarlyBirdEndBlock) {
			curTokenRate = ERC_PER_ETH_SECOND_EARLY_BIRD_RATE;
		}
		
		uint256 amountOfERC = msg.value.mul(curTokenRate);
		uint256 totalSupplySafe = totalSupply.add(amountOfERC);
		uint256 balanceSafe = balances[msg.sender].add(amountOfERC);
		uint256 contributedSafe = ETHContributed[msg.sender].add(msg.value);
		totalSupply = totalSupplySafe;
		balances[msg.sender] = balanceSafe;
		totalETHRaised = newEtherBalance;
		ETHContributed[msg.sender] = contributedSafe;
		CreatedERC(msg.sender, amountOfERC);
	}
	
	function endSale() {
		if (saleHasEnded) throw;
		if (!minCapReached) throw;
		if (msg.sender != executor) throw;
		
		saleHasEnded = true;

		uint256 additionalERC = (totalSupply.mul(ADDITIONAL_PORTION)).div(100 - ADDITIONAL_PORTION);
		uint256 totalSupplySafe = totalSupply.add(additionalERC);

		uint256 reserveShare = (additionalERC.mul(RESERVE_PORTION)).div(ADDITIONAL_PORTION);
		uint256 devShare = additionalERC.sub(reserveShare);

		totalSupply = totalSupplySafe;
		balances[devERCDestination] = devShare;
		balances[reserveERCDestination] = reserveShare;
		
		CreatedERC(devERCDestination, devShare);
		CreatedERC(reserveERCDestination, reserveShare);

		if (this.balance > 0) {
			if (!devETHDestination.call.value(this.balance)()) throw;
		}
	}

	function withdrawFunds() {
		if (!minCapReached) throw;
		if (0 == this.balance) throw;
		if (!devETHDestination.call.value(this.balance)()) throw;
	}
	
	function triggerMinCap() {
		if (msg.sender != executor) throw;
		minCapReached = true;
	}

	function triggerRefund() {
		if (saleHasEnded) throw;
		if (minCapReached) throw;
		if (block.number < saleEndBlock) throw;
		if (msg.sender != executor) throw;
		allowRefund = true;
	}

	function refund() external {
		if (!allowRefund) throw;
		if (0 == ETHContributed[msg.sender]) throw;
		uint256 etherAmount = ETHContributed[msg.sender];
		ETHContributed[msg.sender] = 0;
		ERCRefundedForWei(msg.sender, etherAmount);
		if (!msg.sender.send(etherAmount)) throw;
	}

	function changeDeveloperETHDestinationAddress(address _newAddress) {
		if (msg.sender != executor) throw;
		devETHDestination = _newAddress;
	}
	
	function changeDeveloperERCDestinationAddress(address _newAddress) {
		if (msg.sender != executor) throw;
		devERCDestination = _newAddress;
	}
	
	function changeReserveERCDestinationAddress(address _newAddress) {
		if (msg.sender != executor) throw;
		reserveERCDestination = _newAddress;
	}
	
	function transfer(address _to, uint _value) {
		if (!minCapReached) throw;
		super.transfer(_to, _value);
	}
	
	function transferFrom(address _from, address _to, uint _value) {
		if (!minCapReached) throw;
		super.transferFrom(_from, _to, _value);
	}
}