//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Test {
    //Test puede cargar 100 ethers y repartirlos entre 50 personas
    address public owner;
    mapping(address => uint256) public balances;
    uint256 public totalDeposited;   
    //Total proportion of ethers to be distributed
    uint256 public totalProportion = 100;
    
    struct Recipient {
        address recipient;
        uint256 proportion;
    }
    //Recipients array
    Recipient[] public recipients;

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }
    //modifier so that only one ether or more can be deposited
    modifier onlyOneEther() {
        require(msg.value >= 1 ether, "Minimum deposit amount is 1 Ether");
        _;
    }
    
    //modifier so that 100 ethers at most can be deposited, including the message value
    modifier maxBalance() {
        require(totalDeposited + msg.value <= 100 ether, "Maximum contract balance reached");
        _;
    }
    //Proportion must be greater than 0 when adding a recipient
    modifier validateProportion(uint256 proportion) {
        require(proportion > 0, "Proportion must be greater than zero");
        _;
    }
    modifier validateTotalProportion() {
        require(totalProportion == 100, "Total proportion must be 100");
        _;
    }
    // Function to deposit ethers, requires onlyOneEther and maxBalance modifiers
    function deposit() public payable onlyOneEther maxBalance{
        balances[msg.sender] += msg.value;
        totalDeposited += msg.value;
    }

    // Función para añadir un destinatario y su proporción de distribución
    function addRecipient(address recipient, uint256 proportion) public onlyOwner validateProportion(proportion) {
        require(recipients.length < 50, "Maximum number of recipients reached");
        require(recipient != address(0), "Invalid recipient address");
        // Añadir el destinatario al array
        recipients.push(Recipient(recipient, proportion));
        // Actualizar la proporción total
        totalProportion -= proportion;
    }
    
    // Función para distribuir ethers a los destinatarios
    function distribute() public onlyOwner validateTotalProportion {
        require(totalDeposited > 0, "No ethers available for distribution");
        require(address(this).balance >= totalDeposited, "Insufficient contract balance");
        require(recipients.length >0,  "No recipients available for distribution");
        require(totalProportion == 0, "Total proportion must be 100");
        for (uint i = 0; i < recipients.length; i++) {
            uint256 share = totalDeposited * recipients[i].proportion / 100;            
            // Avoid potential reentrancy attacks
            (bool success, ) = recipients[i].recipient.call{value: share}("");
            require(success, "Failed to send Ether");
        }
        totalDeposited = 0;        
    }
    function getRecipients() public view returns (address[] memory, uint256[] memory){
        address[] memory recipientAddresses = new address[](recipients.length);
        uint256[] memory recipientProportions = new uint256[](recipients.length);

        for (uint i = 0; i < recipients.length; i++) {
            recipientAddresses[i] = recipients[i].recipient;
            recipientProportions[i] = recipients[i].proportion;
        }
        return (recipientAddresses, recipientProportions);
    }
}
