%=========================================================
% 
%=========================================================

function [default] = kSpaceSampleTranslation_v2c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    objectpath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\kSpace Sample\Object Functions\Numerical\'];    
    motionpath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\kSpace Sample\Motion Functions\'];  
elseif strcmp(filesep,'/')
end
objectfunc = 'SimHead1Caltube_v1b';
motionfunc = 'ObjectTransRnd_v1a';
addpath([objectpath,objectfunc]);
addpath([motionpath,motionfunc]);

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
default{m,1}.labelstr = 'Transfunc';
default{m,1}.entrystr = motionfunc;
default{m,1}.searchpath = motionpath;
default{m,1}.path = [motionpath,motionfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'kSpaceSample';
default{m,1}.labelstr = 'Sample_kSpace';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Sample';