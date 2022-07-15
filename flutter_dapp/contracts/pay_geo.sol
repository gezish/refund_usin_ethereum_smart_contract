// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract PerchaseAgreement{
    uint public value;
    address payable public employeer;
    address payable public employee;
    uint public max_dis = 10;
    uint public current_add = 7;
    uint public min_dis = 5;
    string public Notice;
    //address payable public locations;
    //public uint locations;
    enum State { Created, Locked, Release, Inactive}//, locations }
    State public state;

    constructor() payable{//initialization
        employeer = payable(msg.sender) ;// cast to payable address
        value = msg.value /2 ;
        //locations = 12.0;
    }

    /// The function can be called at the current state.
    error InvalidState();

    /// Only the employee can call this function
    error OnlyEmployee();


    /// Only the Employeer can call this function
    error OnlyEmployeer();

    modifier inState(State state_){
        if(state != state_){
            revert InvalidState();
        }
        _;
    }


    modifier onlyemployee(){
        if(msg.sender != employee){
            revert OnlyEmployee();
        }
        _;
    }
    modifier onlyEmployeer(){
            if(msg.sender != employeer){
                revert OnlyEmployeer();
            }
            _;
        }


// next employee sends meny for the life of the contract desigination
    function sendLocation() external inState(State.Created) payable {
        //if(locations < 10.0){ 
        require (msg.value == (2*value), "Please send in 2x the purchase amount");
        if(current_add >min_dis && current_add <= max_dis){
            employee = payable(msg.sender);
            state = State. Locked;
        } else {
            Notice = "Employee out of the rigion is not able to request refund";
        }

        
        //}else {
        //    require(msg.locations == locations, "you are out of the intended region");
        //    state = State. Locked;
        //}
        
    }

    function confirmLocation() external inState(State.Locked){//confirmValidity
        state = State.Release;
        employee.transfer(value);

    }

    function payEmployee() external onlyEmployeer inState(State.Release){
        state = State.Inactive;

        employeer.transfer(3*value);
    }
// if the seeler chanages the his mind to cancell all the transaction with the employee
    function abort() external onlyEmployeer inState(State.Created){
        state = State.Inactive;
        employeer.transfer(address(this).balance);
    }
}