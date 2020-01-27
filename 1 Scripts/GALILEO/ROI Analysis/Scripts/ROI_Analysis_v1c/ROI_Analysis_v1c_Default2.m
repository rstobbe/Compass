%=========================================================
% 
%=========================================================

function [default] = ROI_Analysis_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    anlzpath = [SCRPTPATHS.galileoloc,'ROI Analysis\Underlying\Selectable Functions\ROI Noise_Smearing\'];
    loadpath = [SCRPTPATHS.galileoloc,'ROI Editing\Underlying\Selectable Functions\ROI Loading\'];
    imloadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Generic\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'LoadRoisFromFile_v1a';
imloadfunc = 'Im1LoadGeneric_v1c';
anlzfunc = 'FitDistTool_v1a';

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
default{m,1}.labelstr = 'RoiLoadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImageLoadfunc';
default{m,1}.entrystr = imloadfunc;
default{m,1}.searchpath = imloadpath;
default{m,1}.path = [imloadpath,imloadfunc];

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