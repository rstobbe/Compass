%=========================================================
% 
%=========================================================

function [default] = TimingAdjust_SingleCast_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\ConstEvol Functions\']; 
elseif strcmp(filesep,'/')
end
accconstfunc = 'ConstEvol_Simple_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstEvolfunc';
default{m,1}.entrystr = accconstfunc;
default{m,1}.searchpath = accconstpath;
default{m,1}.path = [accconstpath,accconstfunc];
