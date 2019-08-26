%=========================================================
% 
%=========================================================

function [default] = CTFVatSP_DblConv_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\zz Common\']));
    TFbuildPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\CTFVatSP SubFunctions\TFbuild Functions\'];
elseif strcmp(filesep,'/')
end

addpath(genpath(TFbuildPath));
TFbuildfunc = 'TFbuildElip_v1a';

m = 1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'TFbuildfunc';
default{m,1}.entrystr = TFbuildfunc;
