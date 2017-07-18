pragma solidity ^0.4.11;

contract Auction {
    address currentLeader;
    uint highestBid;
    
    event HighestBidIncreased(address bidder, uint amount);

    function bid() payable {
        // Throw if bid is lower than highestBid 
        assert (msg.value <= highestBid);
        // Throw if unable to refund currentLeader
        assert (currentLeader.send(highestBid));
        
        currentLeader = msg.sender;
        highestBid = msg.value;
        
        HighestBidIncreased(msg.sender, msg.value);
    }
}
