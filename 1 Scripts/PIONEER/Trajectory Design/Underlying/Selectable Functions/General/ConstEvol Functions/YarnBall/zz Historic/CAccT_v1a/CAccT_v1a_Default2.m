%=========================================================
% 
%=========================================================

function [default] = CAccT_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    accprofpath = [SCRPTPATHS.rootloc,'Trajectory Design\LR\Underlying\Selectable Functions\AccProf Functions'];
elseif strcmp(filesep,'/')
end

addpath(genpath(accprofpath));
accproffunc = 'CAccP_Uniform_v1a';
caccmeth = 'CAccM_v1a';

m = 1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'ConstAccMethod';
default{m,1}.entrystr = caccmeth;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstAccProf';
default{m,1}.entrystr = accproffunc;
default{m,1}.searchpath = accprofpath;

