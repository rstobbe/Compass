%=========================================================
% 
%=========================================================

function [default] = CTFVatSP_DblConv_kElip_v1g_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\zz Common\']));
    TFbuildPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\CTFVatSP SubFunctions\TFbuild Functions\'];
elseif strcmp(filesep,'/')
end
TFbuildfunc = 'TFbuildElip_v1d';
addpath([TFbuildPath,TFbuildfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TFbuildfunc';
default{m,1}.entrystr = TFbuildfunc;
default{m,1}.searchpath = TFbuildPath;
default{m,1}.path = [TFbuildPath,TFbuildfunc];