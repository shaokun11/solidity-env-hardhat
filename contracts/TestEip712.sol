
//SPDX-License-Identifier: SimPL-3.0
pragma solidity ^0.7.0;

pragma solidity ^0.7.0;

contract Test {
    bytes32 public DOMAIN_SEPARATOR;
    address public rc;
    mapping(address => uint) public nonces;
    mapping(address => uint) public amounts;
    bytes32 public constant TEST_TYPEHASH = keccak256('Test(address owner,uint256 amount,uint256 nonce)');
    constructor() {
        uint chainId;
        assembly {
            chainId := chainid() // 大于6.0以上是个方法,不是属性
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes("shaokun")), // 此处一般填写此合约有意义的值
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    function testEIP712(address owner, uint256 amount, uint8 v, bytes32 r, bytes32 s) external {

        bytes32 digest = keccak256(
            abi.encodePacked('\x19\x01',
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(TEST_TYPEHASH, owner, amount, nonces[owner]++))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, "account not fit");
        rc = recoveredAddress;
        amounts[owner] += amount;

    }
}
