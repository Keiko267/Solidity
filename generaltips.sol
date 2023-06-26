//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DistinguirAddress {
    function isContract(address account) public view returns (bool){
        return account.code.length > 0;
    }

    modifier isNotContract {
        require(!isContract(msg.sender), "Only EDAs");
        _;
    }

    function mintNFT() public isNotContract {

    }
}
//Account es el contrato al que voy a llamar
contract otroContrato {
    function CallIsContract (address account) public returns(bool){
        (bool success, bytes memory data) = account.call(
            abi.encodeWithSignature("isContract(adress)", address(this))
        );
        require(success);
        return abi.decode(data, (bool));
    }
   

}