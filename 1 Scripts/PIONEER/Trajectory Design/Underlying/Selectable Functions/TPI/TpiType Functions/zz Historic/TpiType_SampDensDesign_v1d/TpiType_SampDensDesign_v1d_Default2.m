%=========================================================
% 
%=========================================================

function [default] = TpiType_SampDensDesign_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    gampath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\TPI\Gamma Functions\']; 
elseif strcmp(filesep,'/')
end
gamfunc = 'Kaiser_v1d';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'pVal';
default{m,1}.entrystr = 0.125;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PhiConstrain (%)';
default{m,1}.entrystr = 20;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Gamfunc';
default{m,1}.entrystr = gamfunc;
default{m,1}.searchpath = gampath;
default{m,1}.path = [gampath,gamfunc];
