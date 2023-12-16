pragma solidity ^0.8.0;

contract ErrorHandling {
    function testRequire(uint _i) public pure {
        require(_i > 10, "Input must be greater than 10");
    }

    function testRevert(uint _i) public pure {
        if (_i <= 10) {
            revert("Input must be greater than 10");
        }
    }

    function testAssert() public pure {
        assert(1 == 2); // This will always fail
    }
}
