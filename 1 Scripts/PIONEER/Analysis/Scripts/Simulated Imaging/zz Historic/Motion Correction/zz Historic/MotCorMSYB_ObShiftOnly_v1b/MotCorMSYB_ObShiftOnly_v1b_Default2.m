%=========================================================
% 
%=========================================================

function [default] = MotCorMSYB_ObShiftOnly_v1b_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\') 
    obshftcorpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\Selectable Functions\Motion Correction\']; 
elseif strcmp(filesep,'/')
end
obshftcorfunc = 'ObShiftCorMSYB_v2a';
addpath([obshftcorpath,obshftcorfunc]);

MotCor_Name = '';

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'kSpaceLocCor_Name';
default{m,1}.entrystr = MotCor_Name;

m = m+1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'DataCor_Name';
default{m,1}.entrystr = MotCor_Name;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'Yes';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'Yes';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'SDC_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadSDCCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'Yes';
default{m,1}.runfunc2 = 'LoadSDCDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'Yes';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'kSamp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadkSampCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadkSampDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ObShftCorfunc';
default{m,1}.entrystr = obshftcorfunc;
default{m,1}.searchpath = obshftcorpath;
default{m,1}.path = [obshftcorpath,obshftcorfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'MotCor';
default{m,1}.labelstr = 'MotCor';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

