import { ethers } from 'hardhat';
import { expect } from "chai";

async function main() {
    const Competition = await ethers.getContractFactory("Competition");
    const competition = await Competition.deploy("Red", "RED", BigInt("10000000000000000000000000000000000000000"), "Blue", "BLUE", BigInt("10000000000000000000000000000000000000000"));
    const competitionAddress = await competition.getAddress();
    console.log(`Contract address ${competitionAddress}`);
    const tokenA = await ethers.getContractAt("ERC20", await competition.tokenA());
    const tokenB = await ethers.getContractAt("ERC20", await competition.tokenB());
    const platformToken = await ethers.getContractAt("ERC20", await competition.platformToken());
    // await tokenA.approve(competitionAddress, 10);
    // await competition.transfer(await tokenA.getAddress(), 10, true);
    const points = await competition.viewPoints();
    await competition.start();

    const time = await competition.viewEndTime();
    console.log(time);
    // await platformToken.approve(competitionAddress, 10);
    // await competition.transfer(await tokenA.getAddress(), 10, false);
    console.log(points);
    // await competition.transfer(await tokenA.getAddress(), 10, true);
    // expect(await tokenA.totalSupply()).to.equal(1000000);
    // expect(await tokenB.totalSupply()).to.equal(1000000);
    // expect(await tokenA.balanceOf(await competition.getAddress())).to.equal(1000000);
    // expect(await tokenB.balanceOf(await competition.getAddress())).to.equal(1000000);
    console.log("All passed!");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});