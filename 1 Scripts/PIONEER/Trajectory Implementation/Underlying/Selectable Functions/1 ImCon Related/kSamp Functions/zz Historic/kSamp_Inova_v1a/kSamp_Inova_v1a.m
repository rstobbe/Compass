%=====================================================
% (v1a) 
%       
%=====================================================

function [SCRPTipt,KSMP,err] = kSamp_Inova_v1a(SCRPTipt,KSMPipt)

Status2('busy','Get Sample k-Space Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;

Status2('done','',2);
Status2('done','',3);


    
    