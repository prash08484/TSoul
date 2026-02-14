// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TwitterApp {
    // Tweet_struct
    struct Tweet {
        string content;
        address author;
        uint256 likes;
        uint256 timestamp;
    }

    // ------------------------------------------

    mapping(address => Tweet[]) Tweets;
    uint16 idx;
    uint256 constant maxTokenLength = 280;
    constructor() {
        idx = 0;
    }

    // post Tweet
    function postTweet(string memory message) public {
        // limit the message size to 200 char
        require(bytes(message).length <= maxTokenLength, "Tweet too long");
        Tweet memory newTweet = Tweet(message, msg.sender, 0, block.timestamp);
        Tweets[msg.sender].push(newTweet);
        idx++;
    }

    // fetch a single Tweet
    function getTweet(
        address user,
        uint16 index
    ) public view returns (Tweet memory) {
        uint16 totalTweets = uint16(Tweets[user].length);
        if (index > totalTweets) {
            revert("Tweet Not Found");
        }
        return (Tweets[user][index - 1]);
    }

    // fetch all Tweets
    function getAllTweets(address user) public view returns (Tweet[] memory) {
        return Tweets[user];
    }
}
