# Aurelips Faucet 
# Contract: 0x4330D40D7d8b394224D5382FB055e3b9018bb312

## Overview

The **Aurelips Faucet Contract** is a decentralized smart contract deployed on the **PulseChain** blockchain. This contract allows users to claim **Aurelips (ALIPS)** tokens from the faucet, provided they meet certain criteria. Each claim results in a portion of the tokens being burned, contributing to deflationary tokenomics. The faucet is designed to prevent abuse by restricting users to a one-time claim per address.

In addition to the basic claim functionality, the contract also includes an owner-only function that allows the recovery of any mistakenly sent ERC20 tokens from the contract.

## Features

- **Claim ALIPS Tokens**: Eligible users can claim ALIPS tokens from the faucet.
- **HEX Holding Requirement**: Users must hold at least 5,000 HEX tokens to be eligible to claim ALIPS tokens.
- **Token Burning**: A percentage of each claim is burned (sent to a specified burn address).
- **One-Time Claim**: Users can only claim tokens once per address, preventing abuse.
- **Owner Token Recovery**: The contract owner can withdraw mistakenly sent ERC20 tokens.

## Contract Functions

### 1. **claimTokens()**
   - **Description**: Allows eligible users to claim ALIPS tokens once per address.
   - **Eligibility Criteria**: 
     - Must hold at least 5,000 HEX tokens.
   - **Burn Mechanism**: 10 ALIPS tokens are burned with each claim.
   - **Limits**: Users can only claim tokens once and will be marked as "claimed" after the first claim.

### 2. **withdrawMistakenlySentTokens(address token, uint256 amount)**
   - **Description**: Allows the contract owner to withdraw mistakenly sent ERC20 tokens from the contract.
   - **Restrictions**: Only the contract owner can call this function.
   - **Purpose**: To recover tokens that might have been accidentally sent to the contract.

---

## Contract Security

### 1. **Reentrancy Protection**

The contract uses the `nonReentrant` modifier from **OpenZeppelin**'s **ReentrancyGuard** to prevent reentrancy attacks. This ensures that functions like `claimTokens()` cannot be exploited by calling the same function multiple times before the transaction is completed.

### 2. **Only Owner Functions**

Functions like `withdrawMistakenlySentTokens()` are protected by the `onlyOwner` modifier, ensuring that only the contract owner can call them. This prevents unauthorized access to the contract’s tokens.

### 3. **HEX Holding Requirement**

The contract enforces that users must hold at least 5,000 HEX tokens in their wallet before they can claim ALIPS tokens. This helps reduce spam claims and ensures users have some skin in the game.

### 4. **Burn Mechanism**

A portion of each claim is sent to a burn address. This helps reduce the overall supply of ALIPS tokens and supports deflationary tokenomics.

---

## Events

### 1. **TokensClaimed**

This event is emitted whenever a user successfully claims ALIPS tokens.

- **Parameters**:
  - `user`: The address of the user who claimed the tokens.
  - `amount`: The amount of ALIPS tokens claimed.

### 2. **TokensBurned**

This event is emitted whenever ALIPS tokens are burned.

- **Parameters**:
  - `user`: The address of the user who initiated the claim.
  - `amount`: The amount of ALIPS tokens burned.

---

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgements

- **OpenZeppelin** for the contracts used for ownership management and security.
- **PulseChain** for being the blockchain platform where this contract runs.



