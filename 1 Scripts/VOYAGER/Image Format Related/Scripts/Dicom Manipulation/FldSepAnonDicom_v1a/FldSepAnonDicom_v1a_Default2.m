%====================================================
%
%====================================================

function [default] = FldSepAnonDicom_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    anonpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Dicom\'];
elseif strcmp(filesep,'/')
end
anonfunc = 'AnonDicomHeader_v1b';
addpath([anonpath,anonfunc]);

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Directory';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectDirCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'SelectDirDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Anonfunc';
default{m,1}.entrystr = anonfunc;
default{m,1}.searchpath = anonpath;
default{m,1}.path = [anonpath,anonfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Dicom';
default{m,1}.labelstr = 'FldSepAnon';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


