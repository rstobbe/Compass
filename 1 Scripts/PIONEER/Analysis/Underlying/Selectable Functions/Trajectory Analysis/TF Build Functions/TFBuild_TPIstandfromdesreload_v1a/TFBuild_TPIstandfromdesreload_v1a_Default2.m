%=========================================================
% 
%=========================================================

function [default] = TFBuild_TPIstandfromdesreload_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    sdpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\zz Underlying\Selectable Functions\Trajectory Analysis\SigDec Functions\'];
elseif strcmp(filesep,'/')
end
sdfunc = 'SigDec_NaBiex_v1b';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'DES_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajDesCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadTrajDesDisp';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SigDecfunc';
default{m,1}.entrystr = sdfunc;
default{m,1}.searchpath = sdpath;
default{m,1}.path = [sdpath,sdfunc];