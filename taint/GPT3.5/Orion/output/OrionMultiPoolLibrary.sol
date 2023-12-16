pragma solidity 0.7.4;
pragma experimental ABIEncoderV2;
uint256 constant MAX_COINS = 8
uint256 constant FEE_DENOMINATOR = 10**10
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}
interface IERC20Simple {
    function decimals() external view virtual returns (uint8);
}
interface IOrionPoolV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}
interface ICurveRegistry {
    function find_pool_for_coins(address _from, address _to, uint256 i) view external returns(address);
    function get_coin_indices(address _pool, address _from, address _to) view external returns(int128, int128, bool);
    function get_balances(address _pool) view external returns (uint256[MAX_COINS] memory);
    function get_rates(address _pool) view external returns (uint256[MAX_COINS] memory);
    function get_A(address _pool) view external returns (uint256);
    function get_fees(address _pool) view external returns (uint256, uint256);
    function get_coins(address _pool) view external returns (address[MAX_COINS] memory);
}
interface IOrionPoolV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}
interface IPoolFunctionality {

    struct SwapData {
        uint112     amount_spend;
        uint112     amount_receive;
        address     orionpool_router;
        bool        is_exact_spend;
        bool        supportingFee;
        bool        isInContractTrade;
        bool        isSentETHEnough;
        bool        isFromWallet;
        address     asset_spend;
        address[]   path;
    }

    struct InternalSwapData {
        address user;
        uint256 amountIn;
        uint256 amountOut;
        address asset_spend;
        address[] path;
        bool isExactIn;
        address to;
        address curFactory;
        FactoryType curFactoryType;
        bool supportingFee;
    }

    enum FactoryType {
        UNSUPPORTED,
        UNISWAPLIKE,
        CURVE
    }

    function doSwapThroughOrionPool(
        address user,
        address to,
        IPoolFunctionality.SwapData calldata swapData
    ) external returns (uint amountOut, uint amountIn);

    function getWETH() external view returns (address);

    function addLiquidityFromExchange(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function isFactory(address a) external view returns (bool);
}
library OrionMultiPoolLibrary {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'OMPL: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'OMPL: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
        pair = IOrionPoolV2Factory(factory).getPair(tokenA, tokenB);
    }

    function pairForCurve(address factory, address tokenA, address tokenB) internal view returns (address pool) {
        pool = ICurveRegistry(factory).find_pool_for_coins(tokenA, tokenB, 0);
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IOrionPoolV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    function get_D(uint256[] memory xp, uint256 amp) internal pure returns(uint256) {
        uint N_COINS = xp.length;
        uint256 S = 0;
        for(uint i; i < N_COINS; ++i)
            S += xp[i];
        if(S == 0)
            return 0;

        uint256 Dprev = 0;
        uint256 D = S;
        uint256 Ann = amp * N_COINS;
        for(uint _i; _i < 255; ++_i) {
            uint256 D_P = D;
            for(uint j; j < N_COINS; ++j) {
                D_P = D_P * D / (xp[j] * N_COINS);  // If division by 0, this will be borked: only withdrawal will work. And that is good
            }
            Dprev = D;
            D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P);
            // Equality with the precision of 1
            if (D > Dprev) {
                if (D - Dprev <= 1)
                    break;
            } else  {
                if (Dprev - D <= 1)
                    break;
            }
        }
        return D;
    }

    function get_y(int128 i, int128 j, uint256 x, uint256[] memory xp_, uint256 amp) pure internal returns(uint256)
    {
        // x in the input is converted to the same price/precision
        uint N_COINS = xp_.length;
        require(i != j, "same coin");
        require(j >= 0, "j below zero");
        require(uint128(j) < N_COINS, "j above N_COINS");

        require(i >= 0, "i below zero");
        require(uint128(i) < N_COINS, "i above N_COINS");

        uint256 D = get_D(xp_, amp);
        uint256 c = D;
        uint256 S_ = 0;
        uint256 Ann = amp * N_COINS;

        uint256 _x = 0;
        for(uint _i; _i < N_COINS; ++_i) {
            if(_i == uint128(i))
                _x = x;
            else if(_i != uint128(j))
                _x = xp_[_i];
            else
                continue;
            S_ += _x;
            c = c * D / (_x * N_COINS);
        }
        c = c * D / (Ann * N_COINS);
        uint256 b = S_ + D / Ann;  // - D
        uint256 y_prev = 0;
        uint256 y = D;
        for(uint _i; _i < 255; ++_i) {
            y_prev = y;
            y = (y*y + c) / (2 * y + b - D);
            // Equality with the precision of 1
            if(y > y_prev) {
                if (y - y_prev <= 1)
                    break;
            } else {
                if(y_prev - y <= 1)
                    break;
            }
        }
        return y;
    }

    function get_xp(address factory, address pool) internal view returns(uint256[] memory xp) {
        xp = new uint256[](MAX_COINS);

        address[MAX_COINS] memory coins = ICurveRegistry(factory).get_coins(pool);
        uint256[MAX_COINS] memory balances = ICurveRegistry(factory).get_balances(pool);

        uint i = 0;
        for (; i < balances.length; ++i) {
            if (balances[i] == 0)
                break;
            xp[i] = baseUnitToCurveDecimal(coins[i], balances[i]);
        }
        assembly { mstore(xp, sub(mload(xp), sub(MAX_COINS, i))) } // remove trail zeros from array
    }

