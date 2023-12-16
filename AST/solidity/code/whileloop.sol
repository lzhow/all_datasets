pragma solidity ^0.5.0;

contract S {
   function A(uint j) internal pure returns (uint) {
      while (j != 0) {
         j += 10;
      }
        return j;
   }
}