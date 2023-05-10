// Sources flattened with hardhat v2.12.7 https://hardhat.org

// File @openzeppelin/contracts/utils/Context.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File contracts/interfaces/ICurrencyManager.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface ICurrencyManager {
    struct Currency {
        bytes32 id;
        uint256 decimals;
        bool isAbstractCurrency;
        address ethereumAddress;
    }

    struct Pair {
        bytes32 id;
        bytes32 quoteCurrencyId;
        bytes32 baseCurrencyId;
    }

    event SubmittedCurrency(Currency currency);
    event UpdatedCurrency(Currency currency);
    event SubmittedPair(Pair pair);
}


// File contracts/CurrencyManager.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CurrencyManager is ICurrencyManager, Ownable {
    mapping(bytes32 => Currency) public currencies;
    mapping(bytes32 => Pair) public pairs;
    mapping(bytes32 => mapping(bytes32 => bytes32)) public pairIdStorage;

    function addCurrency(Currency calldata currency) public onlyOwner {
        require(
            currencies[currency.id].id == bytes32(""),
            "Currency already set"
        );
        currencies[currency.id] = currency;
    }

    function updateCurrency(Currency calldata currency) public onlyOwner {
        require(currencies[currency.id].id != bytes32(""), "Currency not set");
        currencies[currency.id] = currency;
    }

    function addPair(Pair calldata pair) external onlyOwner {
        Pair memory oldPair = pairs[pair.id];
        require(
            oldPair.id == 0,
            "Oracle: Pair with this key already registered"
        );
        pairs[pair.id] = pair;
        pairIdStorage[pair.quoteCurrencyId][pair.baseCurrencyId] = pair.id;

        emit SubmittedPair(pair);
    }
}


// File @openzeppelin/contracts/utils/math/Math.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1);

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator,
        Rounding rounding
    ) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10**64) {
                value /= 10**64;
                result += 64;
            }
            if (value >= 10**32) {
                value /= 10**32;
                result += 32;
            }
            if (value >= 10**16) {
                value /= 10**16;
                result += 16;
            }
            if (value >= 10**8) {
                value /= 10**8;
                result += 8;
            }
            if (value >= 10**4) {
                value /= 10**4;
                result += 4;
            }
            if (value >= 10**2) {
                value /= 10**2;
                result += 2;
            }
            if (value >= 10**1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
        }
    }
}


// File contracts/EntryUtils.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract EntryUtils {
    function swap(
        uint256[] memory array,
        uint256 i,
        uint256 j
    ) internal pure {
        (array[i], array[j]) = (array[j], array[i]);
    }

    function sort(
        uint256[] memory array,
        uint256 begin,
        uint256 end
    ) internal pure {
        if (begin < end) {
            uint256 j = begin;
            uint256 pivot = array[j];
            for (uint256 i = begin + 1; i < end; ++i) {
                if (array[i] < pivot) {
                    swap(array, i, ++j);
                }
            }
            swap(array, begin, j);
            sort(array, begin, j);
            sort(array, j + 1, end);
        }
    }

    function median(uint256[] memory array, uint256 length)
        internal
        pure
        returns (uint256)
    {
        sort(array, 0, length);
        return
            length % 2 == 0
                ? Math.average(array[length / 2 - 1], array[length / 2])
                : array[length / 2];
    }
}


// File contracts/interfaces/IOracle.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IOracle {
    enum AggregationMode {
        MEDIAN
    }
    struct BaseEntry {
        uint256 timestamp;
        bytes32 source;
        bytes32 publisher;
    }

    struct SpotEntry {
        BaseEntry base;
        bytes32 pairId;
        uint256 price;
        uint256 volume;
    }

    struct SpotEntryStorage {
        uint128 timestamp;
        bytes16 pairId;
        uint128 price;
        uint128 volume;
    }

    struct Checkpoint {
        uint64 timestamp;
        uint128 value;
        AggregationMode aggregationMode;
        uint8 numSourcesAggregated;
    }

    event UpdatedPublisherRegistryAddress(
        address oldPublisherRegistryAddress,
        address newPublisherRegistryAddress
    );
    event SubmittedSpotEntry(SpotEntry newEntry);
    event CheckpointSpotEntry(Checkpoint cp);
}


// File contracts/interfaces/IPublisherRegistry.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IPublisherRegistry {
    event RegisteredPublisher(bytes32 publisher, address publisherAddress);
    event UpdatedPublisherAddress(
        bytes32 publisher,
        address oldPublisherAddress,
        address newPublisherAddress
    );

    function addPublisher(bytes32 publisher, address publisherAddress) external;

    function canPublishSource(bytes32 publisher, bytes32 source)
        external
        view
        returns (bool);

    function publisherAddresses(bytes32 publisher)
        external
        view
        returns (address);
}


// File contracts/Oracle2.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";




