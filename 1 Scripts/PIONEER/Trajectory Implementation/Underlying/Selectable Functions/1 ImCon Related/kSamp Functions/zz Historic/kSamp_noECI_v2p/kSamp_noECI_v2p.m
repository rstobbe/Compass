%=====================================================
% (v2p) 
%       - start TPISRI_v2p
%=====================================================

function [SCRPTipt,KSMP,err] = kSamp_noECI_v2p(SCRPTipt,KSMPipt)

Status2('busy','Get Sample k-Space Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
KSMP.method = KSMPipt.Func;

Status2('done','',2);
Status2('done','',3);


    
    