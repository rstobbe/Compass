%=========================================================
% 
%=========================================================

function [default] = DesType_Basic_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    testpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\General\DesTest Functions\YarnBall\YarnBallOutInDualEcho\'];   
elseif strcmp(filesep,'/')
end
testfunc = 'DesTest_YarnBallOutInDualEchoStandard_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DesTestfunc';
default{m,1}.entrystr = testfunc;
default{m,1}.searchpath = testpath;
default{m,1}.path = [testpath,testfunc];
