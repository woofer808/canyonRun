/*

The idea here is that each run should put an onEachFrame marker down on the map
showing the current location of the aircraft for each client to follow along
on the map

In the future this function could also be used to store a replay of the run
in case someone wants to replay it.

The simplest way might be to just execute this function on each client at
the start of each run using the global variable of the pilot or pass something here

KK had something on drawing icons showing vehicles on the map.
http://killzonekid.com/arma-scripting-tutorials-how-to-draw-icon-on-map/

From the BIKI:
icon
String: Default Value = "unknown_object.paa"
This value us used by the map editor to show the building or vehicle when editing. It is not normally visible during game play. (but can be)
The icon can be any jpg, paa, or pac file. paa is default. Note that Elite cannot handle jpegs.
icon = "\AnyAddon\AnyPAA(.paa)";

Waffle SS.
Icon will always remain the same width and height, if you want an icon scaled to the map, use:
(sizeInMeters * 0.15) * 10^(abs log (ctrlMapScale _ctrl))

Maybe even skip the iconography and go for a drawn triangle?
https://community.bistudio.com/wiki/drawPolygon

*/

/* By Killzone-Kid
http://killzonekid.com/arma-scripting-tutorials-how-to-draw-icon-on-map/'

car = "C_Offroad_01_F" createVehicle position player;
((findDisplay 12) displayCtrl 51) mapCenterOnCamera true;
_eh = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", '
    (_this select 0) drawIcon [
        getText (configFile/"CfgVehicles"/typeOf car/"Icon"),
        [1,1,1,1],
        visiblePosition car,
        0.5/ctrlMapScale (_this select 0),
        0.5/ctrlMapScale (_this select 0),
        direction car
    ]; 
'];

//_mapControl ctrlRemoveEventHandler ["Draw", _drawIconEH];
*/



