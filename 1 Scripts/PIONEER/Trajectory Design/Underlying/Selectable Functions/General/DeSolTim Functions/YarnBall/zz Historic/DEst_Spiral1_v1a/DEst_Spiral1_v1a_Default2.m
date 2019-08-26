%=========================================================
% 
%=========================================================

function [default] = DEst_Spiral1_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    radevpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\DEsoltime SubFunctions\RadSolEv Functions\'];
elseif strcmp(filesep,'/')
end
radevfunc = 'RSESpiral_design_v1a';
addpath([radevpath,radevfunc]);

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Fineness';
default{m,1}.entrystr = '1';
default{m,1}.options = {'1','2','3','4','5','6','7','8'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Search';
default{m,1}.entrystr = 'weak';
default{m,1}.options = {'weak','strong'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RadSolEvfunc';
default{m,1}.entrystr = radevfunc;
default{m,1}.searchpath = radevpath;
default{m,1}.path = [radevpath,radevfunc];