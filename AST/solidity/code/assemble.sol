pragma solidity ^0.5.0;

library S {   
   function a(uint[] memory d) public pure returns (uint o) {
         assembly {
            o := add(o, mload(add(d, 0x20)))
         }
   }
}