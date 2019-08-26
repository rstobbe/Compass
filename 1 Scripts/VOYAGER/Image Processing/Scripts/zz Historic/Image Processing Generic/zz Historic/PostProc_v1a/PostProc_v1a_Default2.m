%=========================================================
% 
%=========================================================

function [default] = SeqSpecProc_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    procpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Sequence Specific\'];
elseif strcmp(filesep,'/')
end
procfunc = 'PostProc_fsemsuf_v1a';
addpath([procpath,procfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Load';
default{m,1}.entrystr = 'Local';
default{m,1}.options = {'Local','File'};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Image_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'PostProcfunc';
default{m,1}.entrystr = procfunc;
default{m,1}.searchpath = procpath;
default{m,1}.path = [procpath,procfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Proc';
default{m,1}.labelstr = 'Proc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';