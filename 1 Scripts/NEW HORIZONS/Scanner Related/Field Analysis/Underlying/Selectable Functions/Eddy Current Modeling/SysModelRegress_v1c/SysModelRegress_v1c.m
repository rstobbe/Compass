%=========================================================
% (v1c)
%       - facilitate sub-trajectory modeling
%=========================================================

function [SCRPTipt,ECM,err] = SysModelRegress_v1c(SCRPTipt,ECMipt)

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
else
    if strcmp(tcest(1),'*');
        ECM.tcconst = str2double(tcest(2:inds1(1)-1));
        ECM.tcest = [];
    else
        ECM.tcest = str2double(tcest(1:inds1(1)-1));
        ECM.tcconst = [];
    end
    if strcmp(magest(1),'*');    
        ECM.magconst = str2double(magest(2:inds2(1)-1)); 
        ECM.magest = [];
    else
        ECM.magest = str2double(magest(1:inds2(1)-1));
        ECM.magconst = [];
    end     
    for n = 2:length(inds1)
        ECM.tcest(n) = str2double(tcest(inds1(n-1)+1:inds1(n)-1));
        ECM.magest(n) = str2double(magest(inds2(n-1)+1:inds2(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    ECM.tcest(length(inds1)+1) = str2double(tcest(inds1(n)+1:length(tcest)));
    ECM.magest(length(inds2)+1) = str2double(magest(inds2(n)+1:length(magest)));     
end
if strcmp(gdelest(1),'*');
    ECM.gdelconst = str2double(gdelest(2:length(gdelest)));
    ECM.gdelest = [];
else
    ECM.gdelest = str2double(gdelest);
    ECM.gdelconst = [];
end

if length(ECM.tcest)>1
    if ECM.tcest(1) == 0 
        ECM.tcest = ECM.tcest(2:length(ECM.tcest));
    end
end
if length(ECM.magest)>1
    if ECM.magest(1) == 0
        ECM.magest = ECM.magest(2:length(ECM.magest));
    end
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
