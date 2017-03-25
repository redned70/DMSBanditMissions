# BETA DMS Bandit Missions
<br>
<b> Original thread http://www.exilemod.com/topic/12072-update32-dms-bandit-missions-either-new-or-reworked/?page=1 </b><br>
>>	Templates and original stock missions created by Defent and eraser1<br>
>>	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk<br>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

<b>Beta selection of missions</b><br>
All missions in BETA are pre-testing or in developing states <br>
Code may not be complete to a finished shine <br>
Anything that isnt in a working state will be commented <br>

<b>Not recommended for live servers</b><br>
Please report any BETA mission issues or comments (especially if they are working) so i can add them to the live package<br>
<br><br>



Installing.<br>
1. 	Copy contents of this folder>/missions/bandit/ into a3_dms.pbo /missions/bandit/ , you can remove old missions.<br>
2. 	Copy contents of this folder>/objects/ into a3_dms.pbo /objects/ , you do not have to replace any already in there (files dont go in the static folder)<br>
3. 	Extract main config.sqf<br>
4.	Find 	DMS_BanditMissionTypes = [<br>
5.	Add the following line into the list, remembering that every line except the last should end with a comma<br>
											["nedbtrader_mission",3],<br>
									
6.	Repack config.sqf and folders into PBO<br>
7. 	Put a3_dms.pbo back into /@ExileServer/addons/ on server and start.<br>

No BE or InfiSTAR additions apart from what you installed to run DMS. This will not run without DMS. <br>