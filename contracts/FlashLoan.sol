// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

/* Custom Errors */

error FlashLoan__NotOwner();

contract FlashLoan is FlashLoanSimpleReceiverBase {
    /* State Variables */

    address payable private owner;

    /*Events */

    event FlashLoanRequested(
        address indexed reciverAddress,
        address indexed token,
        uint256 indexed amount
    );

    /* Modifier */

    modifier onlyOwner() {
        if (owner != msg.sender) {
            revert FlashLoan__NotOwner();
        }
        _;
    }

    /*  Main function */

    constructor(
        address _addressProvider
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
    }

    // This function is called after the contract has received the flash loaned amount
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        // arbitary  logic goes here

        // paying back the flash loaned amount
        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
        emit FlashLoanRequested(address(this), _token, _amount);
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    receive() external payable {}
}