    function getAmountOutCurve(address factory, address from, address to, uint256 amount) view internal returns(uint256) {
        address pool = pairForCurve(factory, from, to);
        (int128 i, int128 j,) = ICurveRegistry(factory).get_coin_indices(pool, from, to);
        uint256[] memory xp = get_xp(factory, pool);

        uint256 y;
        {
            uint256 A = ICurveRegistry(factory).get_A(pool);
            uint256 x = xp[uint(i)] + baseUnitToCurveDecimal(from, amount);
            y = get_y(i, j, x, xp, A);
        }

        (uint256 fee,) = ICurveRegistry(factory).get_fees(pool);
        uint256 dy = xp[uint(j)] - y - 1;
        uint256 dy_fee = dy * fee / FEE_DENOMINATOR;
        dy = curveDecimalToBaseUnit(to, dy - dy_fee);

        return dy;
    }

    function getAmountInCurve(address factory, address from, address to, uint256 amount) view internal returns(uint256) {
        address pool = pairForCurve(factory, from, to);
        (int128 i, int128 j,) = ICurveRegistry(factory).get_coin_indices(pool, from, to);
        uint256[] memory xp = get_xp(factory, pool);

        uint256 x;
        {
            (uint256 fee,) = ICurveRegistry(factory).get_fees(pool);
            uint256 A = ICurveRegistry(factory).get_A(pool);
            uint256 y = xp[uint256(j)] - baseUnitToCurveDecimal(to, (amount + 1)) * FEE_DENOMINATOR / (FEE_DENOMINATOR - fee);
            x = get_y(j, i, y, xp, A);
        }

        uint256 dx = curveDecimalToBaseUnit(from, x - xp[uint256(i)]);
        return dx;
    }

    function getAmountOutUniversal(
        address factory,
        IPoolFunctionality.FactoryType factoryType,
        address from,
        address to,
        uint256 amountIn
    ) view internal returns(uint256 amountOut) {
        if (factoryType == IPoolFunctionality.FactoryType.UNISWAPLIKE) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, from, to);
            amountOut = getAmountOutUv2(amountIn, reserveIn, reserveOut);
        } else if (factoryType == IPoolFunctionality.FactoryType.CURVE) {
            amountOut = getAmountOutCurve(factory, from, to, amountIn);
        } else if (factoryType == IPoolFunctionality.FactoryType.UNSUPPORTED) {
            revert("OMPL: FACTORY_UNSUPPORTED");
        }
    }

    function getAmountInUniversal(
        address factory,
        IPoolFunctionality.FactoryType factoryType,
        address from,
        address to,
        uint256 amountOut
    ) view internal returns(uint256 amountIn) {
        if (factoryType == IPoolFunctionality.FactoryType.UNISWAPLIKE) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, from, to);
            amountIn = getAmountInUv2(amountOut, reserveIn, reserveOut);
        } else if (factoryType == IPoolFunctionality.FactoryType.CURVE) {
            amountIn = getAmountInCurve(factory, from, to, amountOut);
        } else if (factoryType == IPoolFunctionality.FactoryType.UNSUPPORTED) {
            revert("OMPL: FACTORY_UNSUPPORTED");
        }
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(
        address factory,
        IPoolFunctionality.FactoryType factoryType,
        uint amountIn,
        address[] memory path
    ) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'OMPL: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;

        for (uint i = 1; i < path.length; ++i) {
            amounts[i] = getAmountOutUniversal(factory, factoryType, path[i - 1], path[i], amounts[i - 1]);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(
        address factory,
        IPoolFunctionality.FactoryType factoryType,
        uint amountOut,
        address[] memory path
    ) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'OMPL: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; --i) {
            amounts[i - 1] = getAmountInUniversal(factory, factoryType, path[i - 1], path[i], amounts[i]);
        }
    }

    /**
        @notice convert asset amount from decimals (10^18) to its base unit
    */
    function curveDecimalToBaseUnit(address assetAddress, uint amount) internal view returns(uint256 baseValue){
        uint256 result;

        if(assetAddress == address(0)){
            result = amount; // 18 decimals
        } else {
            uint decimals = IERC20Simple(assetAddress).decimals();

            result = amount.mul(10**decimals).div(10**18);
        }

        baseValue = result;
    }

    /**
        @notice convert asset amount from its base unit to 18 decimals (10^18)
    */
    function baseUnitToCurveDecimal(address assetAddress, uint amount) internal view returns(uint256 decimalValue){
        uint256 result;

        if(assetAddress == address(0)){
            result = amount;
        } else {
            uint decimals = IERC20Simple(assetAddress).decimals();

            result = amount.mul(10**18).div(10**decimals);
        }
        decimalValue = result;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOutUv2(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'OMPL: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'OMPL: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountInUv2(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'OMPL: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'OMPL: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quoteUv2(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'OMPL: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'OMPL: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

}
