// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Interface for the ERC20 token
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract P256Rewards {
    // Address of the precompiled secp256r1 contract (0x8001)
    address constant SECP256R1_PRECOMPILE = address(0x8001);

    // ERC20 token used for sending rewards
    IERC20 public token; // ERC20 token contract address

    // Constructor to set the token contract address
    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress); // Initialize the token interface
    }

    /**
     * @dev Verifies a secp256r1 signature for the IoT device data.
     * @param timestamp The timestamp of the IoT message.
     * @param latitude The latitude in the message.
     * @param longitude The longitude in the message.
     * @param temperature The temperature in the message.
     * @param r The r part of the signature (32 bytes).
     * @param s The s part of the signature (32 bytes).
     * @param pubKey The public key of the IoT device that signed the message (encoded as an (x, y) point).
     * @return bool indicating whether the signature is valid.
     */
    function verifyIoTData(
        string memory timestamp,
        string memory latitude,
        string memory longitude,
        string memory temperature,
        bytes32 r,
        bytes32 s,
        bytes memory pubKey
    ) public view returns (bool) {
        // Step 1: Hash the IoT data
        bytes32 messageHash = keccak256(abi.encodePacked(timestamp, latitude, longitude, temperature));

        // Step 2: Encode the input as expected by the precompiled contract
        // Input format: (messageHash, r, s, uncompressed pubKey)
        bytes memory input = abi.encodePacked(messageHash, r, s, pubKey);

        // Step 3: Call the precompiled contract at 0x8001 for secp256r1 signature verification
        (bool success, bytes memory result) = SECP256R1_PRECOMPILE.staticcall(input);

        // Step 4: Check if the signature verification was successful (result[0] == 1)
        if (success && result.length == 1 && uint8(result[0]) == 1) {
            return true;
        }
        return false;
    }

    function submitIoTData(
        string memory timestamp,
        string memory latitude,
        string memory longitude,
        string memory temperature,
        bytes32 r,
        bytes32 s,
        bytes memory pubKey
    ) public {
        // Verify the signature
        require(verifyIoTData(timestamp, latitude, longitude, temperature, r, s, pubKey), "Invalid P256 Signature");

        // Define the token reward amount (e.g., 100 tokens)
        uint256 rewardAmount = 100 * 10 ** 18; 

        /*
         * Validate the actual message data, depending on the Dapp requirements
        */

        // If everything ok, send token rewards to the caller
        require(token.transfer(msg.sender, rewardAmount), "Token transfer failed");
    }
}
