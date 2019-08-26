%=========================================================
% 
%=========================================================

function [default] = InitialEst_PreviousSDC_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'InitialEst_SDC';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadTrajectorySDC_v3';
default{m,1}.runfuncinput{1} = SCRPTPATHS.outloc;
default{m,1}.runfuncinput{2} = 'NoLoadPanel';
default{m,1}.runfuncoutput = {''};
