const networkConfig = {
  default: {
    name: "hardhat",
  },
  31337: {
    name: "localhost",
  },
  4: {
    name: "sepolia",
    PoolAddressesProviderAave: "0x0496275d34753A48320CA58103d5220d394FF77F",
  },
};

const developmentChains = ["hardhat", "localhost"];
const VERIFICATION_BLOCK_CONFIRMATIONS = 6;

module.exports = {
  networkConfig,
  developmentChains,
  VERIFICATION_BLOCK_CONFIRMATIONS,
};
