%=========================================================
% 
%=========================================================

function [default] = MonoExp_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Rgrs_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Data_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SelectEddy';
default{m,1}.entrystr = 'Geddy';
default{m,1}.options = {'B0eddy','Geddy'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DataStart (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DataStop (ms)';
default{m,1}.entrystr = '1e6';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TimePastG (ms)';
default{m,1}.entrystr = 'matchstart';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tc Estimate (ms)';
default{m,1}.entrystr = '2000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Offset (units)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Figure Number';
default{m,1}.entrystr = '2000';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Regression';
default{m,1}.labelstr = 'Regression';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';