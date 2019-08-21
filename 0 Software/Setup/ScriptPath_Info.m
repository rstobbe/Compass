function [LOCS] = ScriptPath_Info(Drive)
                            
LOCS.scrptshareloc = [Drive,'1 Scripts\zs Shared\'];
LOCS.scriptloc = [Drive,'1 Scripts\'];
LOCS.defloc = [Drive,'2 Defaults\'];
LOCS.defrootloc = [Drive,'2 Defaults\'];
LOCS.pioneerloc = [Drive,'1 Scripts\PIONEER\'];
LOCS.newhorizonsloc = [Drive,'1 Scripts\NEW HORIZONS\'];
LOCS.voyagerloc = [Drive,'1 Scripts\VOYAGER\'];
LOCS.galileoloc = [Drive,'1 Scripts\GALILEO\'];
LOCS.mercuryloc = [Drive,'1 Scripts\MERCURY\'];
LOCS.apolloloc = [Drive,'1 Scripts\APOLLO\'];
LOCS.vikingloc = [Drive,'1 Scripts\VIKING\'];

LOCS.invfiltloc = [Drive,'4 OtherFiles\Gridding\Inverse Filters\'];
LOCS.imkernloc = [Drive,'4 OtherFiles\Gridding\Kernels\'];
LOCS.sysresploc = [Drive,'4 OtherFiles\Scanner\GradSysResp'];