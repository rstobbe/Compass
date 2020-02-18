%====================================================
%  
%====================================================

function [COR,err] = B1TxcorrDW_v1a_Func(COR,INPUT)

Status2('busy','DW-weighted B1 Correction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Sort Out Inputs
%---------------------------------------------
if iscell(IMG)
    if length(IMG) == 1
        IMG = IMG{1};
    end
end
if iscell(IMG)
    if length(IMG) ~= 2
        err.flag = 1;
        err.msg = 'Load 2 Images';
        return
    end
    IMG1 = IMG{1};
    IMG2 = IMG{2};
    ReconPars1 = IMG1.ReconPars;
    ExpPars1 = IMG1.ExpPars;
    Im0 = IMG1.Im;
    ReconPars2 = IMG2.ReconPars;
    B1Map = IMG2.Im(:,:,:,1);  
    
    %----------------------------------------
    % Compare
%     [~,~,comperr] = comp_struct(ReconPars1,ReconPars2,'ReconPars1','ReconPars2');
%     if not(isempty(comperr))
%         err.flag = 1;
%         err.msg = 'Image recons do not match';
%         return
%     end
    ReconPars = ReconPars1;
end

%---------------------------------------------
% Info
%---------------------------------------------
flip = ExpPars1.Sequence.flip_angle;

%---------------------------------------------
% Ensure proper
%---------------------------------------------
B1Map = real(B1Map);
B1Map(B1Map<0.5) = NaN;

%---------------------------------------------
% Calc
%---------------------------------------------
B1TxDepend = sin(B1Map*pi*flip/180)/sin(pi*flip/180);
Im = Im0./(B1TxDepend);

%----------------------------------------------
% Naming
%----------------------------------------------
if isfield(IMG1,'name')
    CORIMG.name = IMG1.name;
    if strfind(CORIMG.name,'.mat')
        CORIMG.name = CORIMG.name(1:end-4);
    end
    if strfind(CORIMG.name,'IMG_')
        CORIMG.name = [CORIMG.name,'_B1c'];
    end
else
    CORIMG.name = '';
end
CORIMG.path = IMG1.path;

%----------------------------------------------
% Panel Items
%----------------------------------------------
CORIMG.PanelOutput = [];
CORIMG.ExpDisp = PanelStruct2Text(CORIMG.PanelOutput);

%---------------------------------------------
% Return
%---------------------------------------------
CORIMG.Im = Im;
CORIMG.ReconPars = ReconPars;
CORIMG.ExpPars = ExpPars1;
COR.IMG = CORIMG;

Status2('done','',2);
Status2('done','',3);

