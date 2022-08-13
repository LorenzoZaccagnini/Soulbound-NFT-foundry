// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NFTToken.sol";

contract NFTTokenTest is Test {
    using stdStorage for StdStorage;
    NFTToken private nft;

    function setUp() public {
        nft = new NFTToken();
    }

    function testDeployment() public {
        assertEq(nft.name(), "Soulbound");
        assertEq(nft.symbol(), "SBNFT");
    }

    function testOwner() public {
        assertEq(nft.owner(), address(this));
    }

    function testOwnerTransfer() public {
        assertEq(nft.owner(), address(this));
        nft.transferOwnership(0x1111111111111111111111111111111111111111);
        assertEq(nft.owner(), 0x1111111111111111111111111111111111111111);
    }

    function testOwnerTransferFail() public {
        assertEq(nft.owner(), address(this));
        vm.expectRevert("Ownable: caller is not the owner");
        vm.startPrank(address(2));
        nft.transferOwnership(0x1111111111111111111111111111111111111111);
        vm.stopPrank();
    }

    function testMintFailByNotOwnerUser() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.startPrank(address(2));
        nft.safeMint(address(2));
        vm.stopPrank();
    }

    function testMint() public {
        nft.safeMint(address(1));
        assertEq(nft.balanceOf(address(1)), 1);
        assertEq(nft.ownerOf(0), address(1));
    }

    function testTransferFail() public {
        nft.safeMint(address(2));
        vm.expectRevert("Soulbound nft can't be transferred");
        vm.startPrank(address(2));
        nft.safeTransferFrom(address(2), address(3), 0);
        vm.stopPrank();
    }
}
