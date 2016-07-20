# DMS Bandit Missions
DMS Bandit Missions Pack

>>	Templates and original stock missions created by Defent and eraser1<br>
>>	easy/mod/difficult/hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
>>	Missions spreadsheet with their setups here: https://drive.google.com/open?id=1wy-j9QHf1ZTl_iK01raut-xZ8p9ulDHf506vkFgyieU
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Updated 16 July 2016 > V 3.0 - Release
1. Changed the random call from 
_difficulty = _PossibleDifficulty call BIS_fnc_selectRandom;
to
_difficulty = selectRandom _PossibleDifficulty;
2. Changed difficulty match from
if (_difficulty isEqualTo "easy") then {
to
switch (_difficulty) do
{	case "easy":	{
*** #1 and #2 is to match the way DMS has released some of the missions from this pack and to make updates easier in the future ***
3. Consolidated start messages into 1 line as I saw how eraser1 had changed scripts for including into DMS and realised I missed a trick as this reduces the amount of lines in the script.
4. Consolidated some of the item content choices as I had listed the same lines in all outcomes but really just needed to list once to reduce size of script (again thanks eraser1).
5. Adjusted some spacing, line breaks and tabs as it reduces the overall size and was not really needed.
6. Changed terrorists to bandits to keep in the Bandit Missions theme, and corrected some English grammar.
7. Added % chance of persistent vehicle to more missions so it can be adjusted by user.
8. Changed CoinToss possibilities a % number.
9. Removed several mistakes in brackets - I don't know how I missed them or why it worked anyway but I fixed them.
10. Balanced some AI and loot as they were a little under or over what you would expect from the missions.
11. Added a graded %chance for persistent vehicles on some missions - check the spreadsheet for details.
12. ***NEW MISSION*** - nedbandit1, no crate but loot and cash spawn inside the vehicle. This has almost every function I have been working on inside including 2 groups of custom AI - kind of like the old Mayor missions of the Arma 2 days where one Ai is dressed differently from the rest. It is a working concept and "how to" mission so not only works as a mission but can help people design and release more of their own.
