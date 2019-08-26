%=========================================================
% 
%=========================================================

function [default] = MTde2simSPGR_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    coupledblochpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\Bloch Equations\'];
elseif strcmp(filesep,'/')
end
coupledblochfunc = 'CoupledBloch_v1a';
addpath([coupledblochpath,coupledblochfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CoupledBlochfunc';
default{m,1}.entrystr = coupledblochfunc;
default{m,1}.searchpath = coupledblochpath;
default{m,1}.path = [coupledblochpath,coupledblochfunc];

