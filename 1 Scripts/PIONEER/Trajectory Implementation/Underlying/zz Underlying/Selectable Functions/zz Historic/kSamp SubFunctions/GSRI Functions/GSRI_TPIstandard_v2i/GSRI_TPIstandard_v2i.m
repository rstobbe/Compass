%=====================================================
% (v2i)
%       - Remove StepResp File to Level Up
%=====================================================

function [SCRPTipt,GSRI,err] = GSRI_TPIstandard_v2i(SCRPTipt,GSRIipt)

Status2('busy','Get Step Response Inclusion Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GSRI.method = GSRIipt.Func;

Status2('done','',2);
Status2('done','',3);

            
   