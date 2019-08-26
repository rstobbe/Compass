%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,SLR,err] = SLR_RFwfm_v1a(SCRPTipt,SLRipt)

Status2('busy','Create SLR Waveform',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
SLR.method = SLRipt.Func;
SLR.slvpts = str2double(SLRipt.('SlvPts')); 
SLR.tbwprod = str2double(SLRipt.('TimeBWprod')); 
SLR.ripin = str2double(SLRipt.('RippleIn')); 
SLR.ripout = str2double(SLRipt.('RippleOut'));
SLR.flip = str2double(SLRipt.('Flip')); 
SLR.type = SLRipt.('RFtype');

Status2('done','',2);
Status2('done','',3);



