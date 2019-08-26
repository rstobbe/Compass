%=========================================================
% 
%=========================================================

function [default] = MTsimSPGR_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    coupledblochpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\Bloch Equations\'];
    linevalpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\MT Functions\Line Shape Values at Woff\'];
elseif strcmp(filesep,'/')
end
coupledblochfunc = 'ModifiedCoupledBloch_v1a';
addpath([coupledblochpath,coupledblochfunc]);
linevalfunc = 'SupLorAtWoff_v1a';
addpath([linevalpath,linevalfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LineShapeValfunc';
default{m,1}.entrystr = linevalfunc;
default{m,1}.searchpath = linevalpath;
default{m,1}.path = [linevalpath,linevalfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CoupledBlochfunc';
default{m,1}.entrystr = coupledblochfunc;
default{m,1}.searchpath = coupledblochpath;
default{m,1}.path = [coupledblochpath,coupledblochfunc];

