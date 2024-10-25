
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const NFTModule = buildModule("NFTModule", (m) => {

  const nftModule = m.contract("NFTMarket", );

  return { nftModule };
});

export default NFTModule;
