%=========================================================
% 
%=========================================================

function [default] = kSpaceSample_v2b_Default2(SCRPTPATHS)

ObjectSearchPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\kSpace Sample\Object Functions\'];
ImpLoadSearchPath = [SCRPTPATHS.scrptshareloc,'0 General\Underlying\File Related\'];

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = ImpLoadSearchPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Objectfunc';
default{m,1}.entrystr = '';
default{m,1}.searchpath = ObjectSearchPath;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'kSpaceSample';
default{m,1}.labelstr = 'Sample_kSpace';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Sample';