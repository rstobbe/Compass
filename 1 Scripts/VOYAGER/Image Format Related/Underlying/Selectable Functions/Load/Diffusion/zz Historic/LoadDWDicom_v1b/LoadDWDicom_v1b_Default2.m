%=========================================================
% 
%=========================================================

function [default] = LoadDWDicom_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'FirstDicomFile';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectDicomCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'SelectDicomDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'bvalues';
default{m,1}.entrystr = '0 500 1000 1500 2000 2500';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tot_b0images';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tot_Slices';
default{m,1}.entrystr = '6';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tot_Directions';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Averages';
default{m,1}.entrystr = '4';


