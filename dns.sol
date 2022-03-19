pragma solidity 0.6.0;

contract dns {
    struct data {
        address owner;
        string IP_address;
        bool initialized; // used to track if this key exist in the map
    }

    mapping (string => data) records;

    // a modifier that make sure some functions can only be called by the owner of the domain
    modifier onlyOwner(string memory domain) {
        require(msg.sender == records[domain].owner);
        _;
    }

    // create a record
    function createRecord(string memory domain, string memory IP) public returns (bool) {
        if (records[domain].initialized) {
            return false; // check if this domain has been created or not
        }
        records[domain] = data(msg.sender, IP, true);
        return true;
    }

    function getRecord(string memory domain) public view returns (string memory) {
        return records[domain].IP_address;
    }

    // untested
    function transferDomain(string memory domain, address userAddress) public onlyOwner(domain) returns(bool){
        records[domain].owner = userAddress;
        return true;
    }

    function updateRecord(string memory domain, string memory newIP) public onlyOwner(domain) returns(bool) {
        if (records[domain].initialized) {
            return false; // check if this domain has been created or not
        }
        require(msg.sender == records[domain].owner);

        records[domain].IP_address = newIP;
        return true;
    }
}
