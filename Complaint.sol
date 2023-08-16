// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Complaint {

    struct Victim {
        string complaintDetails; 
        uint timestamp; 
        address WalletAddress; 
    }

    Victim[] complaintsArray;  
    mapping(address => bool) isBlacklisted;
    mapping(address => uint) userComplaintCounts;
    // uint256 public freeComplaintsCount = 2;    we will directly compare with 'number 2' instead of making a variable 
    address payable owner;  

    constructor() {
        owner = payable(msg.sender);
    }

    function SendComplaint(string memory complaintDetails) public payable {
        require(!isBlacklisted[msg.sender], "Your Account is Banned");

        if (userComplaintCounts[msg.sender] < 2) {   // this number is the number of free complaints count for each user
            userComplaintCounts[msg.sender]++;
        } else {
            // Charge Ether after the first two complaints
            uint256 etherAmount = 0.001 ether; // Example: 0.01 Ether
            require(msg.value >= etherAmount, "Insufficient Funds");
            owner.transfer(etherAmount);
            userComplaintCounts[msg.sender]++;
        }
        complaintsArray.push(Victim(complaintDetails, block.timestamp, msg.sender));
    }

    function addToBlacklist(address userAddress) public {
        // require(msg.sender == owner, "Only the owner can blacklist addresses");
        // its a good practice that the owner is only able to blacklist but it would be hectic for a single person. 
        // so we will give this function in our admin dashboard 
        isBlacklisted[userAddress] = true;
    }

    function removeFromBlacklist(address userAddress) public {
        // require(msg.sender == owner, "Only the owner can remove from blacklist");
        // its a good practice that the owner is only able to blacklist but it would be hectic for a single person. 
        // so we will give this function in our admin dashboard 
        isBlacklisted[userAddress] = false;
    }

    function fetchComplaints() public view returns(Victim[] memory) {
        return complaintsArray;
    }
}
