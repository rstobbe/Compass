%=========================================================
% 
%=========================================================

function [default] = Study_Analysis_v1a_Default2(SCRPTPATHS)

SCRPTPATHS.apolloloc = 'D:\1 Scripts\APOLLO\Set 1.0\';
if strcmp(filesep,'\')
    anlzpath = [SCRPTPATHS.apolloloc,'Analyze Study\Underlying\Selectable Functions\ROI Analysis Error\'];
elseif strcmp(filesep,'/')
end
anlzfunc = 'RoiErrorPlot_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Analysis_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Study_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadScriptFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Analysisfunc';
default{m,1}.entrystr = anlzfunc;
default{m,1}.searchpath = anlzpath;
default{m,1}.path = [anlzpath,anlzfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Anlz';
default{m,1}.labelstr = 'Anlz';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';