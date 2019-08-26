%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,ECM,err] = SysModelTest_v1b(SCRPTipt,ECMipt)

Status2('busy','Get Eddy Current Modeling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
ECM.method = ECMipt.Func;
tcest = ECMipt.('Tc_Estimate');
magest = ECMipt.('Mag_Estimate');
ECM.gdelest = str2double(ECMipt.('Gdel_Estimate'));
ECM.atrfunc = ECMipt.('ATRfunc').Func;

%---------------------------------------------
% Get Values
%---------------------------------------------
inds1 = strfind(tcest,',');
inds2 = strfind(magest,',');
if isempty(inds1)
    inds1 = strfind(tcest,' ');
    inds2 = strfind(magest,' ');
end
if length(inds1) ~= length(inds2)
    err.flag = 1;
    err.msg = '''Tc Estimate'' and ''Mag Estimate'' must be the same length';
    return
end
if isempty(inds1)
    ECM.tcest = str2double(tcest);
    ECM.magest = str2double(magest);
else
    ECM.tcest(1) = str2double(tcest(1:inds1(1)-1));
    ECM.magest(1) = str2double(magest(1:inds2(1)-1));    
    for n = 2:length(inds1)
        ECM.tcest(n) = str2double(tcest(inds1(n-1)+1:inds1(n)-1));
        ECM.magest(n) = str2double(magest(inds2(n-1)+1:inds2(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    ECM.tcest(length(inds1)+1) = str2double(tcest(inds1(n)+1:length(tcest)));
    ECM.magest(length(inds1)+1) = str2double(magest(inds2(n)+1:length(magest)));     
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


