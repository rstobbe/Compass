%=========================================================
% 
%=========================================================

function [default] = ProcessKurtosis_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    LoadPath = [SCRPTPATHS.rootloc,'Image Processing\DWI\Underlying\Selectable Functions\DW Image Loading'];
    DispPath = [SCRPTPATHS.rootloc,'Image Processing\DWI\Underlying\Selectable Functions\DW Image Display'];
    CorrPath = [SCRPTPATHS.rootloc,'Image Processing\DWI\Underlying\Selectable Functions\DW Image Correction'];
    CalcPath = [SCRPTPATHS.rootloc,'Image Processing\DWI\Underlying\Selectable Functions\Kurtosis\Calculate Kurtosis'];
    addpath(genpath([SCRPTPATHS.rootloc,'zz Underlying\'])); 
elseif strcmp(filesep,'/')
end
addpath(genpath(LoadPath));
addpath(genpath(DispPath));
addpath(genpath(CalcPath));
addpath(genpath(CorrPath));

Loadfunc = 'LoadDWDicom_v1a';
Dispfunc = 'DispAverages_v1a';
Corrfunc = 'CorrAbsNoise_v1a';
Calcfunc = 'Calc2KurtIM_v3a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadDWIMs';
default{m,1}.entrystr = Loadfunc;
default{m,1}.searchpath = LoadPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DispDWIMs';
default{m,1}.entrystr = Dispfunc;
default{m,1}.searchpath = DispPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CorrDWIMs';
default{m,1}.entrystr = Corrfunc;
default{m,1}.searchpath = CorrPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CalcKurtosis';
default{m,1}.entrystr = Calcfunc;
default{m,1}.searchpath = CalcPath;