%=========================================================
% 
%=========================================================

function [default] = kSamp_TPISRI_v3a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    srifuncpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\kSamp SubFunctions\GSRI Functions\'];
elseif strcmp(filesep,'/')
end
srifunc = 'GSRI_TPIstandard_v1e';
addpath([srifuncpath,srifunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GSRIfunc';
default{m,1}.entrystr = srifunc;
default{m,1}.searchpath = srifuncpath;
default{m,1}.path = [srifuncpath,srifunc];



