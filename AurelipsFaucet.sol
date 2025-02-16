// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Hex: 0x2b591e99afe9f32eaa6214f7b7629768c40eeb39
// Aurelips: 0x9A880e35fcbb1A080762A0Fe117105Ad5715B897

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract AurelipsFaucet is Ownable, ReentrancyGuard {
    IERC20 public aurelipsToken;
    IERC20 public hexToken;
    uint256 public constant claimAmount = 1 * 10 ** 18;  // 1 ALIPS
    uint256 public constant burnAmount = 10 * 10 ** 18;  // 10 ALIPS
    uint256 public constant requiredHexBalance = 5000 * 10 ** 18;  // 5000 HEX
    mapping(address => bool) public hasClaimed;
    address public constant BURN_ADDRESS = 0x0000000000000000000000000000000000000369;

    // The constructor now sets the msg.sender as the owner
    constructor(address _aurelipsToken, address _hexToken) 
        Ownable(msg.sender) // Automatically sets the deployer as the owner
    {
        aurelipsToken = IERC20(_aurelipsToken);
        hexToken = IERC20(_hexToken);
    }

    // Function to claim tokens from the faucet
    function claimTokens() external nonReentrant {
        require(!hasClaimed[msg.sender], "Faucet: You have already claimed");
        require(hexToken.balanceOf(msg.sender) >= requiredHexBalance, "Faucet: You must hold at least 5000 HEX");

        uint256 faucetBalance = aurelipsToken.balanceOf(address(this));
        require(faucetBalance >= (claimAmount + burnAmount), "Faucet: Insufficient funds");

        // Transfer ALIPS to the user
        aurelipsToken.transfer(msg.sender, claimAmount);

        // Burn ALIPS by sending to the burn address
        aurelipsToken.transfer(BURN_ADDRESS, burnAmount);

        // Mark as claimed
        hasClaimed[msg.sender] = true;

        // Emit events
        emit TokensClaimed(msg.sender, claimAmount);
        emit TokensBurned(msg.sender, burnAmount);
    }

    // Function to allow the owner to withdraw mistakenly sent ERC20 tokens
    function withdrawMistakenlySentTokens(address token, uint256 amount) external onlyOwner {
        uint256 contractBalance = IERC20(token).balanceOf(address(this));
        require(contractBalance >= amount, "Not enough tokens in the contract");
        
        // Transfer tokens to the owner
        IERC20(token).transfer(msg.sender, amount);
    }

    // Event to notify when tokens are claimed
    event TokensClaimed(address indexed user, uint256 amount);

    // Event to notify when tokens are burned
    event TokensBurned(address indexed user, uint256 amount);
}
