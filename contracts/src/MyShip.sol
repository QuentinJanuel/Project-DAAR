// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./Ship.sol";
import "hardhat/console.sol";

contract MyShip is Ship {
    uint private x;
    uint private y;
    uint private width;
    uint private height;
    uint private nextX = 0;
    uint private nextY = 0;
    uint[] private placesToTryX;
    uint[] private placesToTryY;
    function update(uint _x, uint _y) public override {
        if (x == _x && y == _y) {
            // I have been placed successfully
        } else {
            // I have been moved because someone was there
            // Remember to fire were the other player is
            placesToTryX.push(x);
            placesToTryY.push(y);
            // Remember my new place
            x = _x;
            y = _y;
        }
        console.log("Confirmed ship %s at %d, %d", address(this), x, y);
    }
    function fire() public override returns (uint, uint) {
        // If there are places to try, try them
        if (placesToTryX.length > 0) {
            uint _x = placesToTryX[placesToTryX.length - 1];
            uint _y = placesToTryY[placesToTryY.length - 1];
            placesToTryX.pop();
            placesToTryY.pop();
            console.log("Ship %s fires at known place %d, %d", address(this), _x, _y);
            return (_x, _y);
        }
        // Otherwise, try to fire at every places incrementally
        uint __x = nextX;
        uint __y = nextY;
        nextX += 1;
        if (nextX >= width) {
            nextX = 0;
            nextY += 1;
            if (nextY >= height) {
                nextY = 0;
            }
        }
        console.log("Ship %s fires at place %d, %d", address(this), __x, __y);
        return (__x, __y);
    }
    function place(uint _width, uint _height) public override returns (uint, uint) {
        width = _width;
        height = _height;
        x = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % width;
        y = uint(keccak256(abi.encodePacked(block.timestamp + 314, block.difficulty))) % height;
        console.log("Attempt to place ship %s at %d, %d", address(this), x, y);
        return (x, y);
    }
}
