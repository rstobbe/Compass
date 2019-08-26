%====================================================
%
%====================================================

function [default] = ExportImage_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Generic\'];
    manippath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Manipulate\'];
    exportpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Export\Standard\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'Im1LoadGeneric_v1c';
manipfunc = 'FullManipulate_v1a';
exportfunc = 'ExportImageAnlz_v1d';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Export_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadImagefunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ManipImagefunc';
default{m,1}.entrystr = manipfunc;
default{m,1}.searchpath = manippath;
default{m,1}.path = [manippath,manipfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ExportImagefunc';
default{m,1}.entrystr = exportfunc;
default{m,1}.searchpath = exportpath;
default{m,1}.path = [exportpath,exportfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SaveOption';
default{m,1}.entrystr = 'AutoFileOnly';
default{m,1}.options = {'Manual','AutoFull','AutoFileOnly','AutoGlobalOnly','None'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'LoadOutputGlobal';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Export';
default{m,1}.labelstr = 'Export';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

