%=====================================================
% (v2o) 
%       - test to insure proper SR at end of segment (SR must be slightly
%       shorter than the segment)
%       - plotting and saving change
%=====================================================

function [SCRPTipt,KSMP,err] = kSamp_TPISRI_v2o(SCRPTipt,KSMPipt)

Status2('busy','Get Sample k-Space Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;
KSMP.saveGSRI = KSMPipt.('Save_GSRI');
KSMP.GSRIfunc = KSMPipt.('GSRIfunc').Func;

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
CallingFunction = KSMPipt.Struct.labelstr;
GSRIipt = KSMPipt.('GSRIfunc');
if isfield(KSMPipt,([CallingFunction,'_Data']))
    if isfield(KSMPipt.kSampfunc_Data,('GSRIfunc_Data'))
        GSRIipt.GSRIfunc_Data = KSMPipt.kSampfunc_Data.GSRIfunc_Data;
    end
end

%------------------------------------------
% Get GSRI Function Info
%------------------------------------------
func = str2func(KSMP.GSRIfunc);           
[SCRPTipt,GSRI,err] = func(SCRPTipt,GSRIipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
KSMP.GSRI = GSRI;

Status2('done','',2);
Status2('done','',3);


    
    