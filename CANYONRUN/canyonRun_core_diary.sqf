/*
 * Author: woofer
 * Contains all the diary entries with information and script execution for canyonRun
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call indicam_core_fnc_diary
 *
 * Public: No
 */

// Info here: https://community.bistudio.com/wiki/createDiaryRecord
// This is how BI does it in MP missions https://forums.bistudio.com/forums/topic/163884-briefing-and-creatediaryrecord/?do=findComment&comment=2565014

_index = player createDiarySubject ["canyonRun","canyonRun"];


funcProcessDiaryLink = {
    processDiaryLink createDiaryLink ["canyonRun", _this, ""];
};


canyonRun_diaryControls = player createDiaryRecord ["canyonRun", ["Controls", 
    "
	<br/>
	Start the game by using the addaction on the flag pole at spawn.<br/>
	<br/>
	Keypresses for when entered into the observation screen.<br/>
	<br/>
	Keypress F1 - Show indiCam controls<br/>
	<br/>
	"
]];

canyonRun_diaryHelp = player createDiaryRecord ["canyonRun", ["Game description", 
    "
	<br/>
	canyonRun is made to play as a party game where everybody get to watch each friend's run together through an in-game provided follow camera.<br/>
	<br/>
	Fly through the terrain while loosing fuel as far through the maze as possible without crashing, going out of bounds or being shot down.<br/>
	<br/>
	The more throttle you use, the more fuel you loose each second.<br/>
	<br/>
	Each run is scored based on how far you get.<br/>
	<br/>
	Pilots are sorted into a queue based on lobby slots and join in progress players.<br/>
	<br/>
	love<br/>
	woofer<br/>
	"
]];


canyonRun_intel = player createDiaryRecord ["canyonRun", ["Mission", 
    "
	<br/>
	You are tasked with destroying the weapons manufacturing facility of Takistan where the enemy is developing and producing it's new laser AAA system.<br/>
	<br/>
	We have identified a possible route through the canyon running up to it where the lasers cannot depress enough to get at you.<br/>
	DO NOT rise above 200 meters above ground or go out of bounds as you risk instant death.<br/>
	<br/>
	But beware. The canyon is lined with traditional AAA and MANPADS. You will have to use the terrain to your advantage in order to mask yourself from enemy ground fire.<br/>
	<br/>
	Choose your aircraft and be confident in that you will be in the competent hands of your maintenence crews.<br/>
	<br/>
	Good luck!<br/>
	<br/>
	"
]];
