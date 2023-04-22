// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >= 0.5.0 < 0.9.0;
contract Twitter {

struct user{
        address id;
        string password;
}
struct Tweet{
    uint id;
    address author;
    string content;
    uint createdAt;
}
struct Message{
uint id;
string content;
address from;
address to;
uint createdAt;
}
struct image{
      string imageHash;
      string caption;
      uint uploaded_at;
}
mapping(address => bool) public loggedIn;
mapping(uint=> Tweet) public tweets;
mapping(address=>image[]) public images;
mapping(address => uint[]) public tweetsOf;
mapping(address=>Message[])public chats;
mapping(address=>address[]) public followings;
uint nextId;
uint nextMessageld;

user[] public u1;
image[] public i1;

function create_user(address _id, string memory pass) public returns(string memory) {
    for (uint i = 0; i < u1.length; i++) {
        if (u1[i].id == _id) {
            return "user already exists";
        }
    }
    u1.push(user(_id, pass));
    return "user created successfully";
}
    function log_in(address uid, string memory passd) public returns(string memory){
        for(uint j = 0; j<u1.length; j++){
            if(uid==u1[j].id && keccak256(abi.encodePacked(passd))==keccak256(abi.encodePacked(u1[j].password))){
                loggedIn[uid] = true;
                return "welcome to the twitter";
            }
        }
        return "wrong id password";
    }
function tweet(address _from,string memory _content) public {
    require(Twitter(msg.sender).loggedIn(msg.sender), "You need to log in first");
    require(_from==msg.sender, "You don't have access");
    tweets[nextId] = Tweet(nextId,_from, _content,block.timestamp);
    tweetsOf[_from].push(nextId);
    nextId = nextId + 1;
}

function sendMessage(address _from,address _to,string memory _content) public{
    require(_from == msg.sender,"You don't have access");
    chats[_from].push(Message(nextMessageld, _content,_from,_to,block.timestamp));
    nextMessageld ++;
}
function uploadImage(string memory hash,string memory _caption) public{
       images[msg.sender].push(image(hash,_caption,block.timestamp));
}
function follow(address _followed) public {
    followings [msg.sender].push(_followed);
}

function getLatestTweets(uint count) public view returns(Tweet[] memory){
    require (count>0 && count <= nextId,"count is not proper");
    Tweet[] memory _tweets = new Tweet[](count);
    uint j;
    for (uint i = nextId-count;i<nextId;i++){
        Tweet memory _structure = _tweets[i];
        _tweets[j] = Tweet(_structure.id,
        _structure.author,
        _structure.content,
        _structure.createdAt);
        j = j+1;
    }
    return _tweets;
    }
    function getLatestofUser(address _user, uint count) public view returns(Tweet[] memory){
        Tweet[] memory _tweets = new Tweet[](count);
        uint[] memory ids = tweetsOf[_user];
        require(count>0 && count<=ids.length,"count is not defined");
        uint j;
       for(uint i = ids.length-count;i<ids.length;i++){
           Tweet storage _structure = tweets[ids[i]];
           _tweets[j] = Tweet(_structure.id,
           _structure.author,
           _structure.content,
           _structure.createdAt);
           j = j+1;
       }
       return _tweets;
    }

    function log_out() public {
    loggedIn[msg.sender] = false;}
}