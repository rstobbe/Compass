%=========================================================
% 
%=========================================================

function [default] = RoiDistFit_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    fitdistpath = [SCRPTPATHS.galileoloc,'ROI Analysis\Underlying\Selectable Functions\ROI Stats\'];
elseif strcmp(filesep,'/')
end
fitdistfunc = 'FitDistTool_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Analysis_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FitDistfunc';
default{m,1}.entrystr = fitdistfunc;
default{m,1}.searchpath = fitdistpath;
default{m,1}.path = [fitdistpath,fitdistfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Calc';
default{m,1}.labelstr = 'Calc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Calc';