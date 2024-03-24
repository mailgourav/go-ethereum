// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {
    string greetingMessage;
    string name;

    /**
     * @dev Store value in variable
     * @param _authInput value to store - consists of MessageHash(32 bytes), Signature generated using Scnhorr Algo(64 bytes), Public Key(33 Bytes) 
     * @param _greetingMessage value to store
     * @param _name value to store
     */
   function store(bytes calldata _authInput, string calldata _greetingMessage, string calldata _name) external checkAccess(_authInput) {
        greetingMessage = _greetingMessage;
        name = _name;
    }

    /**
     * @dev Return value
     * @return value of 'name'
     * @return value of 'greetingMessage'
     */
    function retrieve() public view returns (string memory , string memory ) {
        return (name, greetingMessage);
    }

    modifier checkAccess(bytes calldata _authInput) {
        require(schnorrVerify(_authInput), "Signature Verification Failed, access denied");
        _;
    }

    function schnorrVerify(bytes calldata input) public view returns (bool) {
        (bool ok, bytes memory out) = address(0x0b).staticcall(
            abi.encode(input)
        );
        require(ok);
        bytes memory success = hex"01";
        bool areEqual = out.length == success.length &&
            keccak256(out) == keccak256(success);
        return (areEqual);
    }

    function testStoreSuccessTest() public {
        this.store(hex"f58f2da28925b0ea25a73954d1ae864b69dff359df87c9161c3423ffa49f57df71684040493cc46d4813d95c62a86150b0404207fc14843daebfc95e2882c19708894dbf61458de0012d3be16bba8e2c18a39fb564de6e0723eee91b9edeebb103913f5428da29ccd3e91456ac3c1d1061358f6297fd2611e9edfbc6430960621c","Gourav", "Have a good day!!!");   
    }
    function testStoreFailTest() public {
        //tempered signature
        this.store(hex"f58f2da28925b0ea25a73954d1ae864b69dff359df87c9161c3423ffa49f57df81684040493cc46d4813d95c62a86150b0404207fc14843daebfc95e2882c19708894dbf61458de0012d3be16bba8e2c18a39fb564de6e0723eee91b9edeebb103913f5428da29ccd3e91456ac3c1d1061358f6297fd2611e9edfbc6430960621c","Ram","Nice Job!!!");   
    }

}
