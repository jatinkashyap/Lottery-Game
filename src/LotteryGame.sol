// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title LotteryGame
 * @dev Lottry Game application
 */
contract LotteryGame {
    // Address of the manager who manages the game
    address public manager;
    // Address of the participants playing the game
    address payable[] public participants;

    /** 
     * @dev Constructor function
     */
    constructor() {
        manager = msg.sender;
    }

    /**
     * @dev Transfer ether to contract from participant
     */ 
    receive() external payable {
        require(msg.value == 0.5 ether);
        participants.push(payable(msg.sender));
    }

    /**
     * @dev Gives current balance of the contract
     * @return the current ETH balance
     */ 
    function getBalance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    /**
     * @dev Generates random number
     * @return the random value
     */ 
    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    /**
     * @dev Perform of logic of selecting winner
     */ 
    function selectWinner() public {
        require(msg.sender == manager && participants.length>=3);
        (participants[random() % participants.length]).transfer(getBalance());
        participants = new address payable[](0);
    }
}