contract Oracle is Initializable, CurrencyManager, EntryUtils, IOracle {
    IPublisherRegistry public publisherRegistry;

    mapping(bytes32 => bytes32[]) public oracleSourcesStorage;
    mapping(bytes32 => mapping(bytes32 => SpotEntryStorage))
        public spotEntryStorage;
    mapping(bytes32 => Checkpoint[]) public checkpoints;
    mapping(bytes32 => uint256) public checkpointIndex;
    uint256 sourcesThreshold = 1;

    uint256 constant BACKWARD_TIMESTAMP_BUFFER = 3600;
    uint256 constant FORWARD_TIMESTAMP_BUFFER = 3600;

    // constructor() {
    //     _disableInitializers();
    // }

    function constructors(
        address _publisherRegistry,
        Currency[] memory _currencies,
        Pair[] memory _pairs
    ) public {
        publisherRegistry = IPublisherRegistry(_publisherRegistry);
        for (uint256 i = 0; i < _currencies.length; i++) {
            currencies[_currencies[i].id] = _currencies[i];
        }
        for (uint256 i = 0; i < _pairs.length; i++) {
            pairs[_pairs[i].id] = _pairs[i];
        }
    }

    function setSourcesThreshold(uint256 threshold) external onlyOwner {
        sourcesThreshold = threshold;
    }

    function updatePublisherRegistryAddress(
        IPublisherRegistry newPublisherRegistryAddress
    ) external onlyOwner {
        publisherRegistry = newPublisherRegistryAddress;
    }

    function publishSpotEntry(SpotEntry calldata spotEntry) public {
        _publishSpotEntry(spotEntry);
    }

    function setCheckpoint(
        bytes32 pairId,
        AggregationMode aggregationMode
    ) public {
        _setCheckpoint(pairId, aggregationMode);
    }

    function setCheckpoints(
        bytes32[] memory pairIds,
        AggregationMode aggregationMode
    ) public {
        for (uint256 i = 0; i < pairIds.length; i++) {
            _setCheckpoint(pairIds[i], aggregationMode);
        }
    }

    function _setCheckpoint(
        bytes32 pairId,
        AggregationMode aggregationMode
    ) private {
        bytes32[] memory sources = oracleSourcesStorage[pairId];
        (
            uint256 value,
            ,
            uint256 lastUpdatedTimestamp,
            uint256 numSourcesAggregated
        ) = getSpot(pairId, aggregationMode, sources);

        require(
            sourcesThreshold <= numSourcesAggregated,
            "Does not meet threshold for aggreagated sources"
        );

        if (checkpointIndex[pairId] > 0) {
            Checkpoint memory currentCheckpoint = checkpoints[pairId][
                checkpointIndex[pairId] - 1
            ];
            require(
                currentCheckpoint.timestamp < lastUpdatedTimestamp,
                "stale"
            );
        }
        Checkpoint memory newCheckpoint = Checkpoint(
            uint64(lastUpdatedTimestamp),
            uint128(value),
            aggregationMode,
            uint8(numSourcesAggregated)
        );

        checkpointIndex[pairId]++;
        checkpoints[pairId].push(newCheckpoint);

        emit CheckpointSpotEntry(newCheckpoint);
    }

    function publishSpotEntries(SpotEntry[] calldata spotEntries) public {
        for (uint256 i = 0; i < spotEntries.length; i++) {
            _publishSpotEntry(spotEntries[i]);
        }
    }

    function _publishSpotEntry(SpotEntry calldata spotEntry) internal {
        _validateSenderForSource(spotEntry.base, msg.sender);
        SpotEntryStorage memory _latest = spotEntryStorage[spotEntry.pairId][
            spotEntry.base.source
        ];
        _validateTimestamp(_latest, spotEntry);
        spotEntryStorage[spotEntry.pairId][
            spotEntry.base.source
        ] = SpotEntryStorage(
            uint128(spotEntry.base.timestamp),
            bytes16(spotEntry.pairId),
            uint128(spotEntry.price),
            uint128(spotEntry.volume)
        );

        emit SubmittedSpotEntry(spotEntry);
    }

    function getSpot(
        bytes32 pairId,
        AggregationMode,
        bytes32[] memory sources
    )
        public
        view
        returns (
            uint256 price,
            uint256 decimals,
            uint256 lastUpdatedTimestamp,
            uint256 numSourcesAggregated
        )
    {
        (
            SpotEntryStorage[] memory entries,
            uint256 _lastUpdatedTimestamp
        ) = getSpotEntries(pairId, sources);
        if (entries.length == 0) {
            return (0, 0, 0, 0);
        }
        uint256 _price = _aggregateSpotEntries(entries);
        uint256 _decimals = _getSpotDecimals(pairId);
        return (_price, _decimals, _lastUpdatedTimestamp, entries.length);
    }

    function getSpotEntries(
        bytes32 pairId,
        bytes32[] memory sources
    )
        public
        view
        returns (
            SpotEntryStorage[] memory entries,
            uint256 lastUpdatedTimestamp
        )
    {
        (
            SpotEntryStorage[] memory unfilteredEntries,
            uint256 _lastUpdatedTimestamp
        ) = _getSpotEntriesArray(pairId, sources);
        entries = _filterSpotEntriesByTimestamp(
            unfilteredEntries,
            _lastUpdatedTimestamp
        );
        return (entries, _lastUpdatedTimestamp);
    }

    function _getSpotEntriesArray(
        bytes32 pairId,
        bytes32[] memory sources
    )
        internal
        view
        returns (SpotEntryStorage[] memory, uint256 latestTimestamp)
    {
        SpotEntryStorage[] memory entries = new SpotEntryStorage[](
            sources.length
        );
        for (uint256 i = 0; i < sources.length; i++) {
            SpotEntryStorage memory entry = spotEntryStorage[pairId][
                sources[i]
            ];
            latestTimestamp = Math.max(entry.timestamp, latestTimestamp);
            entries[i] = entry;
        }
        return (entries, latestTimestamp);
    }

    function _getSpotDecimals(bytes32 pairId) internal view returns (uint256) {
        bytes32 baseCurrencyid = pairs[pairId].baseCurrencyId;
        return currencies[baseCurrencyid].decimals;
    }

    function _getLatestSpotEntryTimestamp(
        bytes32 pairId,
        bytes32[] memory sources
    ) internal view returns (uint256 latestTimestamp) {
        for (uint256 i = 0; i < sources.length; i++) {
            SpotEntryStorage memory entry = spotEntryStorage[pairId][
                sources[i]
            ];
            latestTimestamp = Math.max(entry.timestamp, latestTimestamp);
        }
    }

    function _aggregateSpotEntries(
        SpotEntryStorage[] memory entries
    ) internal pure returns (uint256) {
        uint256[] memory values = new uint256[](entries.length);
        uint256 length = 0;
        for (uint256 i = 0; i < entries.length; i++) {
            if (entries[i].price != 0) {
                values[i] = entries[i].price;
                length += 1;
            }
        }
        return median(values, length);
    }

    function _filterSpotEntriesByTimestamp(
        SpotEntryStorage[] memory entries,
        uint256 lastUpdatedTimestamp
    ) internal pure returns (SpotEntryStorage[] memory) {
        uint256 resultCount = 0;
        for (uint256 i = 0; i < entries.length; i++) {
            SpotEntryStorage memory entry = entries[i];
            if (
                entry.timestamp + BACKWARD_TIMESTAMP_BUFFER <
                lastUpdatedTimestamp
            ) {
                continue;
            }
            resultCount++;
        }

        SpotEntryStorage[] memory spotEntries = new SpotEntryStorage[](
            resultCount
        );
        uint256 curIndex = 0;
        for (uint256 i = 0; i < entries.length; i++) {
            SpotEntryStorage memory entry = entries[i];
            if (
                entry.timestamp + BACKWARD_TIMESTAMP_BUFFER <
                lastUpdatedTimestamp
            ) {
                continue;
            }
            spotEntries[curIndex++] = entry;
        }

        return spotEntries;
    }

    function _validateSenderForSource(
        BaseEntry calldata baseEntry,
        address sender
    ) internal view {
        require(
            publisherRegistry.publisherAddresses(baseEntry.publisher) == sender,
            "Invalid Sender for Publisher"
        );
        require(
            publisherRegistry.canPublishSource(
                baseEntry.publisher,
                baseEntry.source
            ),
            "Can not publish Source"
        );
    }

    function _validateTimestamp(
        SpotEntryStorage memory oldEntry,
        SpotEntry memory newEntry
    ) internal {
        require(
            oldEntry.timestamp < newEntry.base.timestamp,
            "Oracle: Existing entry is more recent"
        );
        require(
            block.timestamp - BACKWARD_TIMESTAMP_BUFFER <=
                newEntry.base.timestamp,
            "Oracle: New entry timestamp is too far in the past"
        );
        require(
            block.timestamp + FORWARD_TIMESTAMP_BUFFER >=
                newEntry.base.timestamp,
            "Oracle: New entry timestamp is too far in the future"
        );

        if (oldEntry.timestamp == 0) {
            // Source did not exist yet, so add to our list
            oracleSourcesStorage[newEntry.pairId].push(newEntry.base.source);
        }
    }

    function _splitBytes32(
        bytes32 source
    ) internal pure returns (bytes16, bytes16) {
        bytes16[2] memory y = [bytes16(0), 0];
        assembly {
            mstore(y, source)
            mstore(add(y, 16), source)
        }
        return (y[0], y[1]);
    }
}
