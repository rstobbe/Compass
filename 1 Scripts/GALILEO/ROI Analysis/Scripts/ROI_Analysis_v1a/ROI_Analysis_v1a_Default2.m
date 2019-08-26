%=========================================================
% 
%=========================================================

function [default] = ROI_Analysis_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    anlzpath = [SCRPTPATHS.galileoloc,'ROI Analysis\Underlying\Selectable Functions\ROI Noise_Smearing\'];
elseif strcmp(filesep,'/')
end
anlzfunc = 'CalcIRSNEI_ManipVOI_v1b';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Analysis_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Analysisfunc';
default{m,1}.entrystr = anlzfunc;
default{m,1}.searchpath = anlzpath;
default{m,1}.path = [anlzpath,anlzfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Calc';
default{m,1}.labelstr = 'Calc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Calc';