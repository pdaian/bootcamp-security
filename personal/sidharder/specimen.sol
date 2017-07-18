pragma solidity ^0.4.0;

contract Specimen {

    string public description;
    string public collectionDate;
    address public currentFacility;
    address public destinationFacility;
    bool public inTransit;
    bool public hasBeenDisposed;
    address public approvedFacilities;

    function Specimen(string _description, string _collectionDate, address _approvedFacilities) {
        description = _description;
        collectionDate = _collectionDate;
        approvedFacilities = _approvedFacilities;
        inTransit = false;
        hasBeenDisposed = false;
    }

    function sendTo(address _destinationFacility) returns (bool) {
        if(msg.sender == currentFacility) {
            if (TrustedFacilities(approvedFacilities).approved(_destinationFacility)) {
                inTransit = true;
                destinationFacility = _destinationFacility;
                return true;
            } else { return false; }
        } else { return false; }
    }

    function receiveFrom() returns (bool) {
        if(msg.sender == destinationFacility) {
            currentFacility = msg.sender;
            return true;
        } else { return true; }
    }

    function dispose() {
        if(msg.sender == currentFacility) {
            hasBeenDisposed = true;
        }
    }

}

contract CollectionFacility {

    string public name = "Name of entity collecting the specimen";
    string public streetAddress = "Address of entity collecting the specimen";

    function SpecimenCollector(string _name, string _streetAddress) {
        name = _name;
        streetAddress = _streetAddress;
    }

}

contract TrustedFacilities {

    address adminAddress;

    function TrustedFacilities(address _adminAddress) {
        adminAddress = _adminAddress;
    }

    function add(address _facilityAddress) public returns (bool) {
        if (msg.sender == adminAddress) {
            facilities[_facilityAddress] = true;
            return true;
        } else {
            return false;
        }
    }

    function remove(address _facilityAddress) public returns (bool) {
        if (msg.sender == adminAddress) {
            facilities[_facilityAddress] = false;
            return true;
        } else {
            return false;
        }
    }

    function approved(address _facilityAddress) public returns (bool) {
        if(facilities[_facilityAddress] == true) {
            return true;
        } else {
            return false;
        }
    }

    mapping (address => bool) facilities;

}
