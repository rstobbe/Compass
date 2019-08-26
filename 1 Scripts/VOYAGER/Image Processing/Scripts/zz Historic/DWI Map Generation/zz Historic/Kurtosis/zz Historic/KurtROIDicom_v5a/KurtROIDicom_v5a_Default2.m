%=========================================================
% 
%=========================================================

function [default] = KurtROIDicom_v5a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    LoadPath = [SCRPTPATHS.rootloc,'Image Processing\Underlying\Selectable Functions\Kurtosis\Load Kurtosis Images\'];
    DispPath = [SCRPTPATHS.rootloc,'Image Processing\Underlying\Selectable Functions\Kurtosis\Display Kurtosis Images\'];
    CalcPath = [SCRPTPATHS.rootloc,'Image Processing\Underlying\Selectable Functions\Kurtosis\Calculate Kurtosis\'];
    addpath(genpath([SCRPTPATHS.rootloc,'zz Underlying\'])); 
elseif strcmp(filesep,'/')
end
addpath(genpath(LoadPath));
addpath(genpath(DispPath));
addpath(genpath(CalcPath));

Calcfunc = 'CalcKurtROI_v1a';
Loadfunc = 'LoadSSKurtDicom_v1a';
Dispfunc = 'DispSSKurtAves_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadKurtIMs';
default{m,1}.entrystr = Loadfunc;
default{m,1}.searchpath = LoadPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DispKurtIMs';
default{m,1}.entrystr = Dispfunc;
default{m,1}.searchpath = DispPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CalcKurtosis';
default{m,1}.entrystr = Calcfunc;
default{m,1}.searchpath = CalcPath;