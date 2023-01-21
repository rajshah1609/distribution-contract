# Distribution Contract
Contract to distribute the native currency balance of the contract to multiple addresses based on the address and percent struct of array

# Steps 
1. Deploy the contract.
2. Add the address and percent array using the **addAddress** function, which will create a mapping regarding the transfers to be made to the address. *Note : * This function can only be called by the owner of the contract. When adding the address map if at any point the total will exceed 100% then it won't allow to add the address and percent map. Use 0x prefix address instead of xdc prefix address and checksum verified address to avoid any failures
3. You can check the address mapping one by one by calling the **addressArr** variable with the index, to get the value of the address and the precent defined for that index.
4. Once all the addresses have been added, transfer the desired amount of the currency you want to transfer. 
5. Call the **withdrawFunds** functions, which will transfer the currency balance of the contract address to the defined address and percent map. *Note : * This function can only be called by the owner of the contract.
