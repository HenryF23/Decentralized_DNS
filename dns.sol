pragma solidity >=0.6.0 <0.8.0;

contract dns {
    struct ip_data {
        address owner;
        uint32 IP_address;
        bool initialized; // used to track if this key exist in the map
    }

    struct domain_data {
        bytes32 domain;
        bool initialized; // used to track if this key exist in the map
    }

    mapping (bytes32 => ip_data) records;
    mapping (uint32 => domain_data) reverseRecords;

    // a modifier that make sure some functions can only be called by the owner of the domain
    modifier onlyOwner(bytes32 domain) {
        assert(records[domain].initialized == true);
        require(msg.sender == records[domain].owner);
        _;
    }

    // create a record
    function createRecord(bytes32 domain, uint32 IP) public {
        require(records[domain].initialized == false);

        records[domain] = ip_data(msg.sender, IP, true);
        reverseRecords[IP] = domain_data(domain, true);
    }

    function getRecord(bytes32 domain) public view returns (uint32) {
        assert(records[domain].initialized);
        return records[domain].IP_address;
    }
    
    function getDomain(uint32 IP) public view returns (bytes32) {
        assert(reverseRecords[IP].initialized);
        return reverseRecords[IP].domain;
    }

    // untested
    function transferDomain(bytes32 domain, address userAddress) public onlyOwner(domain) returns(bool){
        records[domain].owner = userAddress;
        return true;
    }

    function updateRecord(bytes32 domain, uint32 newIP) public onlyOwner(domain) {
        records[domain].IP_address = newIP;
    }
}
