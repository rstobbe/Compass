%=========================================================
% 
%=========================================================

function [default] = TpiType_CaSampDensDesign_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    gampath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\TPI\Gamma Functions\']; 
elseif strcmp(filesep,'/')
end
gamfunc = 'Gamma_CaKaiser_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'p1Val';
default{m,1}.entrystr = 0.125;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'p2Val';
default{m,1}.entrystr = 0.2;

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
