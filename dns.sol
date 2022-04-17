pragma solidity >=0.6.0 <0.8.0;

interface reverse_dns {
    function getRecord(uint32 ip) external view returns (bytes32);

    function insertRecord(uint32 ip, bytes32 domain) external;
}

contract dns {
    struct record {
        address owner;
        uint32 IP_address;
        bool initialized; // used to track if this key exist in the map
    }

    address reverse_records_address;
    reverse_dns reverse_records = reverse_dns(reverse_records_address);
    mapping (bytes32 => record) records;

    // a modifier that make sure some functions can only be called by the owner of the domain
    modifier onlyOwner(bytes32 domain) {
        assert(records[domain].initialized == true);
        require(msg.sender == records[domain].owner);
        _;
    }

    function setReverseRecordsContract(address contractAddress) public {
        reverse_records_address = contractAddress;
    }

    // create a record
    function createRecord(bytes32 domain, uint32 IP) public {
        require(records[domain].initialized == false);

        records[domain] = record(msg.sender, IP, true);

        reverse_records.insertRecord(IP, domain);
    }

    function getRecord(bytes32 domain) public view returns (uint32) {
        assert(records[domain].initialized);
        return records[domain].IP_address;
    }

    function getReverseRecord(uint32 IP) public view returns(bytes32) {
        reverse_records.getRecord(IP);
    }

    function transferDomain(bytes32 domain, address userAddress) public onlyOwner(domain) returns(bool){
        records[domain].owner = userAddress;
        return true;
    }

    function updateRecord(bytes32 domain, uint32 newIP) public onlyOwner(domain) {
        records[domain].IP_address = newIP;
    }
}
