%=========================================================
% 
%=========================================================

function [default] = PerfSampSDC_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    TFPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\TF Functions\'];
elseif strcmp(filesep,'/')
end
TFfunc = 'TF_Kaiser_v1c';
addpath([TFPath,TFfunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'SDC_Name';
default{m,1}.entrystr = '';

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
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TFfunc';
default{m,1}.entrystr = TFfunc;
default{m,1}.searchpath = TFPath;
default{m,1}.path = [TFPath,TFfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'CreateSampArr';
default{m,1}.labelstr = 'CreateSampArr';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Sample';
