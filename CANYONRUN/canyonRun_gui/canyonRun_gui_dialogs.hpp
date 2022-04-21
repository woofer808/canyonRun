#define canyonRun_id_guiDialogMain 909
#define canyonRun_id_guiDebugCheckbox 910
#define canyonRun_id_selectPilot 911
#define canyonRun_id_selectAircraft 912


// Text size
#define TEXT_SIZE_LARGE (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)
#define TEXT_SIZE_MEDIUM (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)
#define TEXT_SIZE_SMALL (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.6)

class canyonRun_gui_dialogMain {
	idd = canyonRun_id_guiDialogMain;
	movingenable = false;
	onload = "[] execVM 'CANYONRUN\canyonRun_gui\canyonRun_gui_dialogControl.sqf'";
	onUnload = "";
	
	class controls {
	

		////////////////// Background //////////////////
		
		class canyonRun_gui_backgroundMain: canyonRun_RscPicture {
			idc = -1;
			text = "#(argb,8,8,3)color(0,0,0,1)";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.5 * safezoneH;
		};
		
		
		////////////////// start button //////////////////
		class canyonRun_gui_buttonStartFlight: canyonRun_RscButton {
			idc = -1;
			text = "start flight";
			x = 0.30 * safezoneW + safezoneX;
			y = 0.69 * safezoneH + safezoneY;
			tooltip = "";
			action = "closeDialog 0;[canyonRun_var_pilot,canyonRun_var_aircraft] spawn canyonRun_fnc_startFlight";
		};
		
		
		////////////////// pilot selection //////////////////
		class canyonRun_gui_comboSelectPilot: canyonRun_RscCombo {
			idc = canyonRun_id_selectPilot;
			text = "set pilot";
			x = 0.37 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			tooltip = "Select next pilot";
			onLBSelChanged = "[] call canyonRun_fnc_setPilot";
		};


		////////////////// aircraft selection //////////////////
		class canyonRun_gui_comboSelectAircraft: canyonRun_RscCombo {
			idc = canyonRun_id_selectAircraft;
			text = "set aircraft";
			x = 0.37 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			tooltip = "Select aircraft";
			onLBSelChanged = "[] call canyonRun_fnc_setAircraft";
		};
		
		
		
		
		////////////////// Debug mode //////////////////
		
		class canyonRun_gui_guiDebugCheckbox: canyonRun_RscCheckbox {
			idc = canyonRun_id_guiDebugCheckbox;
			text = "Debug mode";
			x = 0.42 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			tooltip = "Turn debug mode on or off";
			onCheckedChanged = "[] call canyonRun_fnc_guiDebug";
			
		};
		
		class canyonRun_gui_textDebug: canyonRun_RscText {
			idc = -1;
			text = "debug mode";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.65 * safezoneH + safezoneY;
			w = 0.045 * safezoneW;
			h = 0.02 * safezoneH;
			tooltip = "Turn debug mode on or off";
		};
		
		
		
		
		
		
		
		////////////////// script info //////////////////
		
		class canyonRun_gui_scriptInfo: canyonRun_RscText {
			idc = canyonRun_id_guiActorDisplay;
			text = "canyon run by woofer";
			x = 0.575 * safezoneW + safezoneX;
			y = 0.7 * safezoneH + safezoneY;
			w = 0.065 * safezoneW;
			h = 0.02 * safezoneH;
			SizeEx = TEXT_SIZE_SMALL;
			tooltip = "";
		};
		

	}; // Close controls
	
}; // Close dialog main