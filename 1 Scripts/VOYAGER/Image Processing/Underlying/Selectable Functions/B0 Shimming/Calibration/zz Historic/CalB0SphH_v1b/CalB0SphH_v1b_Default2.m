%=========================================================
% 
%=========================================================

function [default] = CalB0SphH_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    fitpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Fit Spherical Harmonics\'];
elseif strcmp(filesep,'/')
end
fitfunc = 'Fit3DegSphHarm4z_v1a';
addpath([fitpath,fitfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Threshold';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispWid (Hz)';
default{m,1}.entrystr = '50';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Visuals';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Fitfunc';
default{m,1}.entrystr = fitfunc;
default{m,1}.searchpath = fitpath;
default{m,1}.path = [fitpath,fitfunc];

