%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,CVARR,err] = CVarr_SphereROI_v1a(SCRPTipt,CVARRipt)

Status2('done','Arrayed Spherical ROIs',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
CVARR.method = CVARRipt.Func;
CVARR.diam = CVARRipt.('Diam');
CVARR.zerofill = str2double(CVARRipt.('ZeroFill'));
CVARR.cvcalcfunc = CVARRipt.('CVcalcfunc').Func;

CallingLabel = CVARRipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CVCALCipt = CVARRipt.('CVcalcfunc');
if isfield(CVARRipt,([CallingLabel,'_Data']))
    if isfield(CVARRipt.([CallingLabel,'_Data']),'CVcalcfunc_Data')
        CVCALCipt.('CVcalcfunc_Data') = CVARRipt.([CallingLabel,'_Data']).('CVcalcfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(CVARR.cvcalcfunc);           
[SCRPTipt,CVCALC,err] = func(SCRPTipt,CVCALCipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
CVARR.CVCALC = CVCALC;


Status2('done','',2);
Status2('done','',3);




