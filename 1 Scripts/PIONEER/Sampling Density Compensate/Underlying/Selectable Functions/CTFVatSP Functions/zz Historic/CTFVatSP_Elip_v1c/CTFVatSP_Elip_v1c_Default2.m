%=========================================================
% 
%=========================================================

function [default] = CTFVatSP_Elip_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\zz Common\']));
    CTFPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\CTFVatSP SubFunctions\CTF Functions\'];
elseif strcmp(filesep,'/')
end

addpath(genpath(CTFPath));
CTFfunc = 'CTF_Elip_v1c';

m = 1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'CTFfunc';
default{m,1}.entrystr = CTFfunc;
