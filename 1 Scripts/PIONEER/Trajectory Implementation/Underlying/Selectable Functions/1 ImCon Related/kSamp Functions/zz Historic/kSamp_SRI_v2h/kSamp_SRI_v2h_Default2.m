%=========================================================
% 
%=========================================================

function [default] = kSamp_SRI_v2h_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    srifuncpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\kSamp SubFunctions\SRI Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(srifuncpath));

srifunc = 'TPI_SRIlinear_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SRI_Func';
default{m,1}.entrystr = srifunc;
default{m,1}.searchpath = srifuncpath;





