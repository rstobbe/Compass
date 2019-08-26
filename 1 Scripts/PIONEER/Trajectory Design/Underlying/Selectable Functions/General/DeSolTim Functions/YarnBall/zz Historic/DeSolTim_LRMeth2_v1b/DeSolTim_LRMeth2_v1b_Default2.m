%=========================================================
% 
%=========================================================

function [default] = DeSolTim_LRMeth2_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    radevpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\DEsoltime SubFunctions\RadSolEv Functions\'];
elseif strcmp(filesep,'/')
end
radevfunc = 'RadSolEv_LRMeth2_v2a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RadSolEvfunc';
default{m,1}.entrystr = radevfunc;
default{m,1}.searchpath = radevpath;
default{m,1}.path = [radevpath,radevfunc];