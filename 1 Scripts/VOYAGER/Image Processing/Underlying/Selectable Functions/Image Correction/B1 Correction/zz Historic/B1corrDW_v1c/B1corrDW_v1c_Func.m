%====================================================
%  
%====================================================

function [COR,err] = B1corrDW_v1c_Func(COR,INPUT)

Status2('busy','DW-weighted B1 Correction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im0 = INPUT.Im;
B1Map = INPUT.B1Map;
SeqPars = INPUT.Sequence;
clear INPUT;

%---------------------------------------------
% Info
%---------------------------------------------
flip = SeqPars.flip_angle;

%---------------------------------------------
% Ensure proper
%---------------------------------------------
B1Map = real(B1Map);
B1Map(B1Map<0.5) = NaN;

%---------------------------------------------
% Calc
%---------------------------------------------
B1TxDepend = sin(B1Map*pi*flip/180)/sin(pi*flip/180);
B1RxDepend = B1Map;
if strcmp(COR.correction,'TxRx')
    Im(:,:,:,1) = Im0./(B1TxDepend.*B1RxDepend);
elseif strcmp(COR.correction,'Tx')
    Im(:,:,:,1) = Im0./(B1TxDepend);
elseif strcmp(COR.correction,'Rx')
    Im(:,:,:,1) = Im0./(B1RxDepend);
end
Im(:,:,:,2) = B1TxDepend;
Im(:,:,:,3) = B1RxDepend;
Im(:,:,:,4) = (B1TxDepend.*B1RxDepend);
Im(:,:,:,5) = Im0;

%---------------------------------------------
% Return
%---------------------------------------------
COR.Im = Im;

Status2('done','',2);
Status2('done','',3);

