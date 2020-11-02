// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract Apple {
    struct Action {
        uint step;
        string from;
        string to;
        uint256 time;
        address player;
    }

    uint256 public id;                      // 序列号
    string public color;                    //颜色
    uint256 public flashMemory;             // 运行内存大小 4g
    uint256 public diskMemory;              //  储存空间大小 256g
    address public player;                  // 可以更新此合约数据的用户
    uint256 public actionCount;             // 总共加工次数
    Action[] public actions;
    address public factory;

    function getApple()
    public
    view
    returns (uint _id, uint _memory, uint _disk, uint _count, address _player, string memory _color){
        _id = id;
        _memory = flashMemory;
        _disk = diskMemory;
        _count = actionCount;
        _player = player;
        _color = color;

    }

    constructor() {
        factory = msg.sender;
    }

    event Trace(address player, string from, string to, uint256 time);
    event PlayerUpdate(address _pre, address newPlayer, uint256 time);

    function initialize(
        address _player,
        uint256 _id,
        uint256 _memory,
        uint256 _disk,
        string memory _color)
    external {
        require(msg.sender == factory, "permission deny");
        player = _player;
        id = _id;
        color = _color;
        flashMemory = _memory;
        diskMemory = _disk;
        _processAction("apple", "init");
    }

    function getActions(uint _start, uint _end) public view returns (Action[] memory atcs){
        uint end = _end + 1 >=  actions.length ? actions.length : _end;
        atcs = new Action[](end - _start);
        for (uint i = _start; i < end; i++) {
            atcs[i - _start] = actions[i];
        }
    }

    modifier onlyPlayer {
        require(player == msg.sender, "permission deny");
        _;
    }

    function updatePlayer(address _player) onlyPlayer external {
        address oldPlayer = player;
        player = _player;
        emit PlayerUpdate(oldPlayer, _player, block.timestamp);
    }

    function _processAction(string memory _from, string memory _to) internal {
        actionCount += 1;
        actions.push(Action({from : _from, to : _to, time : block.timestamp, step : actionCount,player:msg.sender}));
        emit Trace(player, _from, _to, block.timestamp);
    }

    function processAction(string memory _from, string memory _to) onlyPlayer public {
        _processAction(_from, _to);
    }

}
