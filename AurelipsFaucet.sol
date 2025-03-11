// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Hex: 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39 
// Aurelips: 0x9A880e35fcbb1A080762A0Fe117105Ad5715B897

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract AurelipsFaucetV2 is Ownable, ReentrancyGuard {
    IERC20 public aurelipsToken;
    IERC20 public constant hexToken = IERC20(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39); 
    uint256 public constant claimAmount = 1 * 10 ** 18;  // 1 ALIPS (18 decimals)
    uint256 public constant burnAmount = 100 * 10 ** 18;  // 100 ALIPS (18 decimals)
    uint256 public constant requiredHexBalance = 5000 * 10 ** 8;  // 5000 HEX (8 decimals)
    mapping(address => bool) public hasClaimed;
    address public constant BURN_ADDRESS = 0x0000000000000000000000000000000000000369;

    constructor(address _aurelipsToken) 
        Ownable(msg.sender)
    {
        aurelipsToken = IERC20(_aurelipsToken);
    }

    function claimTokens() external nonReentrant {
        require(!hasClaimed[msg.sender], "Faucet: You have already claimed");
        require(hexToken.balanceOf(msg.sender) >= requiredHexBalance, "Faucet: You must hold at least 5000 HEX");

        uint256 faucetBalance = aurelipsToken.balanceOf(address(this));
        require(faucetBalance >= (claimAmount + burnAmount), "Faucet: Insufficient funds");

        aurelipsToken.transfer(msg.sender, claimAmount);
        aurelipsToken.transfer(BURN_ADDRESS, burnAmount);

        hasClaimed[msg.sender] = true;

        emit TokensClaimed(msg.sender, claimAmount);
        emit TokensBurned(msg.sender, burnAmount);
    }

    function withdrawMistakenlySentTokens(address token, uint256 amount) external onlyOwner {
        uint256 contractBalance = IERC20(token).balanceOf(address(this));
        require(contractBalance >= amount, "Not enough tokens in the contract");
        IERC20(token).transfer(msg.sender, amount);
    }

    event TokensClaimed(address indexed user, uint256 amount);
    event TokensBurned(address indexed user, uint256 amount);
}
