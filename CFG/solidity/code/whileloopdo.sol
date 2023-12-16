pragma solidity ^0.5.0;

contract S {
   function A(uint j) internal pure  returns (uint) {
      do {   
         j -= 10;
      }
      while (j != 0);
        return j;
   }
}