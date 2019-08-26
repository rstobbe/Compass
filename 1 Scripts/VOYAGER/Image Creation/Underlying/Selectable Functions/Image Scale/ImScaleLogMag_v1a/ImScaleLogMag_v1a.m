%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,SCALE,err] = ImScaleLogMag_v1a(SCRPTipt,SCALEipt)

Status2('busy','Get Scale Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SCALE.method = SCALEipt.Func;
SCALE.range = str2double(SCALEipt.('Range'));

Status2('done','',2);
Status2('done','',3);









