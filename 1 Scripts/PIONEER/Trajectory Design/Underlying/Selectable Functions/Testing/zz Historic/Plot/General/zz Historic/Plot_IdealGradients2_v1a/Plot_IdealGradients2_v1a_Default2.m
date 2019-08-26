%=========================================================
% 
%=========================================================

function [default] = Plot_IdealGradients2_v1a_Default2(SCRPTPATHS)

gradcalcpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common\0 Scanner Related\GWFM Functions\'];
addpath(genpath(gradcalcpath));

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gamma';
default{m,1}.entrystr = '42.577';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';
default{m,1}.runfunc = 'Plot_IdealGradients2_v1a';