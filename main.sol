// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TwitterApp {
    // ------- DATA -------------

    // Tweet_struct
    struct Tweet {
        uint256 id;
        string content;
        address author;
        uint256 likes;
        uint256 timestamp;
    }

    mapping(address => Tweet[]) Tweets;
    uint16 idx;
    address public owner;
    uint256 maxTokenLength = 280;
    // -------------- CONSTRUCTORS AND MODIFIERS DEFINATION ------------------

    constructor() {
        idx = 0;
        owner = msg.sender;
    }

    // MODIFIERS

    // check owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // ------------ GENERAL FUNCTIONS --------------

    // change owner
    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    // change tweetlenght
    function changeTweetLength(uint256 newLength) public onlyOwner {
        maxTokenLength = newLength;
    }

    // LIKE TWEET
    function likeTweet(uint256 _tid, address user) external {
        uint256 len = uint256(Tweets[user].length);
        if (_tid < len) {
            Tweets[user][_tid].likes++;
        }
    }

    // UNLIKE TWEET
    function unlikeTweet(uint256 _tid, address user) external {
        uint256 len = uint256(Tweets[user].length);
        if (_tid < len && Tweets[user][_tid].likes > 0) {
            Tweets[user][_tid].likes--;
        }
    }

    // POST TWEET
    function postTweet(string memory message) public {
        // limit the message size to 200 char
        require(bytes(message).length <= maxTokenLength, "Tweet too long");
        Tweet memory newTweet = Tweet(
            Tweets[msg.sender].length,
            message,
            msg.sender,
            0,
            block.timestamp
        );
        Tweets[msg.sender].push(newTweet);
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

    // --------------- END OF CONTRACT --------------------
}
