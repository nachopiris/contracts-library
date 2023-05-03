// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

// A contract for errors for extensibility.
abstract contract ERC1155SupplyErrors {
    /**
     * Insufficient supply.
     */
    error InsufficientSupply();

    /**
     * Invalid array input length.
     */
    error InvalidArrayLength();
}
