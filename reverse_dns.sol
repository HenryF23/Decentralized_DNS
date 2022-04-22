pragma solidity >=0.6.0 <0.8.0;

contract reverse_dns {
    struct reverse_record {
        bytes32 domain;
    }

    mapping (uint64 => reverse_record) reverse_records;

    function insertRecord(uint64 ip, bytes32 domain) public {
        reverse_records[ip] = reverse_record(domain);
    }

    function removeRecord(uint64 ip) public {
        reverse_records[ip] = reverse_record(0);
    }

    function getRecord(uint64 ip) public view returns (bytes32) {
        return reverse_records[ip].domain;
    }
}
