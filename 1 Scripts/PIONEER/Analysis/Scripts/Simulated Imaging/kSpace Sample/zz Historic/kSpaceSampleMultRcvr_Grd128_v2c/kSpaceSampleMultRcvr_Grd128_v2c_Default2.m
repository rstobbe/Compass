%=========================================================
% 
%=========================================================

function [default] = kSpaceSampleMultRcvr_Grd128_v2c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    objectpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\kSpace Sample\Object Functions\Numerical\'];    
    gridrevpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Reverse Gridding\']; 
    rcvprofpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\Receiver Profiles\']; 
elseif strcmp(filesep,'/')
end
objectfunc = 'SimHead1CalFov240_v1a';
gridrevfunc = 'GridReverse_Pioneer_v1d';
rcvproffunc = 'RecProf8_v1a';
addpath([objectpath,objectfunc]);
addpath([gridrevpath,gridrevfunc]);
addpath([rcvprofpath,rcvproffunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Sampling_Name';
default{m,1}.entrystr = '';

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
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Objectfunc';
default{m,1}.entrystr = objectfunc;
default{m,1}.searchpath = objectpath;
default{m,1}.path = [objectpath,objectfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RcvProffunc';
default{m,1}.entrystr = rcvproffunc;
default{m,1}.searchpath = rcvprofpath;
default{m,1}.path = [rcvprofpath,rcvproffunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GridRevfunc';
default{m,1}.entrystr = gridrevfunc;
default{m,1}.searchpath = gridrevpath;
default{m,1}.path = [gridrevpath,gridrevfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'kSpaceSample';
default{m,1}.labelstr = 'Sample_kSpace';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Sample';

