%====================================================
%
%====================================================

function [default] = GComp_FromFile_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    atrpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Comp Transient Response\'];
elseif strcmp(filesep,'/')
end
atrfunc = 'CompExpTransResp_v1a';
addpath([atrpath,atrfunc]);

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Comp_File';
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
default{m,1}.labelstr = 'CTRfunc';
default{m,1}.entrystr = atrfunc;
default{m,1}.searchpath = atrpath;
default{m,1}.path = [atrpath,atrfunc];
