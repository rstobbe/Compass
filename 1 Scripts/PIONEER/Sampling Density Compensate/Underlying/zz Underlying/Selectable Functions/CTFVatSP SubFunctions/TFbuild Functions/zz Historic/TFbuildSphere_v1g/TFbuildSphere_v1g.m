%================================================================================
% (v1g)
%       - a little tidying 
%       - delete weird radius quantizing
%================================================================================

function [SCRPTipt,TFB,err] = TFbuildSphere_v1g(SCRPTipt,TFBipt)

Status2('done','Get Build TF Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
TFB.method = TFBipt.Func;
%TFB.MinRadDim = 200;
TFB.MinRadDim = 150;            % dropped May2018
TFB.MaxSubSamp = 10;

Status2('done','',2);
Status2('done','',3);