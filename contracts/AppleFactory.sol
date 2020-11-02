// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./Apple.sol";

interface IApple {
    function initialize(address _player, uint256 _id, uint256 _mem, uint256 _disk, string memory _c) external;
}

contract AppleFactory {

    address[] public apples;

    mapping(address => bool) public checkApple;

    bytes32 public hash;

    function getAllApples(uint _start, uint _end) public view returns(address[] memory _apples){
        _apples = new address[](_end - _start);
        for(uint i = _start; i < _end ; i++){
            _apples[i - _start] = apples[i];
        }
    }

    function totalApple() external view returns (uint256) {
        return apples.length;
    }

    event AppleCreated(address maker, uint256 _id, uint256 _memory, uint256 _disk, string _color, address _apple);

    function makeApple(
        uint256 _memory,
        uint256 _disk,
        string memory _color)
    external returns (address apple) {
        uint256 _id = apples.length + 1;
        bytes memory bytecode = type(Apple).creationCode;
        if (hash == bytes32(0)) {
            hash = keccak256(bytecode);
        }
        bytes32 salt = keccak256(abi.encodePacked(_id, _memory, _color));
        assembly {
            apple := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        require(checkApple[apple] == false, 'this apple have been made');
        IApple(apple).initialize(msg.sender, _id, _memory, _disk, _color);
        apples.push(apple);
        emit AppleCreated(msg.sender, _id, _memory, _disk, _color, apple);
    }
    /// 可以通过同样的参数计算出对应的合约地址
    function getApple(int256 _id, uint256 _memory, uint256 _disk, string calldata _color)
    external
    view
    returns (address apple){
        apple = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                address(this),
                keccak256(abi.encodePacked(_id, _memory, _disk, _color)),
                hash
            ))));
    }
}
