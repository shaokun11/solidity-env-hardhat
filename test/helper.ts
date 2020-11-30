//@ts-check
import { ethers } from "hardhat";
import { Wallet, Signer, Contract, ContractFactory } from "ethers";
export async function depolyContract(name: string, ...params: string[]) {
  console.log("depolyContract", name, params);
  let factory: ContractFactory = await ethers.getContractFactory(name);
  let ins = await factory.deploy(...params);
  return await ins.deployed();
}
export const getSigners: () => Promise<Signer[]> = ethers.getSigners;
