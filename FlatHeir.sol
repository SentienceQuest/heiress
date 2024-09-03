// SPDX-License-Identifier: MIT
pragma solidity =0.8.20 ^0.8.20;

// lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/ReentrancyGuard.sol)

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/IERC721.sol)

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// src/Heires.sol

///@title Heir/es Protocol
///@notice A contract to set the beneficiary of a Trust, which can be claimed after the timer expires
///@author MiguelBits , futjr
///@dev This contract requires the previous approval of the Heir/es Module contract to this contract
///@dev A Heir/es Module is represented by an ERC6551 which is implemented with ERC721

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Note to the User:
// Author: 0xMiguelBits
// Reviewer: futjr                      
                          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@                          
                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            @@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           @@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            @@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            @@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            @@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            @@@@@@@@@@@@@@                         
                         @@%%%%%%%%%%%%@@%@@@@@@@@@@@@@@@@@@@@@@@            @%%%%%%%%%%%%@                         
                         @%%%%%%%%%%%%%@                                     %%%%%%%%%%%%%@                         
                         @%%%%%%%%%%%%%@                                     %%%%%%%%%%%%%@                         
                         @%%%%%%%%%%%%%@                                     %%%%%%%%%%%%%@                         
                         @%%%%%%%%%%%%%@                                     %%%%%%%%%%%%%@                         
                         %%%%%%%%%%%%%%@                                     %%%%%%%%%%%%%@                         
                         %%%%%%%%%%%%%%@                ####                 %%%%%%%%%%%%%%                         
                         @%%%%%%%%%%%%%                ######                %%%%%%%%%%%%%@                         
                                                      ########                                                      
                                                     #%########                                                     
                                                    ########%%##                                                    
                                                   ##############                                                   
                                                     ###########                                                    
                                                      #%#####%                                                      
                          %%%%%%%%%%%%%                ##%###                %%%%%%%%%%%%%@                         
                         %%%%%%%%%%%%%%%                %%#%                 %%%%%%%%%%%%%@                         
                         %%%%%%%%%%%%%%@                 %%                  %%%%%%%%%%%%%@                         
                         %%%%%%%%%%%%%%@                                     %%%%%%%%%%%%%@                         
                         @%%%%%%%%%%%%%@                                     %%%%%%%%%%%%%@                         
                         @%%%%%%%%%%%%%@                                     %%%%%%%%%%%%%@                         
                         @%%%%%%%%%%%%%@                                     %%%%%%%%%%%%%@                         
                         @%%%%%%%%%%%%%@            @@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%%%@                         
                         @@@@@@@@@@@@@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                         
                         @@@@@@@@@@@@@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                         
                          @@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                         
                                                                                                                    
                                                                                                                    
                                                                                                                    
                                                                                                                    
                                                                                     %@%                            
                          %%   %%%   %%%%%%    %%    %%%%%%%       %%   @%%%%%%   %%%%@%%%                          
                          %%   %%%   %%        %%    %%   %%@     %%%   @%        %%                                
                          %%@@@%%@   %%@@@@    %@    @@@@@%%     @@@    @%@@@@@    @@%@@@                           
                          @@   @@@   @@        @@    @@  @@     @@@     @@              @@@                         
                          @@   @@@   @@        @@    @@   @@   @@@      @@        @@@   @@@                         
                          @@    @    @@@@@@    @@    @@    @   @@        @@@@@@     @@@@@                           
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
//import IERC721

//import ReentrancyGuard

