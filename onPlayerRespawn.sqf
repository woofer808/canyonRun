

removeAllWeapons player;
removeVest player;
removeAllAssignedItems player;
clearAllItemsFromBackpack player;
removeBackpack player;
player setUnitLoadout(player getVariable["Saved_Loadout",[]]);




player setPos ((position canyonRun_var_spawnFlag) vectorAdd [-2,0,0]);