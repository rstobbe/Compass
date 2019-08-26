%=========================================================
% (v1a)
%      
%=========================================================

function [SCRPTipt,DISP,err] = DisplayShimCal_v1a(SCRPTipt,DISPipt)

Status2('busy','Display Shim Calibration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DISP.method = DISPipt.Func;
DISP.plotfunc = DISPipt.('Plotfunc').Func;  

CallingLabel = DISPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
PLOTipt = DISPipt.('Plotfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'Plotfunc_Data')
        PLOTipt.('Plotfunc_Data') = DISPipt.([CallingLabel,'_Data']).('Plotfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(DISP.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
DISP.PLOT = PLOT;

Status2('done','',2);
Status2('done','',3);
