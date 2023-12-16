pragma solidity ^0.8.0;

contract ArrayExample {
    uint[] public dynamicArray;
    uint[5] public fixedArray;

    function addElement(uint element) public {
        dynamicArray.push(element);
    }
}
