%=========================================================
% 
%=========================================================

function [default] = GenericPostProcessing_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Generic\'];
    procpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Masking\'];
    disppath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Display\'];    
elseif strcmp(filesep,'/')
end
loadfunc = 'Im1LoadGeneric_v1c';
procfunc = 'CubeMask_v1b';
dispfunc = 'SubPlotMontage_v1b';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImLoadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Procfunc';
default{m,1}.entrystr = procfunc;
default{m,1}.searchpath = procpath;
default{m,1}.path = [procpath,procfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Dispfunc';
default{m,1}.entrystr = dispfunc;
default{m,1}.searchpath = disppath;
default{m,1}.path = [disppath,dispfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Proc';
default{m,1}.labelstr = 'Proc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

