pragma solidity >=0.4.22 <0.9.0;

contract P {
    address public s;

    modifier mm() { 
        require(
            msg.sender == s,
            "not"
        );
        _;
    }

    function f() public view mm { 
        uint a = 10;
    }
}