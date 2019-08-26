%=========================================================
% (v1b)
%     
%=========================================================

function [SCRPTipt,ROT,err] = ImageRotation_v1b(SCRPTipt,ROTipt)

Status2('busy','Rotate Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ROT.method = ROTipt.Func;
ROT.TraRot = str2double(ROTipt.('TraRot'));
ROT.SagRot = str2double(ROTipt.('SagRot'));
ROT.CorRot = str2double(ROTipt.('CorRot'));

Status2('done','',2);
Status2('done','',3);

