%=====================================================
% (v2g)
%       - Remove File to higher level
%=====================================================

function [SCRPTipt,GSRA,err] = GSRA_TPIstandard_v2g(SCRPTipt,GSRAipt)

Status2('busy','Get Step Response Accomodation Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GSRA.method = GSRAipt.Func;

Status2('done','',2);
Status2('done','',3);

            
        

       