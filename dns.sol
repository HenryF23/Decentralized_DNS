pragma solidity >=0.6.0 <0.8.0;

interface reverse_dns {
    function getRecord(uint64 ip) external view returns (bytes32);

    function insertRecord(uint64 ip, bytes32 domain) external;

    function removeRecord(uint64 ip) external;
}

contract dns {
    struct record {
        address owner;
        uint64 IP_address;
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
        reverse_records = reverse_dns(reverse_records_address);
    }

    // create a record
    function createRecord(bytes32 domain, uint64 IP) public {
        require(records[domain].initialized == false);

        records[domain] = record(msg.sender, IP, true);

        reverse_records.insertRecord(IP, domain);
    }

    function getRecord(bytes32 domain) public view returns (uint64) {
        assert(records[domain].initialized);
        return records[domain].IP_address;
    }

    function getReverseRecord(uint64 IP) public view returns(bytes32) {
        return reverse_records.getRecord(IP);
    }

    function transferDomain(bytes32 domain, address userAddress) public onlyOwner(domain) returns(bool){
        records[domain].owner = userAddress;
        return true;
    }

    function updateRecord(bytes32 domain, uint64 newIP) public onlyOwner(domain) {
        reverse_records.removeRecord(records[domain].IP_address);
        records[domain].IP_address = newIP;
        reverse_records.insertRecord(newIP, domain);
    }
}
