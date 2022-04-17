pragma solidity >=0.6.0 <0.8.0;

contract reverse_dns {
    struct reverse_record {
        bytes32 domain;
    }

    mapping (uint32 => reverse_record) reverse_records;

    function getRecord(uint32 ip) public view returns (bytes32) {
        return reverse_records[ip].domain;
    }

    function insertRecord(uint32 ip, bytes32 domain) public {
        reverse_records[ip] = reverse_record(domain);
    }
}
