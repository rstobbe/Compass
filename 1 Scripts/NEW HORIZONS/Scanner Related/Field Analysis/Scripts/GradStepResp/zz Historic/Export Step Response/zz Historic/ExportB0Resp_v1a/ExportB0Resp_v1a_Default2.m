%=========================================================
% 
%=========================================================

function [default] = ExportB0Resp_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'B0Resp_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0start (ms)';
default{m,1}.entrystr = '11.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0stop (ms)';
default{m,1}.entrystr = '35';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'slpmid (ms)';
default{m,1}.entrystr = '10.8925';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GradDes_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Export_B0';
default{m,1}.labelstr = 'Export_B0';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';