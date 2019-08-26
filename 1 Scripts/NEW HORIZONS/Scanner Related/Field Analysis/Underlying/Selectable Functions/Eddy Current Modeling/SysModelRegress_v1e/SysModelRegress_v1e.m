%=========================================================
% (v1e)
%       - switch gdel direction
%       - include decaying eddy current model
%=========================================================

function [SCRPTipt,ECM,err] = SysModelRegress_v1e(SCRPTipt,ECMipt)

Status2('busy','Get Eddy Current Modeling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
ECM.method = ECMipt.Func;
ECM.subrgrslen = ECMipt.('SubRrgsLen');
tcest = ECMipt.('Tc_Estimate');
magest = ECMipt.('Mag_Estimate');
gdelest = ECMipt.('Gdel_Estimate');
ECM.gstart = str2double(ECMipt.('GradStart'));
decest = ECMipt.('DecayingEst');
ECM.atrfunc = ECMipt.('ATRfunc').Func;

%---------------------------------------------
% Get Values
%---------------------------------------------
if strcmp(tcest(1),'*');
    ECM.tcconst = str2double(tcest(2:length(tcest)));
    ECM.tcest = [];
else
    ECM.tcest = str2double(tcest);
    ECM.tcconst = [];
end
if strcmp(magest(1),'*');    
    ECM.magconst = str2double(magest(2:length(magest)));
    ECM.magest = [];
else
    ECM.magest = str2double(magest);
    ECM.magconst = [];
end
if strcmp(gdelest(1),'*');
    ECM.gdelconst = str2double(gdelest(2:length(gdelest)));
    ECM.gdelest = [];
else
    ECM.gdelest = str2double(gdelest);
    ECM.gdelconst = [];
end
if strcmp(decest(1),'*');
    ECM.decconst = str2double(decest(2:length(decest)));
    ECM.decest = [];
else
    ECM.decest = str2double(decest);
    ECM.decconst = [];
end


%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = ECMipt.Struct.labelstr;
ATRipt = ECMipt.('ATRfunc');
if isfield(ECMipt,([CallingFunction,'_Data']))
    if isfield(ECMipt.ECMfunc_Data,('ATRfunc_Data'))
        ATRipt.ATRfunc_Data = ECMipt.ECMfunc_Data.ATRfunc_Data;
    end
end

%------------------------------------------
% ATR Function Info
%------------------------------------------
func = str2func(ECM.atrfunc);           
[SCRPTipt,ATR,err] = func(SCRPTipt,ATRipt);
if err.flag
    return
end

ECM.ATR = ATR;

Status2('done','',2);
Status2('done','',3);
