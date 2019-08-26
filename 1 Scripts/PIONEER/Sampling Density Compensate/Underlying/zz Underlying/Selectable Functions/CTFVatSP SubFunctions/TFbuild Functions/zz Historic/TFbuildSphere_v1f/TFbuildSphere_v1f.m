%================================================================================
% (v1f)
%       - Allow Subsamp of 1 (needed for very high resolution trajectories)
%       - Eliminate 'MinRadDim' and 'MaxSubSamp' (select internally)
%================================================================================

function [SCRPTipt,TFB,err] = TFbuildSphere_v1f(SCRPTipt,TFBipt)

Status2('done','Get Build TF Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
TFB.method = TFBipt.Func;
TFB.MinRadDim = 200;
TFB.MaxSubSamp = 10;

Status2('done','',2);
Status2('done','',3);