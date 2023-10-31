// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import {ERC721Token} from "@0xsequence/contracts-library/tokens/ERC721/ERC721Token.sol";
import {IERC721TokenMinter} from "@0xsequence/contracts-library/tokens/ERC721/presets/minter/IERC721TokenMinter.sol";

/**
 * An implementation of ERC-721 capable of minting when role provided.
 */
contract ERC721TokenMinter is ERC721Token, IERC721TokenMinter {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    address private immutable _initializer;
    bool private _initialized;

    /**
     * Deploy contract.
     */
    constructor() ERC721Token() {
        _initializer = msg.sender;
    }

    /**
     * Initialize contract.
     * @param owner The owner of the contract
     * @param tokenName Name of the token
     * @param tokenSymbol Symbol of the token
     * @param tokenBaseURI Base URI of the token
     * @param royaltyReceiver Address of who should be sent the royalty payment
     * @param royaltyFeeNumerator The royalty fee numerator in basis points (e.g. 15% would be 1500)
     * @dev This should be called immediately after deployment.
     */
    function initialize(
        address owner,
        string memory tokenName,
        string memory tokenSymbol,
        string memory tokenBaseURI,
        address royaltyReceiver,
        uint96 royaltyFeeNumerator
    )
        public
        virtual
    {
        if (msg.sender != _initializer || _initialized) {
            revert InvalidInitialization();
        }

        ERC721Token._initialize(owner, tokenName, tokenSymbol, tokenBaseURI);
        _setDefaultRoyalty(royaltyReceiver, royaltyFeeNumerator);

        _setupRole(MINTER_ROLE, owner);

        _initialized = true;
    }

    //
    // Minting
    //

    /**
     * Mint tokens.
     * @param to Address to mint tokens to.
     * @param amount Amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    //
    // Admin
    //

    /**
     * Set name and symbol of token.
     * @param tokenName Name of token.
     * @param tokenSymbol Symbol of token.
     */
    function setNameAndSymbol(string memory tokenName, string memory tokenSymbol)
        external
        onlyRole(METADATA_ADMIN_ROLE)
    {
        _tokenName = tokenName;
        _tokenSymbol = tokenSymbol;
    }
}