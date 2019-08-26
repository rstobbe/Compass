%=========================================================
% 
%=========================================================

function [default] = Calc2KurtIM_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    corrpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Abs Noise Correction\'];
elseif strcmp(filesep,'/')
end
corrfunc = 'CorrAbsNoise_v1c';
addpath([corrpath,corrfunc]);

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Constrain';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinVal_b0';
default{m,1}.entrystr = '60';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Corrfunc';
default{m,1}.entrystr = corrfunc;
default{m,1}.searchpath = corrpath;
default{m,1}.path = [corrpath,corrfunc];




