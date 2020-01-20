%=========================================================
% 
%=========================================================

function [default] = ROI_Create_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    createpath = [SCRPTPATHS.galileoloc,'ROI Editing\Underlying\Selectable Functions\ROI Edit\'];
    outpath = [SCRPTPATHS.galileoloc,'ROI Editing\Underlying\Selectable Functions\ROI Edit Output\'];
elseif strcmp(filesep,'/')
end
createfunc = 'CreateRoiFromImage_v1b';
outfunc = 'SaveAsNewRoi_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Roi_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RoiCreatefunc';
default{m,1}.entrystr = createfunc;
default{m,1}.searchpath = createpath;
default{m,1}.path = [createpath,createfunc];

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
default{m,1}.buttonname = 'Create';