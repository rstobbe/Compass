%=========================================================
% 
%=========================================================

function [default] = DEst_Flower_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    radevpath = [SCRPTPATHS.rootloc,'Trajectory Design\LR\Underlying\Selectable Functions\RadEv Functions'];
elseif strcmp(filesep,'/')
end

addpath(genpath(radevpath));
radevfunc = 'RE_a200b110c30';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RadEv';
default{m,1}.entrystr = radevfunc;
default{m,1}.searchpath = radevpath;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Fineness';
default{m,1}.entrystr = '1';
default{m,1}.options = {'1','2','3','4','5','6','7','8'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'DeSolTim Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};