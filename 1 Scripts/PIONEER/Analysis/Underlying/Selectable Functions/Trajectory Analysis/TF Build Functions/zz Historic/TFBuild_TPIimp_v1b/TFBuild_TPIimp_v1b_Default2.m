%=========================================================
% 
%=========================================================

function [default] = TFBuild_TPIimp_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    sdpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\zz Underlying\Selectable Functions\Trajectory Analysis\SigDec Functions\'];
elseif strcmp(filesep,'/')
end
sdfunc = 'SigDec_NaBiex_v1b';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SigDecfunc';
default{m,1}.entrystr = sdfunc;
default{m,1}.searchpath = sdpath;
default{m,1}.path = [sdpath,sdfunc];