%=========================================================
% 
%=========================================================

function [default] = Plot_TrajTest_v1a_Default2(SCRPTPATHS)

m = 1;
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
default{m,1}.labelstr = 'TrajNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajOrtho';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Polarity';
default{m,1}.entrystr = 'Pos';
default{m,1}.options = {'Pos','Neg'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GStartShift (us)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'r';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot_Traj';
default{m,1}.labelstr = 'Plot_Traj';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';