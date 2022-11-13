//  测试 ERC20
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";


describe("Token contract Test", function () {

    async function deployLoadFixture() {

        // 如果有多个相同名字的合约，需要使用全路径名
        const Token = await ethers.getContractFactory("contracts/ERC20.sol:ERC20");
        const [owner, addr1, addr2] = await ethers.getSigners();


        // token 名称
        const name = "ETK";
        const symbol = "ETK";
        const token = await Token.deploy(name, symbol);
        await token.deployed();

        return { Token, token, owner, addr1, addr2 };
    }
    describe("Deployment", function () {
        it("Should assign the total supply of tokens to the owner", async function () {
            const { token, owner } = await loadFixture(deployLoadFixture);
            const ownerBalance = await token.balanceOf(owner.address);
            expect(await token.totalSupply()).to.equal(ownerBalance);
        });
    });

    describe("Transfer", function () {
        it("Should transfer tokens between accounts", async function () {
            const { token, owner, addr1, addr2 } = await loadFixture(deployLoadFixture);

            // mint
            await expect(
                token._mint(owner.address, 2000)
            ).to.changeTokenBalances(token, [owner], [2000]);


            // Transfer 500 tokens from owner to addr1
            await expect(
                token.transfer(addr1.address, 500)
            ).to.changeTokenBalances(token, [owner, addr1], [-500, 500]);
            //  balance2 = await token.balanceOf(addr1.address);

            // Transfer 1000 tokens from addr1 to addr2
            // 我的合约会抛出自定义错误  transferAmountExceedsBalance
            await expect(
                token.connect(addr1).transfer(addr2.address, 1000)
            ).to.changeTokenBalances(token, [addr1, addr2], [-1000, 1000]).to.be.revertedWithCustomError(
                token, "transferAmountExceedsBalance"
            );
        });

    });

    describe("OwnerShip", function () {
        it("OwnerShip transfer to new Owner", async function () {
            const { token, owner, addr1, addr2 } = await loadFixture(deployLoadFixture);
            const newOwner = addr2;


            // transfer
            await token.transferOwnerShip(newOwner.address);

            // check owner ship
            expect(await token.owner()).to.hexEqual(newOwner.address);
            await expect(
                // 想换回原来的 所有者
                token.connect(owner).transferOwnerShip(owner.address)
            ).to.be.revertedWithCustomError(
                token, "onlyOwnerError"
            );
        });

    });
});