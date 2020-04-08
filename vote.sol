pragma solidity ^0.4.20;

contract VotingSystem{
    struct Voter{
        bool alreadyVoted;
        uint vote;
    }

    struct Candidate{
        bytes32 name;
        uint votes;
    }

    mapping (address => Voter) public voters;
    Candidate[] public candidates;

    address public owner;

    bool public isOpen;

    function VotingSystem (bytes32[] candidatesNames) public {
        owner = msg.sender;
        isOpen = true;
        for (uint i=0; i < candidatesNames.length; ++i){
            // The candidate is included in the array
            candidates.push(Candidate({
                name: candidatesNames[i],
                votes: 0
            }));
        }
    }
    
    
    function Vote (uint candidateVote) public {
        require(isOpen);
        Voter storage currentVoter = voters[msg.sender];
        require(!currentVoter.alreadyVoted);

        currentVoter.vote = candidateVote;
        currentVoter.alreadyVoted = true;

        candidates[candidateVote].votes++;
    }


    function CloseVoting () public {
        require((msg.sender == owner) && isOpen);
        isOpen = false;
    }

    // A function able to count votes and announce which candidate is the winner
    function GetWinner () constant returns (bytes32){
        require(!isOpen);
        uint maxAmountOfVotes = 0;
        uint winnerCandidate = 0;
        for (uint i=0; i < candidates.length; ++i){
            if (candidates[i].votes > maxAmountOfVotes){
                maxAmountOfVotes = candidates[i].votes;
                winnerCandidate = i;
            }
        }
        return candidates[winnerCandidate].name;
    }
}