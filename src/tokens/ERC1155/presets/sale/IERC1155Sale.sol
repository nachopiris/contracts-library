// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

interface IERC1155SaleFunctions {

    struct SaleDetails {
        uint256 cost;
        uint64 startTime;
        uint64 endTime; // 0 end time indicates sale inactive
        bytes32 merkleRoot; // Root of allowed addresses
    }

    /**
     * Get global sales details.
     * @return Sale details.
     * @notice Global sales details apply to all tokens.
     * @notice Global sales details are overriden when token sale is active.
     */
    function globalSaleDetails() external returns (SaleDetails memory);

    /**
     * Get token sale details.
     * @param tokenId Token ID to get sale details for.
     * @return Sale details.
     * @notice Token sale details override global sale details.
     */
    function tokenSaleDetails(uint256 tokenId) external returns (SaleDetails memory);

    /**
     * Get payment token.
     * @return Payment token address.
     * @notice address(0) indicates payment in ETH.
     */
    function paymentToken() external returns (address);

    /**
     * Mint tokens.
     * @param to Address to mint tokens to.
     * @param tokenIds Token IDs to mint.
     * @param amounts Amounts of tokens to mint.
     * @param data Data to pass if receiver is contract.
     * @param proof Merkle proof for allowlist minting.
     * @notice Sale must be active for all tokens.
     */
    function mint(
        address to,
        uint256[] memory tokenIds,
        uint256[] memory amounts,
        bytes memory data,
        bytes32[] calldata proof
    )
        external
        payable;
}

interface IERC1155SaleSignals {

    event GlobalSaleDetailsUpdated(uint256 cost, uint256 supplyCap, uint64 startTime, uint64 endTime, bytes32 merkleRoot);
    event TokenSaleDetailsUpdated(uint256 tokenId, uint256 cost, uint256 supplyCap, uint64 startTime, uint64 endTime, bytes32 merkleRoot);

    /**
     * Contract already initialized.
     */
    error InvalidInitialization();

    /**
     * Sale is not active globally.
     */
    error GlobalSaleInactive();

    /**
     * Sale is not active.
     * @param tokenId Invalid Token ID.
     */
    error SaleInactive(uint256 tokenId);

    /**
     * Insufficient tokens for payment.
     * @param expected Expected amount of tokens.
     * @param actual Actual amount of tokens.
     */
    error InsufficientPayment(uint256 expected, uint256 actual);

    /**
     * Invalid token IDs.
     */
    error InvalidTokenIds();
}

interface IERC1155Sale is IERC1155SaleFunctions, IERC1155SaleSignals {}
