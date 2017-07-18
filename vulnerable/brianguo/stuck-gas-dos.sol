pragma solidity ^0.4.0;


contract vulnerableBank {


    /*
        ExploitBank wanted to stop wasting gas in checking overflow limits.
        Their solution was to store each deposit as a separate entry in an array
        and not to have variables for account balance and total supply.

    */
    struct payment {
        address owner;
        uint256 amount;
    }

    payment[] moneyPot;

    function totalSupply() constant returns(uint256 total) {
        uint256 balance = 0;
        for (uint i = 0; i < moneyPot.length; i++){
            balance += moneyPot[i].amount;
        }
        return balance;
    }

    function balanceOf(address addr) constant returns(uint256 balance) {
        uint256 balance = 0;
        for (uint i = 0; i < moneyPot.length; i++){
            if (moneyPot[i].owner == addr){
                balance += moneyPot[i].amount;
            }
        }
        return balance;
    }

    function deposit() payable {
        moneyPot.push(payment(msg.sender, msg.value));
    }

    function withdraw(uint256 amount) {
        uint256 currentamt = amount;
        for(uint i = 0; i < moneyPot.length; i++){
            if (moneyPot[i].owner == msg.sender){
                if (moneyPot[i].amount < currentamt){
                    currentamt -= moneyPot[i].amount;
                    msg.sender.send(moneyPot[i].amount);
                    moneyPot[i].amount = 0;
                }
                else {
                    moneyPot[i].amount -= currentamt;
                    msg.sender.send(currentamt);
                    break;
                }
            }
        }
    }
}