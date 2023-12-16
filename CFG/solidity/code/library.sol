pragma solidity ^0.8.0;

library Math {
    function add(uint x, uint y) internal pure returns (uint) {
        return x + y;
    }
}

contract UsingMath {
    function testAdd(uint _a, uint _b) public pure returns (uint) {
        return Math.add(_a, _b);
    }
}
