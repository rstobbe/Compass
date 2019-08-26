%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,GVEL,err] = GvelProf_Exp2Decay_v1a(SCRPTipt,GVELipt)

Status2('done','Get Gradient Velocity Profile info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GVEL.method = GVELipt.Func;  
GVEL.tau = str2double(GVELipt.('tau'));
GVEL.startfrac = str2double(GVELipt.('startfrac'));
GVEL.decayrate = str2double(GVELipt.('decayrate'));
GVEL.decayshift = str2double(GVELipt.('decayshift'));
GVEL.enddrop = str2double(GVELipt.('enddrop'));

Status2('done','',3);