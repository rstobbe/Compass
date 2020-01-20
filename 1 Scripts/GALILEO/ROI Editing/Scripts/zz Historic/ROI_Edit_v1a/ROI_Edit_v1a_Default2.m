%=========================================================
% 
%=========================================================

function [default] = ROI_Edit_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.galileoloc,'ROI Editing\Underlying\Selectable Functions\ROI Loading\'];
    editpath = [SCRPTPATHS.galileoloc,'ROI Editing\Underlying\Selectable Functions\ROI Edit\'];
    outpath = [SCRPTPATHS.galileoloc,'ROI Editing\Underlying\Selectable Functions\ROI Edit Output\'];
elseif strcmp(filesep,'/')
end
editfunc = 'TransFuncExpand_v1a';
loadfunc = 'LoadRoisFromFile_v1a';
outfunc = 'SaveAsNewRoi_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'RoiEdit_Name';
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
default{m,1}.labelstr = 'RoiEditfunc';
default{m,1}.entrystr = editfunc;
default{m,1}.searchpath = editpath;
default{m,1}.path = [editpath,editfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RoiOutputfunc';
default{m,1}.entrystr = outfunc;
default{m,1}.searchpath = outpath;
default{m,1}.path = [outpath,outfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Calc';
default{m,1}.labelstr = 'Proc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';