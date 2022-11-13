// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Test{
    address public owner;
    constructor() payable {
        owner=msg.sender;
    }
    function getSender() public view returns (address){
        return msg.sender;
    }
    
    function getPrivateSender() public view returns (address){
        return msg.sender;
    }

    function getInternalSender() view internal returns (address){
        return msg.sender;
    }

    function getEnternalSender() view external returns (address){
        return msg.sender;
    }

    function getValue() public  payable returns (uint256){
        return msg.value;
    }
    function privateGetSender() public view returns (address){
        return getPrivateSender();
    }
    
    function internalGetSender() public view returns (address){
        return getPrivateSender();
    }
    function originAddr() public view returns (address){
        return owner;
    }
}
contract Test2{
    Test test;
    
    //address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    address public owner;
    constructor() payable{
        owner=msg.sender;
        test = new Test();
    }

    //address: 0xf2B1114C644cBb3fF63Bf1dD284c8Cd716e95BE9
    function publicCall() public view returns (address){
        return test.getSender();
    }
    //address: 0xf2B1114C644cBb3fF63Bf1dD284c8Cd716e95BE9
    function innerCall() public view returns (address){
        return test.privateGetSender();
    }

    //address: 0xf2B1114C644cBb3fF63Bf1dD284c8Cd716e95BE9
    function enternalCall() public view returns (address){
        return test.getEnternalSender();
    }

    //address: 0xf2B1114C644cBb3fF63Bf1dD284c8Cd716e95BE9
    function internalCall() public view returns (address){
        return test.internalGetSender();
    }
    //address: 0xf2B1114C644cBb3fF63Bf1dD284c8Cd716e95BE9
    function originAddr() public view returns (address){
        return test.originAddr();
    }

    //address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    function callAddr() public view returns (address){
        return owner;
    }
    //address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    function callCurMsgSenderAddr() public view returns (address){
        return msg.sender;
    }
}
