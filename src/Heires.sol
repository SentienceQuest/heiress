// SPDX-License-Identifier: MIT
///@title Heir/es Protocol
///@notice A contract to set the beneficiary of a Trust, which can be claimed after the timer expires
///@author MiguelBits , futjr
///@dev This contract requires the previous approval of the Heir/es Module contract to this contract
///@dev A Heir/es Module is represented by an ERC6551 which is implemented with ERC721

pragma solidity 0.8.20;

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
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

//import ReentrancyGuard
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

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
