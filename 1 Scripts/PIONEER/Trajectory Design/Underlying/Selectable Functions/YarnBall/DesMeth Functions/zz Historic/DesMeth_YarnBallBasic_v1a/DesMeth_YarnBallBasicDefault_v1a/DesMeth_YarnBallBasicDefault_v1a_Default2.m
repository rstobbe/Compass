%=========================================================
% 
%=========================================================

function [default] = DesMeth_YarnBallBasicDefault_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    spinpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\Spin Functions\'];        
elseif strcmp(filesep,'/')
end
spinfunc = 'Spin_HemlockFreeUsamp_v3c';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Spinfunc';
default{m,1}.entrystr = spinfunc;
default{m,1}.searchpath = spinpath;
default{m,1}.path = [spinpath,spinfunc];


