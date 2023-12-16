// SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

contract Amp is IERC20, ERC1820Client, ERC1820Implementer, ErrorCodes, Ownable {
    using SafeMath for uint256;

    /**************************************************************************/
    /********************** ERC1820 Interface Constants ***********************/

    /**
     * @dev AmpToken interface label.
     */
    string internal constant AMP_INTERFACE_NAME = "AmpToken";

    /**
     * @dev ERC20Token interface label.
     */
    string internal constant ERC20_INTERFACE_NAME = "ERC20Token";

    /**
     * @dev AmpTokensSender interface label.
     */
    string internal constant AMP_TOKENS_SENDER = "AmpTokensSender";

    /**
     * @dev AmpTokensRecipient interface label.
     */
    string internal constant AMP_TOKENS_RECIPIENT = "AmpTokensRecipient";

    /**
     * @dev AmpTokensChecker interface label.
     */
    string internal constant AMP_TOKENS_CHECKER = "AmpTokensChecker";

    /**************************************************************************/
    /*************************** Token properties *****************************/

    /**
     * @dev Token name (Amp).
     */
    string internal _name;

    /**
     * @dev Token symbol (AMP).
     */
    string internal _symbol;

    /**
     * @dev Total minted supply of token. This will increase comensurately with
     * successful swaps of the swap token.
     */
    uint256 internal _totalSupply;

    /**
     * @dev The granularity of the token. Hard coded to 1.
     */
    uint256 internal constant _granularity = 1;

    /**************************************************************************/
    /***************************** Token mappings *****************************/

    /**
     * @dev Mapping from tokenHolder to balance. This reflects the balance
     * across all partitions of an address.
     */
    mapping(address => uint256) internal _balances;

    /**************************************************************************/
    /************************** Partition mappings ****************************/

    /**
     * @dev List of active partitions. This list reflects all partitions that
     * have tokens assigned to them.
     */
    bytes32[] internal _totalPartitions;

    /**
     * @dev Mapping from partition to their index.
     */
    mapping(bytes32 => uint256) internal _indexOfTotalPartitions;

    /**
     * @dev Mapping from partition to global balance of corresponding partition.
     */
    mapping(bytes32 => uint256) public totalSupplyByPartition;

    /**
     * @dev Mapping from tokenHolder to their partitions.
     */
    mapping(address => bytes32[]) internal _partitionsOf;

    /**
     * @dev Mapping from (tokenHolder, partition) to their index.
     */
    mapping(address => mapping(bytes32 => uint256)) internal _indexOfPartitionsOf;

    /**
     * @dev Mapping from (tokenHolder, partition) to balance of corresponding
     * partition.
     */
    mapping(address => mapping(bytes32 => uint256)) internal _balanceOfByPartition;

    /**
     * @notice Default partition of the token.
     * @dev All ERC20 operations operate solely on this partition.
     */
    bytes32
        public constant defaultPartition = 0x0000000000000000000000000000000000000000000000000000000000000000;

    /**
     * @dev Zero partition prefix. Parititions with this prefix can not have
     * a strategy assigned, and partitions with a different prefix must have one.
     */
    bytes4 internal constant ZERO_PREFIX = 0x00000000;

    /**************************************************************************/
    /***************************** Operator mappings **************************/

    /**
     * @dev Mapping from (tokenHolder, operator) to authorized status. This is
     * specific to the token holder.
     */
    mapping(address => mapping(address => bool)) internal _authorizedOperator;

    /**************************************************************************/
    /********************** Partition operator mappings ***********************/

    /**
     * @dev Mapping from (partition, tokenHolder, spender) to allowed value.
     * This is specific to the token holder.
     */
    mapping(bytes32 => mapping(address => mapping(address => uint256)))
        internal _allowedByPartition;

    /**
     * @dev Mapping from (tokenHolder, partition, operator) to 'approved for
     * partition' status. This is specific to the token holder.
     */
    mapping(address => mapping(bytes32 => mapping(address => bool)))
        internal _authorizedOperatorByPartition;

    /**************************************************************************/
    /********************** Collateral Manager mappings ***********************/
    /**
     * @notice Collection of registered collateral managers.
     */
    address[] public collateralManagers;
    /**
     * @dev Mapping of collateral manager addresses to registration status.
     */
    mapping(address => bool) internal _isCollateralManager;

    /**************************************************************************/
    /********************* Partition Strategy mappings ************************/

    /**
     * @notice Collection of reserved partition strategies.
     */
    bytes4[] public partitionStrategies;

    /**
     * @dev Mapping of partition strategy flag to registration status.
     */
    mapping(bytes4 => bool) internal _isPartitionStrategy;

    /**************************************************************************/
    /***************************** Swap storage *******************************/

    /**
     * @notice Swap token address. Immutable.
     */
    ISwapToken public swapToken;

    /**
     * @notice Swap token graveyard address.
     * @dev This is the address that the incoming swapped tokens will be
     * forwarded to upon successfully minting Amp.
     */
    address
        public constant swapTokenGraveyard = 0x000000000000000000000000000000000000dEaD;

   

    /**
     * @notice Initialize Amp, initialize the default partition, and register the
     * contract implementation in the global ERC1820Registry.
     * @param _swapTokenAddress_ The address of the ERC20 token that is set to be
     * swappable for Amp.
     * @param _name_ Name of the token.
     * @param _symbol_ Symbol of the token.
     */
    constructor(
        address _swapTokenAddress_,
        string memory _name_,
        string memory _symbol_
    ) public {
        // "Swap token cannot be 0 address"
        require(_swapTokenAddress_ != address(0), EC_5A_INVALID_SWAP_TOKEN_ADDRESS);
        swapToken = ISwapToken(_swapTokenAddress_);

        _name = _name_;
        _symbol = _symbol_;
        _totalSupply = 0;

        // Add the default partition to the total partitions on deploy
        _addPartitionToTotalPartitions(defaultPartition);

        // Register contract in ERC1820 registry
        ERC1820Client.setInterfaceImplementation(AMP_INTERFACE_NAME, address(this));
        ERC1820Client.setInterfaceImplementation(ERC20_INTERFACE_NAME, address(this));

        // Indicate token verifies Amp and ERC20 interfaces
        ERC1820Implementer._setInterface(AMP_INTERFACE_NAME);
        ERC1820Implementer._setInterface(ERC20_INTERFACE_NAME);
    }

    /**************************************************************************/
    /** EXTERNAL FUNCTIONS (ERC20) ********************************************/
    /**************************************************************************/

    /**
     * @notice Get the total number of issued tokens.
     * @return Total supply of tokens currently in circulation.
     */
    function totalSupply() external override view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @notice Get the balance of the account with address `_tokenHolder`.
     * @dev This returns the balance of the holder across all partitions. Note
     * that due to other functionality in Amp, this figure should not be used
     * as the arbiter of the amount a token holder will successfully be able to
     * send via the ERC20 compatible `transfer` method. In order to get that
     * figure, use `balanceOfByParition` and to get the balance of the default
     * partition.
     * @param _tokenHolder Address for which the balance is returned.
     * @return Amount of token held by `_tokenHolder` in the default partition.
     */
    function balanceOf(address _tokenHolder) external override view returns (uint256) {
        return _balances[_tokenHolder];
    }

    /**
     * @notice Transfer token for a specified address.
     * @dev This method is for ERC20 compatibility, and only affects the
     * balance of the `msg.sender` address's default partition.
     * @param _to The address to transfer to.
     * @param _value The value to be transferred.
     * @return A boolean that indicates if the operation was successful.
     */
    function transfer(address _to, uint256 _value) external override returns (bool) {
        _transferByDefaultPartition(msg.sender, msg.sender, _to, _value, "");
        return true;
    }

    /**
     * @notice Transfer tokens from one address to another.
     * @dev This method is for ERC20 compatibility, and only affects the
     * balance and allowance of the `_from` address's default partition.
     * @param _from The address which you want to transfer tokens from.
     * @param _to The address which you want to transfer to.
     * @param _value The amount of tokens to be transferred.
     * @return A boolean that indicates if the operation was successful.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override returns (bool) {
        _transferByDefaultPartition(msg.sender, _from, _to, _value, "");
        return true;
    }

    /**
     * @notice Check the value of tokens that an owner allowed to a spender.
     * @dev This method is for ERC20 compatibility, and only affects the
     * allowance of the `msg.sender`'s default partition.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the value of tokens still available for the
     * spender.
     */
    function allowance(address _owner, address _spender)
        external
        override
        view
        returns (uint256)
    {
        return _allowedByPartition[defaultPartition][_owner][_spender];
    }

    /**
     * @notice Approve the passed address to spend the specified amount of
     * tokens from the default partition on behalf of 'msg.sender'.
     * @dev This method is for ERC20 compatibility, and only affects the
     * allowance of the `msg.sender`'s default partition.
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     * @return A boolean that indicates if the operation was successful.
     */
    function approve(address _spender, uint256 _value) external override returns (bool) {
        _approveByPartition(defaultPartition, msg.sender, _spender, _value);
        return true;
    }

    /**
     * @notice Atomically increases the allowance granted to `_spender` by the
     * for caller.
     * @dev This is an alternative to {approve} that can be used as a mitigation
     * problems described in {IERC20-approve}.
     * Emits an {Approval} event indicating the updated allowance.
     * Requirements:
     * - `_spender` cannot be the zero address.
     * @dev This method is for ERC20 compatibility, and only affects the
     * allowance of the `msg.sender`'s default partition.
     * @param _spender Operator allowed to transfer the tokens
     * @param _addedValue Additional amount of the `msg.sender`s tokens `_spender`
     * is allowed to transfer
     * @return 'true' is successful, 'false' otherwise
     */
    function increaseAllowance(address _spender, uint256 _addedValue)
        external
        returns (bool)
    {
        _approveByPartition(
            defaultPartition,
            msg.sender,
            _spender,
            _allowedByPartition[defaultPartition][msg.sender][_spender].add(_addedValue)
        );
        return true;
    }

    /**
     * @notice Atomically decreases the allowance granted to `_spender` by the
     * caller.
     * @dev This is an alternative to {approve} that can be used as a mitigation
     * for bugs caused by reentrancy.
     * Emits an {Approval} event indicating the updated allowance.
     * Requirements:
     * - `_spender` cannot be the zero address.
     * - `_spender` must have allowance for the caller of at least
     * `_subtractedValue`.
     * @dev This method is for ERC20 compatibility, and only affects the
     * allowance of the `msg.sender`'s default partition.
     * @param _spender Operator allowed to transfer the tokens
     * @param _subtractedValue Amount of the `msg.sender`s tokens `_spender`
     * is no longer allowed to transfer
     * @return 'true' is successful, 'false' otherwise
     */
    function decreaseAllowance(address _spender, uint256 _subtractedValue)
        external
        returns (bool)
    {
        _approveByPartition(
            defaultPartition,
            msg.sender,
            _spender,
            _allowedByPartition[defaultPartition][msg.sender][_spender].sub(
                _subtractedValue
            )
        );
        return true;
    }

    /**************************************************************************/
    /** EXTERNAL FUNCTIONS (AMP) **********************************************/
    /**************************************************************************/

    /******************************** Swap  ***********************************/

    /**
     * @notice Swap tokens to mint AMP.
     * @dev Requires `_from` to have given allowance of swap token to contract.
     * Otherwise will throw error code 53 (Insuffient Allowance).
     * @param _from Token holder to execute the swap for.
     */
    function swap(address _from) public {
        uint256 amount = swapToken.allowance(_from, address(this));
        require(amount > 0, EC_53_INSUFFICIENT_ALLOWANCE);

        require(
            swapToken.transferFrom(_from, swapTokenGraveyard, amount),
            EC_60_SWAP_TRANSFER_FAILURE
        );

        _mint(msg.sender, _from, amount);

        emit Swap(msg.sender, _from, amount);
    }

    /**************************************************************************/
    /************************** Holder information ****************************/

    /**
     * @notice Get balance of a tokenholder for a specific partition.
     * @param _partition Name of the partition.
     * @param _tokenHolder Address for which the balance is returned.
     * @return Amount of token of partition `_partition` held by `_tokenHolder` in the token contract.
     */
    function balanceOfByPartition(bytes32 _partition, address _tokenHolder)
        external
        view
        returns (uint256)
    {
        return _balanceOfByPartition[_tokenHolder][_partition];
    }

    /**
     * @notice Get partitions index of a token holder.
     * @param _tokenHolder Address for which the partitions index are returned.
     * @return Array of partitions index of '_tokenHolder'.
     */
    function partitionsOf(address _tokenHolder) external view returns (bytes32[] memory) {
        return _partitionsOf[_tokenHolder];
    }

    /**************************************************************************/
    /************************** Advanced Transfers ****************************/

    /**
     * @notice Transfer tokens from a specific partition on behalf of a token
     * holder, optionally changing the parittion and optionally including
     * arbitrary data with the transfer.
     * @dev This can be used to transfer an address's own tokens, or transfer
     * a different addresses tokens by specifying the `_from` param. If
     * attempting to transfer from a different address than `msg.sender`, the
     * `msg.sender` will need to be an operator or have enough allowance for the
     * `_partition` of the `_from` address.
     * @param _partition Name of the partition to transfer from.
     * @param _from Token holder.
     * @param _to Token recipient.
     * @param _value Number of tokens to transfer.
     * @param _data Information attached to the transfer. Will contain the
     * destination partition (if changing partitions).
     * @param _operatorData Information attached to the transfer, by the operator.
     * @return Destination partition.
     */
    function transferByPartition(
        bytes32 _partition,
        address _from,
        address _to,
        uint256 _value,
        bytes calldata _data,
        bytes calldata _operatorData
    ) external returns (bytes32) {
        return
            _transferByPartition(
                _partition,
                msg.sender,
                _from,
                _to,
                _value,
                _data,
                _operatorData
            );
    }

    /**************************************************************************/
    /************************** Operator Management ***************************/

    /**
     * @notice Set a third party operator address as an operator of 'msg.sender'
     * to transfer and redeem tokens on its behalf.
     * @dev The msg.sender is always an operator for itself, and does not need to
     * be explicitly added.
     * @param _operator Address to set as an operator for 'msg.sender'.
     */
    function authorizeOperator(address _operator) external {
        require(_operator != msg.sender, EC_58_INVALID_OPERATOR);

        _authorizedOperator[msg.sender][_operator] = true;
        emit AuthorizedOperator(_operator, msg.sender);
    }

    /**
     * @notice Remove the right of the operator address to be an operator for
     * 'msg.sender' and to transfer and redeem tokens on its behalf.
     * @dev The msg.sender is always an operator for itself, and cannot be
     * removed.
     * @param _operator Address to rescind as an operator for 'msg.sender'.
     */
    function revokeOperator(address _operator) external {
        require(_operator != msg.sender, EC_58_INVALID_OPERATOR);

        _authorizedOperator[msg.sender][_operator] = false;
        emit RevokedOperator(_operator, msg.sender);
    }

    /**
     * @notice Set `_operator` as an operator for 'msg.sender' for a given partition.
     * @dev The msg.sender is always an operator for itself, and does not need to
     * be explicitly added to a partition.
     * @param _partition Name of the partition.
     * @param _operator Address to set as an operator for 'msg.sender'.
     */
    function authorizeOperatorByPartition(bytes32 _partition, address _operator)
        external
    {
        require(_operator != msg.sender, EC_58_INVALID_OPERATOR);

        _authorizedOperatorByPartition[msg.sender][_partition][_operator] = true;
        emit AuthorizedOperatorByPartition(_partition, _operator, msg.sender);
    }

    /**
     * @notice Remove the right of the operator address to be an operator on a
     * given partition for 'msg.sender' and to transfer and redeem tokens on its
     * behalf.
     * @dev The msg.sender is always an operator for itself, and cannot be
     * removed from a partition.
     * @param _partition Name of the partition.
     * @param _operator Address to rescind as an operator on given partition for
     * 'msg.sender'.
     */
    function revokeOperatorByPartition(bytes32 _partition, address _operator) external {
        require(_operator != msg.sender, EC_58_INVALID_OPERATOR);

        _authorizedOperatorByPartition[msg.sender][_partition][_operator] = false;
        emit RevokedOperatorByPartition(_partition, _operator, msg.sender);
    }

    /**************************************************************************/
    /************************** Operator Information **************************/
    /**
     * @notice Indicate whether the `_operator` address is an operator of the
     * `_tokenHolder` address.
     * @dev An operator in this case is an operator across all of the partitions
     * of the `msg.sender` address.
     * @param _operator Address which may be an operator of `_tokenHolder`.
     * @param _tokenHolder Address of a token holder which may have the
     * `_operator` address as an operator.
     * @return 'true' if operator is an operator of 'tokenHolder' and 'false'
     * otherwise.
     */
    function isOperator(address _operator, address _tokenHolder)
        external
        view
        returns (bool)
    {
        return _isOperator(_operator, _tokenHolder);
    }

    /**
     * @notice Indicate whether the operator address is an operator of the
     * `_tokenHolder` address for the given partition.
     * @param _partition Name of the partition.
     * @param _operator Address which may be an operator of tokenHolder for the
     * given partition.
     * @param _tokenHolder Address of a token holder which may have the
     * `_operator` address as an operator for the given partition.
     * @return 'true' if 'operator' is an operator of `_tokenHolder` for
     * partition '_partition' and 'false' otherwise.
     */
    function isOperatorForPartition(
        bytes32 _partition,
        address _operator,
        address _tokenHolder
    ) external view returns (bool) {
        return _isOperatorForPartition(_partition, _operator, _tokenHolder);
    }

    /**
     * @notice Indicate when the `_operator` address is an operator of the
     * `_collateralManager` address for the given partition.
     * @dev This method is the same as `isOperatorForPartition`, except that it
     * also requires the address that `_operator` is being checked for MUST be
     * a registered collateral manager, and this method will not execute
     * partition strategy operator check hooks.
     * @param _partition Name of the partition.
     * @param _operator Address which may be an operator of `_collateralManager`
     * for the given partition.
     * @param _collateralManager Address of a collateral manager which may have
     * the `_operator` address as an operator for the given partition.
     */
    function isOperatorForCollateralManager(
        bytes32 _partition,
        address _operator,
        address _collateralManager
    ) external view returns (bool) {
        return
            _isCollateralManager[_collateralManager] &&
            (_isOperator(_operator, _collateralManager) ||
                _authorizedOperatorByPartition[_collateralManager][_partition][_operator]);
    }

    /**************************************************************************/
    /***************************** Token metadata *****************************/
    /**
     * @notice Get the name of the token (Amp).
     * @return Name of the token.
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @notice Get the symbol of the token (AMP).
     * @return Symbol of the token.
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @notice Get the number of decimals of the token.
     * @dev Hard coded to 18.
     * @return The number of decimals of the token (18).
     */
    function decimals() external pure returns (uint8) {
        return uint8(18);
    }

    /**
     * @notice Get the smallest part of the token that’s not divisible.
     * @dev Hard coded to 1.
     * @return The smallest non-divisible part of the token.
     */
    function granularity() external pure returns (uint256) {
        return _granularity;
    }

    /**
     * @notice Get list of existing partitions.
     * @return Array of all exisiting partitions.
     */
    function totalPartitions() external view returns (bytes32[] memory) {
        return _totalPartitions;
    }

    /************************************************************************************************/
    /******************************** Partition Token Allowances ************************************/
    /**
     * @notice Check the value of tokens that an owner allowed to a spender.
     * @param _partition Name of the partition.
     * @param _owner The address which owns the tokens.
     * @param _spender The address which will spend the tokens.
     * @return The value of tokens still for the spender to transfer.
     */
    function allowanceByPartition(
        bytes32 _partition,
        address _owner,
        address _spender
    ) external view returns (uint256) {
        return _allowedByPartition[_partition][_owner][_spender];
    }

    /**
     * @notice Approve the `_spender` address to spend the specified amount of
     * tokens in `_partition` on behalf of 'msg.sender'.
     * @param _partition Name of the partition.
     * @param _spender The address which will spend the tokens.
     * @param _value The amount of tokens to be tokens.
     * @return A boolean that indicates if the operation was successful.
     */
    function approveByPartition(
        bytes32 _partition,
        address _spender,
        uint256 _value
    ) external returns (bool) {
        _approveByPartition(_partition, msg.sender, _spender, _value);
        return true;
    }

    /**
     * @notice Atomically increases the allowance granted to `_spender` by the
     * caller.
     * @dev This is an alternative to {approveByPartition} that can be used as
     * a mitigation for bugs caused by reentrancy.
     * Emits an {ApprovalByPartition} event indicating the updated allowance.
     * Requirements:
     * - `_spender` cannot be the zero address.
     * @param _partition Name of the partition.
     * @param _spender Operator allowed to transfer the tokens
     * @param _addedValue Additional amount of the `msg.sender`s tokens `_spender`
     * is allowed to transfer
     * @return 'true' is successful, 'false' otherwise
     */
    function increaseAllowanceByPartition(
        bytes32 _partition,
        address _spender,
        uint256 _addedValue
    ) external returns (bool) {
        _approveByPartition(
            _partition,
            msg.sender,
            _spender,
            _allowedByPartition[_partition][msg.sender][_spender].add(_addedValue)
        );
        return true;
    }

    /**
     * @notice Atomically decreases the allowance granted to `_spender` by the
     * caller.
     * @dev This is an alternative to {approveByPartition} that can be used as
     * a mitigation for bugs caused by reentrancy.
     * Emits an {ApprovalByPartition} event indicating the updated allowance.
     * Requirements:
     * - `_spender` cannot be the zero address.
     * - `_spender` must have allowance for the caller of at least
     * `_subtractedValue`.
     * @param _spender Operator allowed to transfer the tokens
     * @param _subtractedValue Amount of the `msg.sender`s tokens `_spender` is
     * no longer allowed to transfer
     * @return 'true' is successful, 'false' otherwise
     */
    function decreaseAllowanceByPartition(
        bytes32 _partition,
        address _spender,
        uint256 _subtractedValue
    ) external returns (bool) {
        // TOOD: Figure out if safe math will panic below 0
        _approveByPartition(
            _partition,
            msg.sender,
            _spender,
            _allowedByPartition[_partition][msg.sender][_spender].sub(_subtractedValue)
        );
        return true;
    }

    /**************************************************************************/
    /************************ Collateral Manager Admin ************************/

    /**
     * @notice Allow a collateral manager to self-register.
     * @dev Error 0x5c.
     */
    function registerCollateralManager() external {
        // Short circuit a double registry
        require(!_isCollateralManager[msg.sender], EC_5C_ADDRESS_CONFLICT);

        collateralManagers.push(msg.sender);
        _isCollateralManager[msg.sender] = true;

        emit CollateralManagerRegistered(msg.sender);
    }

    /**
     * @notice Get the status of a collateral manager.
     * @param _collateralManager The address of the collateral mananger in question.
     * @return 'true' if `_collateralManager` has self registered, 'false'
     * otherwise.
     */
    function isCollateralManager(address _collateralManager)
        external
        view
        returns (bool)
    {
        return _isCollateralManager[_collateralManager];
    }

    /**************************************************************************/
    /************************ Partition Strategy Admin ************************/
    /**
     * @notice Sets an implementation for a partition strategy identified by prefix.
     * @dev This is an administration method, callable only by the owner of the
     * Amp contract.
     * @param _prefix The 4 byte partition prefix the strategy applies to.
     * @param _implementation The address of the implementation of the strategy hooks.
     */
    function setPartitionStrategy(bytes4 _prefix, address _implementation) external {
        require(msg.sender == owner(), EC_56_INVALID_SENDER);
        require(!_isPartitionStrategy[_prefix], EC_5E_PARTITION_PREFIX_CONFLICT);
        require(_prefix != ZERO_PREFIX, EC_5F_INVALID_PARTITION_PREFIX_0);

        string memory iname = PartitionUtils._getPartitionStrategyValidatorIName(_prefix);

        ERC1820Client.setInterfaceImplementation(iname, _implementation);
        partitionStrategies.push(_prefix);
        _isPartitionStrategy[_prefix] = true;

        emit PartitionStrategySet(_prefix, iname, _implementation);
    }

    /**
     * @notice Return if a partition strategy has been reserved and has an
     * implementation registered.
     * @param _prefix The partition strategy identifier.
     * @return 'true' if the strategy has been registered, 'false' if not.
     */
    function isPartitionStrategy(bytes4 _prefix) external view returns (bool) {
        return _isPartitionStrategy[_prefix];
    }

    /**************************************************************************/
    /*************************** INTERNAL FUNCTIONS ***************************/
    /**************************************************************************/

    /**************************************************************************/
    /**************************** Token Transfers *****************************/

    /**
     * @dev Transfer tokens from a specific partition.
     * @param _fromPartition Partition of the tokens to transfer.
     * @param _operator The address performing the transfer.
     * @param _from Token holder.
     * @param _to Token recipient.
     * @param _value Number of tokens to transfer.
     * @param _data Information attached to the transfer. Contains the destination
     * partition if a partition change is requested.
     * @param _operatorData Information attached to the transfer, by the operator
     * (if any).
     * @return Destination partition.
     */
    function _transferByPartition(
        bytes32 _fromPartition,
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data,
        bytes memory _operatorData
    ) internal returns (bytes32) {
        require(_to != address(0), EC_57_INVALID_RECEIVER);

        // If the `_operator` is attempting to transfer from a different `_from`
        // address, first check that they have the requisite operator or
        // allowance permissions.
        if (_from != _operator) {
            require(
                _isOperatorForPartition(_fromPartition, _operator, _from) ||
                    (_value <= _allowedByPartition[_fromPartition][_from][_operator]),
                EC_53_INSUFFICIENT_ALLOWANCE
            );

            // If the sender has an allowance for the partition, that should
            // be decremented
            if (_allowedByPartition[_fromPartition][_from][_operator] >= _value) {
                _allowedByPartition[_fromPartition][_from][msg
                    .sender] = _allowedByPartition[_fromPartition][_from][_operator].sub(
                    _value
                );
            } else {
                _allowedByPartition[_fromPartition][_from][_operator] = 0;
            }
        }

        _callPreTransferHooks(
            _fromPartition,
            _operator,
            _from,
            _to,
            _value,
            _data,
            _operatorData
        );

        require(
            _balanceOfByPartition[_from][_fromPartition] >= _value,
            EC_52_INSUFFICIENT_BALANCE
        );

        bytes32 toPartition = PartitionUtils._getDestinationPartition(
            _data,
            _fromPartition
        );

        _removeTokenFromPartition(_from, _fromPartition, _value);
        _addTokenToPartition(_to, toPartition, _value);
        _callPostTransferHooks(
            toPartition,
            _operator,
            _from,
            _to,
            _value,
            _data,
            _operatorData
        );

        emit Transfer(_from, _to, _value);
        emit TransferByPartition(
            _fromPartition,
            _operator,
            _from,
            _to,
            _value,
            _data,
            _operatorData
        );

        if (toPartition != _fromPartition) {
            emit ChangedPartition(_fromPartition, toPartition, _value);
        }

        return toPartition;
    }

    /**
     * @notice Transfer tokens from default partitions.
     * @dev Used as a helper method for ERC20 compatibility.
     * @param _operator The address performing the transfer.
     * @param _from Token holder.
     * @param _to Token recipient.
     * @param _value Number of tokens to transfer.
     * @param _data Information attached to the transfer, and intended for the
     * token holder (`_from`). Should contain the destination partition if
     * changing partitions.
     */
    function _transferByDefaultPartition(
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data
    ) internal {
        _transferByPartition(defaultPartition, _operator, _from, _to, _value, _data, "");
    }

    /**
     * @dev Remove a token from a specific partition.
     * @param _from Token holder.
     * @param _partition Name of the partition.
     * @param _value Number of tokens to transfer.
     */
    function _removeTokenFromPartition(
        address _from,
        bytes32 _partition,
        uint256 _value
    ) internal {
        if (_value == 0) {
            return;
        }

        _balances[_from] = _balances[_from].sub(_value);

        _balanceOfByPartition[_from][_partition] = _balanceOfByPartition[_from][_partition]
            .sub(_value);
        totalSupplyByPartition[_partition] = totalSupplyByPartition[_partition].sub(
            _value
        );

        // If the total supply is zero, finds and deletes the partition.
        // Do not delete the _defaultPartition from totalPartitions.
        if (totalSupplyByPartition[_partition] == 0 && _partition != defaultPartition) {
            _removePartitionFromTotalPartitions(_partition);
        }

        // If the balance of the TokenHolder's partition is zero, finds and
        // deletes the partition.
        if (_balanceOfByPartition[_from][_partition] == 0) {
            uint256 index = _indexOfPartitionsOf[_from][_partition];

            if (index == 0) {
                return;
            }

            // move the last item into the index being vacated
            bytes32 lastValue = _partitionsOf[_from][_partitionsOf[_from].length - 1];
            _partitionsOf[_from][index - 1] = lastValue; // adjust for 1-based indexing
            _indexOfPartitionsOf[_from][lastValue] = index;

            _partitionsOf[_from].pop();
            _indexOfPartitionsOf[_from][_partition] = 0;
        }
    }

    /**
     * @dev Add a token to a specific partition.
     * @param _to Token recipient.
     * @param _partition Name of the partition.
     * @param _value Number of tokens to transfer.
     */
    function _addTokenToPartition(
        address _to,
        bytes32 _partition,
        uint256 _value
    ) internal {
        if (_value == 0) {
            return;
        }

        _balances[_to] = _balances[_to].add(_value);

        if (_indexOfPartitionsOf[_to][_partition] == 0) {
            _partitionsOf[_to].push(_partition);
            _indexOfPartitionsOf[_to][_partition] = _partitionsOf[_to].length;
        }
        _balanceOfByPartition[_to][_partition] = _balanceOfByPartition[_to][_partition]
            .add(_value);

        if (_indexOfTotalPartitions[_partition] == 0) {
            _addPartitionToTotalPartitions(_partition);
        }
        totalSupplyByPartition[_partition] = totalSupplyByPartition[_partition].add(
            _value
        );
    }

    /**
     * @dev Add a partition to the total partitions collection.
     * @param _partition Name of the partition.
     */
    function _addPartitionToTotalPartitions(bytes32 _partition) internal {
        _totalPartitions.push(_partition);
        _indexOfTotalPartitions[_partition] = _totalPartitions.length;
    }

    /**
     * @dev Remove a partition to the total partitions collection.
     * @param _partition Name of the partition.
     */
    function _removePartitionFromTotalPartitions(bytes32 _partition) internal {
        uint256 index = _indexOfTotalPartitions[_partition];

        if (index == 0) {
            return;
        }

        // move the last item into the index being vacated
        bytes32 lastValue = _totalPartitions[_totalPartitions.length - 1];
        _totalPartitions[index - 1] = lastValue; // adjust for 1-based indexing
        _indexOfTotalPartitions[lastValue] = index;

        _totalPartitions.pop();
        _indexOfTotalPartitions[_partition] = 0;
    }

    /**************************************************************************/
    /********************************* Hooks **********************************/
    /**
     * @notice Check for and call the 'AmpTokensSender' hook on the sender address
     * (`_from`), and, if `_fromPartition` is within the scope of a strategy,
     * check for and call the 'AmpPartitionStrategy.tokensFromPartitionToTransfer'
     * hook for the strategy.
     * @param _fromPartition Name of the partition to transfer tokens from.
     * @param _operator Address which triggered the balance decrease (through
     * transfer).
     * @param _from Token holder.
     * @param _to Token recipient for a transfer.
     * @param _value Number of tokens the token holder balance is decreased by.
     * @param _data Extra information, pertaining to the `_from` address.
     * @param _operatorData Extra information, attached by the operator (if any).
     */
    function _callPreTransferHooks(
        bytes32 _fromPartition,
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data,
        bytes memory _operatorData
    ) internal {
        address senderImplementation;
        senderImplementation = interfaceAddr(_from, AMP_TOKENS_SENDER);
        if (senderImplementation != address(0)) {
            IAmpTokensSender(senderImplementation).tokensToTransfer(
                msg.sig,
                _fromPartition,
                _operator,
                _from,
                _to,
                _value,
                _data,
                _operatorData
            );
        }

        // Used to ensure that hooks implemented by a collateral manager to validate
        // transfers from it's owned partitions are called
        bytes4 fromPartitionPrefix = PartitionUtils._getPartitionPrefix(_fromPartition);
        if (_isPartitionStrategy[fromPartitionPrefix]) {
            address fromPartitionValidatorImplementation;
            fromPartitionValidatorImplementation = interfaceAddr(
                address(this),
                PartitionUtils._getPartitionStrategyValidatorIName(fromPartitionPrefix)
            );
            if (fromPartitionValidatorImplementation != address(0)) {
                IAmpPartitionStrategyValidator(fromPartitionValidatorImplementation)
                    .tokensFromPartitionToValidate(
                    msg.sig,
                    _fromPartition,
                    _operator,
                    _from,
                    _to,
                    _value,
                    _data,
                    _operatorData
                );
            }
        }
    }

    /**
     * @dev Check for 'AmpTokensRecipient' hook on the recipient and call it.
     * @param _toPartition Name of the partition the tokens were transferred to.
     * @param _operator Address which triggered the balance increase (through
     * transfer or mint).
     * @param _from Token holder for a transfer (0x when mint).
     * @param _to Token recipient.
     * @param _value Number of tokens the recipient balance is increased by.
     * @param _data Extra information related to the token holder (`_from`).
     * @param _operatorData Extra information attached by the operator (if any).
     */
    function _callPostTransferHooks(
        bytes32 _toPartition,
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data,
        bytes memory _operatorData
    ) internal {
        bytes4 toPartitionPrefix = PartitionUtils._getPartitionPrefix(_toPartition);
        if (_isPartitionStrategy[toPartitionPrefix]) {
            address partitionManagerImplementation;
            partitionManagerImplementation = interfaceAddr(
                address(this),
                PartitionUtils._getPartitionStrategyValidatorIName(toPartitionPrefix)
            );
            if (partitionManagerImplementation != address(0)) {
                IAmpPartitionStrategyValidator(partitionManagerImplementation)
                    .tokensToPartitionToValidate(
                    msg.sig,
                    _toPartition,
                    _operator,
                    _from,
                    _to,
                    _value,
                    _data,
                    _operatorData
                );
            }
        } else {
            require(toPartitionPrefix == ZERO_PREFIX, EC_5D_PARTITION_RESERVED);
        }

        address recipientImplementation;
        recipientImplementation = interfaceAddr(_to, AMP_TOKENS_RECIPIENT);

        if (recipientImplementation != address(0)) {
            IAmpTokensRecipient(recipientImplementation).tokensReceived(
                msg.sig,
                _toPartition,
                _operator,
                _from,
                _to,
                _value,
                _data,
                _operatorData
            );
        }
    }

    /**************************************************************************/
    /******************************* Allowance ********************************/
    /**
     * @notice Approve the `_spender` address to spend the specified amount of
     * tokens in `_partition` on behalf of 'msg.sender'.
     * @param _partition Name of the partition.
     * @param _tokenHolder Owner of the tokens.
     * @param _spender The address which will spend the tokens.
     * @param _amount The amount of tokens to be tokens.
     */
    function _approveByPartition(
        bytes32 _partition,
        address _tokenHolder,
        address _spender,
        uint256 _amount
    ) internal {
        require(_tokenHolder != address(0), EC_56_INVALID_SENDER);
        require(_spender != address(0), EC_58_INVALID_OPERATOR);

        _allowedByPartition[_partition][_tokenHolder][_spender] = _amount;
        emit ApprovalByPartition(_partition, _tokenHolder, _spender, _amount);

        if (_partition == defaultPartition) {
            emit Approval(_tokenHolder, _spender, _amount);
        }
    }

    /**************************************************************************/
    /************************** Operator Information **************************/
    /**
     * @dev Indicate whether the operator address is an operator of the
     * tokenHolder address. An operator in this case is an operator across all
     * partitions of the `msg.sender` address.
     * @param _operator Address which may be an operator of '_tokenHolder'.
     * @param _tokenHolder Address of a token holder which may have the '_operator'
     * address as an operator.
     * @return 'true' if `_operator` is an operator of `_tokenHolder` and 'false'
     * otherwise.
     */
    function _isOperator(address _operator, address _tokenHolder)
        internal
        view
        returns (bool)
    {
        return (_operator == _tokenHolder ||
            _authorizedOperator[_tokenHolder][_operator]);
    }

    /**
     * @dev Indicate whether the operator address is an operator of the
     * tokenHolder address for the given partition.
     * @param _partition Name of the partition.
     * @param _operator Address which may be an operator of tokenHolder for the
     * given partition.
     * @param _tokenHolder Address of a token holder which may have the operator
     * address as an operator for the given partition.
     * @return 'true' if 'operator' is an operator of 'tokenHolder' for partition
     * `_partition` and 'false' otherwise.
     */
    function _isOperatorForPartition(
        bytes32 _partition,
        address _operator,
        address _tokenHolder
    ) internal view returns (bool) {
        return (_isOperator(_operator, _tokenHolder) ||
            _authorizedOperatorByPartition[_tokenHolder][_partition][_operator] ||
            _callPartitionStrategyOperatorHook(_partition, _operator, _tokenHolder));
    }

    /**
     * @notice Check if the `_partition` is within the scope of a strategy, and
     * call it's isOperatorForPartitionScope hook if so.
     * @dev This allows implicit granting of operatorByPartition permissions
     * based on the partition being used being of a strategy.
     * @param _partition The partition to check.
     * @param _operator The address to check if is an operator for `_tokenHolder`.
     * @param _tokenHolder The address to validate that `_operator` is an
     * operator for.
     */
    function _callPartitionStrategyOperatorHook(
        bytes32 _partition,
        address _operator,
        address _tokenHolder
    ) internal view returns (bool) {
        bytes4 prefix = PartitionUtils._getPartitionPrefix(_partition);

        if (!_isPartitionStrategy[prefix]) {
            return false;
        }

        address strategyValidatorImplementation;
        strategyValidatorImplementation = interfaceAddr(
            address(this),
            PartitionUtils._getPartitionStrategyValidatorIName(prefix)
        );
        if (strategyValidatorImplementation != address(0)) {
            return
                IAmpPartitionStrategyValidator(strategyValidatorImplementation)
                    .isOperatorForPartitionScope(_partition, _operator, _tokenHolder);
        }

        // Not a partition format that imbues special operator rules
        return false;
    }

    /**************************************************************************/
    /******************************** Minting *********************************/
    /**
     * @notice Perform the minting of tokens.
     * @dev The tokens will be minted on behalf of the `_to` address, and will be
     * minted to the address's default partition.
     * @param _operator Address which triggered the issuance.
     * @param _to Token recipient.
     * @param _value Number of tokens issued.
     */
    function _mint(
        address _operator,
        address _to,
        uint256 _value
    ) internal {
        require(_to != address(0), EC_57_INVALID_RECEIVER);

        _totalSupply = _totalSupply.add(_value);
        _addTokenToPartition(_to, defaultPartition, _value);
        _callPostTransferHooks(
            defaultPartition,
            _operator,
            address(0),
            _to,
            _value,
            "",
            ""
        );

        emit Minted(_operator, _to, _value, "");
        emit Transfer(address(0), _to, _value);
        emit TransferByPartition(bytes32(0), _operator, address(0), _to, _value, "", "");
    }
}