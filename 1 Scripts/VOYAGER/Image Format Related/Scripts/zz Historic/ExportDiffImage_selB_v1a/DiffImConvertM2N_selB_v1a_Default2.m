%=========================================================
% 
%=========================================================

function [default] = DiffImConvertM2N_v1a_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\')
    exportpath = [SCRPTPATHS.Vrootloc,'Image Export\Underlying\Selectable Functions\'];
elseif strcmp(filesep,'/')
end
exportfunc = 'ExportImageNII_v1a';
addpath([exportpath,exportpath]);

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Image_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Exportfunc';
default{m,1}.entrystr = exportfunc;
default{m,1}.searchpath = exportpath;
default{m,1}.path = [exportpath,exportfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'ConvertIm';
default{m,1}.labelstr = 'Convert';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';