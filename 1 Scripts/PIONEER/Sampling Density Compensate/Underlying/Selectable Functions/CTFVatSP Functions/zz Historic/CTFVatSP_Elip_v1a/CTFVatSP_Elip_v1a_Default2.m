%=========================================================
% 
%=========================================================

function [default] = CTFVatSP_Elip_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\zz Common\']));
    CTFPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\CTFVatSP SubFunctions\CTF Functions\'];
elseif strcmp(filesep,'/')
end

addpath(genpath(CTFPath));
CTFfunc = 'CTF_Elip_v1a';

m = 1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'CTFfunc';
default{m,1}.entrystr = CTFfunc;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'CTFtest';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'CTFvis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};
