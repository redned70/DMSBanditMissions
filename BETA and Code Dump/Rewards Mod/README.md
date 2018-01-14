# BETA DMS Reward Mod Bandit Missions
<br>
<b> Original thread http://www.exilemod.com/topic/12072-update32-dms-bandit-missions-either-new-or-reworked/?page=1 </b><br>
>>	Templates and original stock missions created by Defent and eraser1<br>
>>	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk<br>
>>	<a href="http://www.exilemod.com/topic/24883-exile-player-rewards/">http://www.exilemod.com/topic/24883-exile-player-rewards/</a><br>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

<b>Beta selection of Reward Mod missions</b><br>
Copy bandits_rewards.sqf into your DMS.PBO\missions\bandit <br>
Add ["bandits_rewards",3], to the main config.sqf in the DMS_BanditMissionTypes section<br>
Copy fn_PlayerRewardsMod.sqf into your DMS.PBO\scripts <br>
Add "class PlayerRewardsMod 			{};" to "class compiles" list in DMS.PBO config.cpp<br>
We should be able now to call 	[[_cash,_score,_crate_loot_values,_PrizeVehicles],DMS_fn_PlayerRewardsMod], inside missions<br>
Save/repack/Upload to server <br>
When the mission crashes horribly please let me know what it says :) <br>

<b>Not recommended for live servers</b><br>
Please report any BETA mission issues or comments (especially if they are working) so i can add them to the live package<br>
