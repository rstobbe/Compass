%=========================================================
% 
%=========================================================

function [default] = kSpaceSamplekShifts_v2c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    objectpath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\kSpace Sample\Object Functions\Numerical\'];    
    kshiftpath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\kSpace Sample\kSpace Shift Functions\'];  
elseif strcmp(filesep,'/')
end
objectfunc = 'SimHead1Caltube_v1b';
kshiftfunc = 'kShiftRnd_v1a';
addpath([objectpath,objectfunc]);
addpath([kshiftpath,kshiftfunc]);

Sampling_Name = '';

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Sampling_Name';
default{m,1}.entrystr = Sampling_Name;

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
default{m,1}.labelstr = 'Objectfunc';
default{m,1}.entrystr = objectfunc;
default{m,1}.searchpath = objectpath;
default{m,1}.path = [objectpath,objectfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kShiftfunc';
default{m,1}.entrystr = kshiftfunc;
default{m,1}.searchpath = kshiftpath;
default{m,1}.path = [kshiftpath,kshiftfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'kSpaceSample';
default{m,1}.labelstr = 'Sample_kSpace';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Sample';