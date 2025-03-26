//SPDX-License-Identifier: LGPL-3.0-only

pragma solidity 0.8.24;

contract MoneySaver {

    address public admin;
    uint256 public counter;

    struct Saver {
        string name;
        uint256 amount;
    }

    mapping(uint256 => Saver) public savingsList;

    constructor(address admin_){
        admin = admin_;
        counter = 0;
    }

    modifier onlyAdmin(){
        require (msg.sender == admin, "For deposit or withdraw Ether you must be the admin");
        _; 
    }

    function addEther(string memory name_, uint256 amount_) external payable {
        Saver memory newSaver = Saver({
            name: name_,
            amount: amount_
        });

        savingsList[counter] = newSaver;
        counter++;
    }

    function withdrawEther(uint256 etherAmount_, address wallet) external onlyAdmin {
        (bool success,) = wallet.call{value: etherAmount_}("");
        require(success, "Failed to withdraw Ether");
    }

    function getContributions() external view onlyAdmin returns(Saver[] memory){
        Saver[] memory savingsArray = new Saver[](counter);

        for (uint256 i = 0; i < counter; i ++) {
            savingsArray[i] = savingsList[i];
        }
        return savingsArray;
    }

}