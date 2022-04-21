detach canyonRun_var_camera;
canyonRun_var_camera camSetTarget indiCam_var_spawn;
canyonRun_var_camera setPos (canyonRun_var_spawnFlag modelToWorld [20,20,10]);

canyonRun_var_camera camCommit 0;


[] call canyonRun_fnc_enemyStop;
