%====================================================
% 
%====================================================

function [TST,err] = TrajTest_Radial3DTestFull_v1a_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

%TST.testing = 'Yes';
%TST.savelots = 'Yes';
%TST.traj = 'TestSet';

TST.SYSRESP.Vis = 'Yes';
TST.SOLFINTEST.Vis = 'Yes';
TST.IMPTYPE.Vis = 'Yes';
TST.GVis = 'Yes';
TST.KVis = 'Yes';
TST.IMETH.panel = 'full';

if strcmp(TST.figloc,'Centre')
    TST.figshift = 0;
elseif strcmp(TST.figloc,'Left')
    TST.figshift = -1920;    
elseif strcmp(TST.figloc,'Right')
    TST.figshift = 1920;
end

Status('done','');
Status2('done','',2);
Status2('done','',3);
