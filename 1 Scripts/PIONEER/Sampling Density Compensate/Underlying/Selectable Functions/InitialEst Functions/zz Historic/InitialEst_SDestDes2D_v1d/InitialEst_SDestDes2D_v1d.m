%====================================================
% (v1d)
%       - update to get data from Kmat rather than KSA
%       - Yarn-Ball implementation must have 'projlen' fully calculated to
%       work with this (see v1c)
%====================================================

function [SCRPTipt,IE,err] = InitialEst_SDestDes2D_v1d(SCRPTipt,IEipt)

Status2('done','Get Initial Estimate Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IE.script = IEipt.Func;

Status2('done','',2);
Status2('done','',3);