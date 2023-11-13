// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import {ERC1155MintBurn, ERC1155} from "@0xsequence/erc-1155/contracts/tokens/ERC1155/ERC1155MintBurn.sol";
import {
    IERC1155TokenMinter,
    IERC1155TokenMinterFunctions
} from "@0xsequence/contracts-library/tokens/ERC1155//presets/minter/IERC1155TokenMinter.sol";
import {ERC1155Token} from "@0xsequence/contracts-library/tokens/ERC1155/ERC1155Token.sol";
import {ERC2981Controlled} from "@0xsequence/contracts-library/tokens/common/ERC2981Controlled.sol";

/**
 * An implementation of ERC-1155 capable of minting when role provided.
 */
contract ERC1155TokenMinter is ERC1155MintBurn, ERC1155Token, IERC1155TokenMinter {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    address private immutable initializer;
    bool private initialized;

    constructor() {
        initializer = msg.sender;
    }

    /**
     * Initialize the contract.
     * @param owner Owner address
     * @param tokenName Token name
     * @param tokenBaseURI Base URI for token metadata
     * @param tokenContractURI Contract URI for token metadata
     * @param royaltyReceiver Address of who should be sent the royalty payment
     * @param royaltyFeeNumerator The royalty fee numerator in basis points (e.g. 15% would be 1500)
     * @dev This should be called immediately after deployment.
     */
    function initialize(
        address owner,
        string memory tokenName,
        string memory tokenBaseURI,
        string memory tokenContractURI,
        address royaltyReceiver,
        uint96 royaltyFeeNumerator
    )
        public
        virtual
    {
        if (msg.sender != initializer || initialized) {
            revert InvalidInitialization();
        }

        ERC1155Token._initialize(owner, tokenName, tokenBaseURI, tokenContractURI);
        _setDefaultRoyalty(royaltyReceiver, royaltyFeeNumerator);

        _setupRole(MINTER_ROLE, owner);

        initialized = true;
    }

    //
    // Minting
    //

    /**
     * Mint tokens.
     * @param to Address to mint tokens to.
     * @param tokenId Token ID to mint.
     * @param amount Amount of tokens to mint.
     * @param data Data to pass if receiver is contract.
     */
    function mint(address to, uint256 tokenId, uint256 amount, bytes memory data) external onlyRole(MINTER_ROLE) {
        _mint(to, tokenId, amount, data);
    }

    /**
     * Mint tokens.
     * @param to Address to mint tokens to.
     * @param tokenIds Token IDs to mint.
     * @param amounts Amounts of tokens to mint.
     * @param data Data to pass if receiver is contract.
     */
    function batchMint(address to, uint256[] memory tokenIds, uint256[] memory amounts, bytes memory data)
        external
        onlyRole(MINTER_ROLE)
    {
        _batchMint(to, tokenIds, amounts, data);
    }

    //
    // Views
    //

    /**
     * Check interface support.
     * @param interfaceId Interface id
     * @return True if supported
     */
    function supportsInterface(bytes4 interfaceId) public view override (ERC1155Token, ERC1155) returns (bool) {
        return type(IERC1155TokenMinterFunctions).interfaceId == interfaceId || ERC1155Token.supportsInterface(interfaceId);
    }
}
