%=========================================================
% 
%=========================================================

function [default] = CalcROIPrec_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    calcprecpath = [SCRPTPATHS.galileoloc,'Image Analysis\Underlying\Selectable Functions\ROI Precision_Accuracy\'];
elseif strcmp(filesep,'/')
end
calcprecfunc = 'CalcPrec_v1a';
addpath([calcprecpath,calcprecfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Analysis_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CalcPrecfunc';
default{m,1}.entrystr = calcprecfunc;
default{m,1}.searchpath = calcprecpath;
default{m,1}.path = [calcprecpath,calcprecfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Calc';
default{m,1}.labelstr = 'Calc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Calc';