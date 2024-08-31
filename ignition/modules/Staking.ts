import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const StakingEtherModule = buildModule("StakingEtherModule", (m) => {
  const staking = m.contract("EtherStaking");
  return { staking };
});

export default StakingEtherModule;

// deployed : https://sepolia-blockscout.lisk.com//address/0xf88C46ED69ED6417699ba741a534Dd7792b78D0d#code
