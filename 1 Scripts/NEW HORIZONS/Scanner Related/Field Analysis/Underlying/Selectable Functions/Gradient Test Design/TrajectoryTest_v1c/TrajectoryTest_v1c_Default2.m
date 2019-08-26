%====================================================
%
%====================================================

function [default] = TrajectoryTest_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NumBGtests';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NumPLtests';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NumWFMtests';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLGrad (mT/m)';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PreGDur (ms)';
default{m,1}.entrystr = '0.25';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TotGDur (ms)';
default{m,1}.entrystr = '12';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'UseTrajNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'UseTrajDir';
default{m,1}.entrystr = 'X';
default{m,1}.options = {'Z','Y','X'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Dir';
default{m,1}.entrystr = 'Z';
default{m,1}.options = {'Z','Y','X'};

