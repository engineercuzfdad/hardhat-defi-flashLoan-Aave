const { network } = require("hardhat");
const {
  networkConfig,
  developmentChains,
  VERIFICATION_BLOCK_CONFIRMATIONS,
} = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async ({ deployments, getNamedAccounts }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const waitBlockConfirmations = developmentChains.includes(network.name)
    ? 1
    : VERIFICATION_BLOCK_CONFIRMATIONS;
  log("----------------------------------------------------");

  //const args = networkConfig[4].PoolAddressesProviderAave;
  const poolAddressesProviderAave =
    "0x0496275d34753A48320CA58103d5220d394FF77F";
  const args = [poolAddressesProviderAave];

  const flashLoanDeployment = await deploy("FlashLoan", {
    from: deployer,
    logs: true,
    args: args,
    waitConfirmations: waitBlockConfirmations,
  });

  // Verify the deployment
  if (
    !developmentChains.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    log("Verifying...");
    await verify(flashLoanDeployment.address, args);
  }
  log("----------------------------------------------------");
};

module.exports.tags = ["all", "flashloan"];
