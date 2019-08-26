%=========================================================
% 
%=========================================================

function [default] = AccCalc_ArrROISphereDiam_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    roipath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Trajectory Analysis\ROI Functions\Auto ROIs\'];
elseif strcmp(filesep,'/')
end
roifunc = 'AutoROI_SphereDiam_v1a';
addpath([roipath,roifunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Diam (x:x:x mm)';
default{m,1}.entrystr = '1:1:10';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ROIfunc';
default{m,1}.entrystr = roifunc;
default{m,1}.searchpath = roipath;
default{m,1}.path = [roipath,roifunc];

