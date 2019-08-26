%=========================================================
% 
%=========================================================

function [default] = CalcPSFA_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    tfpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Trajectory Analysis\TF Build Functions\'];
    suspath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Trajectory Analysis\SUS Build Functions\'];
elseif strcmp(filesep,'/')
end
tffunc = 'TFBuild_TPIdes_v1a';
susfunc = 'SUSBuild_TPIdes_v1a';

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
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TFBuildfunc';
default{m,1}.entrystr = tffunc;
default{m,1}.searchpath = tfpath;
default{m,1}.path = [tfpath,tffunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SUSBuildfunc';
default{m,1}.entrystr = susfunc;
default{m,1}.searchpath = suspath;
default{m,1}.path = [suspath,susfunc];

