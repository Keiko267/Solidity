//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartContract {
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    // Esta función permite cargar ethers en el contrato. Los ethers enviados a esta función se agregarán al balance del contrato.
    // Puedes llamar a esta función enviando ethers junto con la transacción.
    function deposit() public payable {
        
    }
    
    // Función para repartir ethers a otro monedero
    function transfer(address payable recipient, uint256 amount) public {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        require(address(this).balance >= amount, "Insufficient balance in the contract");
        recipient.transfer(amount);
    }
}