contract Heires is ReentrancyGuard {
    // Contract variables and state
    address public descendantModule0;
    address public descendantModule1;
    address public descendantModule2;
    address public descendantModule3;
    address public descendantModule4;

    event ModuleSet(address indexed _descendantModule, uint256 indexed _moduleId, address _beneficiary, uint256 _timer);
    event ModuleBenefiaryReplaced(
        address indexed _descendantModule, uint256 indexed _moduleId, address _previousBeneficiary, address _newBeneficiary
    );
    event ModuleReset(address indexed _descendantModule, uint256 indexed _moduleId, uint256 _timer);
    event ModuleClaimed(address indexed _descendantModule, uint256 indexed _moduleId, address _beneficiary);
    event ModuleCanceled(address indexed _descendantModule, uint256 indexed _moduleId, uint256 _timer);

    // Mapping of descendantModule to module id to beneficiary
    mapping(address descendantModule => mapping(uint256 moduleId => address beneficiary)) descendantModule_beneficiary;
    // Mapping of descendantModule to module id to timer
    mapping(address descendantModule => mapping(uint256 moduleId => uint256 timer)) descendantModule_timer;
    // Mapping of descendantModule to module id to owner
    mapping(address descendantModule => mapping(uint256 moduleId => address owner)) descendantModule_owner;

    ///@notice Checks if the module is supported by the contract, if there is timer is not expired, if the user is the owner of the module and if the user has approved the module to this contract
    modifier moduleSupportedRequirements(address _descendantModule, uint256 _moduleId) {
        address ownerOfModule = IERC721(_descendantModule).ownerOf(_moduleId);
        address ownerOfWill = descendantModule_owner[_descendantModule][_moduleId];

        //Check if _descendantModule is one of the approved descendantModules
        require(
            _descendantModule == descendantModule0 || _descendantModule == descendantModule1 || _descendantModule == descendantModule2
                || _descendantModule == descendantModule3 || _descendantModule == descendantModule4,
            "Heires: This contract is not supported."
        );

        //Check if the module is not set previously,
        //and if set,
        //then check if the owner is the same, i.e., the module was not transferred
        if (ownerOfWill != address(0) && ownerOfWill == ownerOfModule) {
            if (descendantModule_timer[_descendantModule][_moduleId] != 0) {
                //Check if the module timer is not expired
                require(
                    block.timestamp < descendantModule_timer[_descendantModule][_moduleId],
                    "Module: The module timer has expired"
                );
            }
        }

        //Check if the user is the owner of the module
        require(msg.sender == ownerOfModule, "Module: Only the owner of the module can call this function");

        //Check if user approved the descendantModule to this contract; //isApprovedForAll(address owner, address operator)
        require(
            IERC721(_descendantModule).isApprovedForAll(msg.sender, address(this)),
            "Module: User has not approved the descendantModule to this contract"
        );

        _;
    }

    ///@notice Checks if the module was set previously
    modifier moduleSetRequirements(address _descendantModule, uint256 _moduleId) {
        //Check if the module timer is not 0
        require(descendantModule_timer[_descendantModule][_moduleId] != 0, "Module: Module settings requirements not met.");
        _;
    }

    ///@param _descendantModule0 The address of the first tier descendantModule
    ///@param _descendantModule1 The address of the second tier descendantModule
    ///@param _descendantModule2 The address of the third tier descendantModule
    ///@param _descendantModule3 The address of the fourth tier descendantModule
    ///@param _descendantModule4 The address of the fifth tier descendantModule
    constructor(
        address _descendantModule0,
        address _descendantModule1,
        address _descendantModule2,
        address _descendantModule3,
        address _descendantModule4
    ) {
        // Initialize contract state
        descendantModule0 = _descendantModule0;
        descendantModule1 = _descendantModule1;
        descendantModule2 = _descendantModule2;
        descendantModule3 = _descendantModule3;
        descendantModule4 = _descendantModule4;
    }

    ///@notice This function allows the user to set the beneficiary of the module, which can be claimed after the timer expires
    ///@notice This function can be called by the owner of the module only, anytime before the timer expires
    ///@dev This function requires previous approval of Sentience Module contract to this contract
    ///@param _descendantModule The address of the descendantModule
    ///@param _moduleId The id of the module
    ///@param _timer The time in seconds after which the module can be claimed
    ///@param _beneficiary The address of the beneficiary
    function setModule(address _descendantModule, uint256 _moduleId, uint256 _timer, address _beneficiary)
        external
        moduleSupportedRequirements(_descendantModule, _moduleId)
    {
        //Check if the beneficiary is not address(0)
        require(_beneficiary != address(0), "Beneficiary cannot be address(0)");

        address _previousBeneficiary = descendantModule_beneficiary[_descendantModule][_moduleId];
        if (_previousBeneficiary != _beneficiary) {
            //Set the beneficiary of the module
            descendantModule_beneficiary[_descendantModule][_moduleId] = _beneficiary;
            if (_previousBeneficiary != address(0)) {
                //Emit event
                emit ModuleBenefiaryReplaced(_descendantModule, _moduleId, _previousBeneficiary, _beneficiary);
            }
        }

        //Set the timer of the module
        descendantModule_timer[_descendantModule][_moduleId] = block.timestamp + _timer;

        //Set the owner of the module
        descendantModule_owner[_descendantModule][_moduleId] = msg.sender;

        //Emit event
        emit ModuleSet(_descendantModule, _moduleId, _beneficiary, _timer);
    }

    ///@notice This function allows the user to reset the timer of the module
    ///@notice This function can be called by the owner of the module only, anytime before the timer expires
    ///@dev This function requires previous set of the module
    ///@param _descendantModule The address of the descendantModule
    ///@param _moduleId The id of the module
    ///@param _timer The time in seconds after which the module can be claimed
    function resetModuleTimer(address _descendantModule, uint256 _moduleId, uint256 _timer)
        external
        moduleSetRequirements(_descendantModule, _moduleId)
        moduleSupportedRequirements(_descendantModule, _moduleId)
    {
        //Reset the timer of the module
        descendantModule_timer[_descendantModule][_moduleId] = block.timestamp + _timer;

        //Emit event
        emit ModuleReset(_descendantModule, _moduleId, _timer);
    }

    ///@notice This function allows the user to claim the module after the timer expires, and the module can be claimed for the beneficiary
    ///@dev This function requires previous set of the module, and if module changes ownership
    ///@param _descendantModule The address of the descendantModule
    ///@param _moduleId The id of the module
    function claimModule(address _descendantModule, uint256 _moduleId) external nonReentrant {
        //Check if the module timer is expired
        require(
            block.timestamp >= descendantModule_timer[_descendantModule][_moduleId],
            "Module: The module timer has not expired yet"
        );

        //Check if the module owner is the same, and the module was not transferred
        address _owner = descendantModule_owner[_descendantModule][_moduleId];
        address _beneficiary = descendantModule_beneficiary[_descendantModule][_moduleId];

        //Reset the timer of the module
        descendantModule_timer[_descendantModule][_moduleId] = 0;

        //Reset the beneficiary of the module
        descendantModule_beneficiary[_descendantModule][_moduleId] = address(0);

        //Reset the owner of the module
        descendantModule_owner[_descendantModule][_moduleId] = address(0);

        //If the module is not approved for this contract or owner transferred module, then reset module mappings
        if (
            IERC721(_descendantModule).isApprovedForAll(_owner, address(this))
                && IERC721(_descendantModule).ownerOf(_moduleId) == _owner
        ) {
            //Safe transfer the module to the beneficiary
            IERC721(_descendantModule).safeTransferFrom(_owner, _beneficiary, _moduleId);

            //Emit event
            emit ModuleClaimed(_descendantModule, _moduleId, _beneficiary);
        } else {
            //Emit event
            emit ModuleCanceled(_descendantModule, _moduleId, descendantModule_timer[_descendantModule][_moduleId]);
        }
    }

    ///@notice This function allows the user to view the information of the module, i.e., the beneficiary and the timer
    ///@param _descendantModule The address of the descendantModule
    ///@param _moduleId The id of the module
    ///@return The address of the beneficiary and the timer of the module
    function viewModuleInformation(address _descendantModule, uint256 _moduleId)
        external
        view
        returns (address, uint256)
    {
        return (descendantModule_beneficiary[_descendantModule][_moduleId], descendantModule_timer[_descendantModule][_moduleId]);
    }
}
