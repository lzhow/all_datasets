pragma solidity ^0.5.0;

contract S {
  
   function f(uint a, uint b, uint c, uint r) public view returns(uint) {
      if( a > b) {  
         r = a;
      } else {
         r = b+c;
      }    
      return r; 
   }
}