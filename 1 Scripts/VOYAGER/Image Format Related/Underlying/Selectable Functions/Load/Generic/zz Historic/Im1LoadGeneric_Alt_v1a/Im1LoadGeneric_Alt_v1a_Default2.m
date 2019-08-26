%=========================================================
% 
%=========================================================

function [default] = Im1LoadGeneric_Alt_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Image_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectGeneralFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'SelectGeneralFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Permute (abc)';
default{m,1}.entrystr = '123';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Flip1';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Flip2';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Flip3';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'No','Yes'};