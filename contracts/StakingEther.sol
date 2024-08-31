// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherStaking {
    uint256 public rewardRate = 10;

    struct StakingInfo {
        uint256 amount;
        uint256 startTime;
        uint256 endTime;
        uint256 rewards;
    }

    mapping(address => StakingInfo) public stakingInfo;

    event Staked(
        address indexed user,
        uint256 amount,
        uint256 startTime,
        uint256 endTime
    );
    event Withdraw(address indexed user, uint256 amount, uint256 rewards);

    function stakeEther(uint256 _duration) external payable {
        require(msg.sender != address(0), "Zero address detected");
        require(msg.value > 0, "Amount must be greater than 0");

        uint256 endTime = block.timestamp + _duration;
        stakingInfo[msg.sender] = StakingInfo(
            msg.value,
            block.timestamp,
            endTime,
            0
        );
        emit Staked(msg.sender, msg.value, block.timestamp, endTime);
    }

    function calculateRewards(address _user) public view returns (uint256) {
        StakingInfo storage info = stakingInfo[_user];
        uint256 duration = info.endTime - info.startTime;
        uint256 rewards = (info.amount * rewardRate * duration) / 100;
        return rewards;
    }

    function withdrawEther() external payable {
        require(msg.sender != address(0), "Zero address detected");

        StakingInfo storage info = stakingInfo[msg.sender];
        require(
            block.timestamp >= info.endTime,
            "Staking period has not ended"
        );

        uint256 rewards = calculateRewards(msg.sender);

        payable(msg.sender).transfer(rewards * info.amount);
        emit Withdraw(msg.sender, info.amount, rewards);
    }
}
