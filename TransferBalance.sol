// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context  {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract TransferBalance is Ownable{
        constructor() payable Ownable(){
        }
        receive() external payable{}

        struct AddressMap{
            address _address;
            uint _percent;
            uint _amount;
        }

        AddressMap[] public addressArr;

        uint public addressLength;

        function addAddress(address _address,uint _percent) public onlyOwner {
            uint i=0;
            uint totalPer=0;
            for(i=0;i<addressArr.length;i++) {
                totalPer = totalPer+addressArr[i]._percent;
            }
            totalPer=totalPer+_percent;
            assert(totalPer<=100);
            addressArr.push(AddressMap(_address,_percent,0));
            addressLength=addressArr.length;            
        }

        function withdrawFunds() external onlyOwner {
        uint i=0;
        for(i=0;i<addressArr.length;i++) {
            uint amount = address(this).balance/100*addressArr[i]._percent;
            addressArr[i]._amount=amount;           
        }
        for(i=0;i<addressArr.length;i++) {
            address payable addrT = payable(addressArr[i]._address);
            addrT.transfer(addressArr[i]._amount);
        }
        }

        function receiveFunds() external payable {}

        function getBalance() public view returns(uint){
            return address(this).balance;
        }

}