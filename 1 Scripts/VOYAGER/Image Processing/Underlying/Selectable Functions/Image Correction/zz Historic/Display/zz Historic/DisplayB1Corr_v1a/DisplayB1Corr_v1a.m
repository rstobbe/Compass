%=========================================================
% (v1a)
%      
%=========================================================

function [SCRPTipt,DISP,err] = DisplayB1Map_v1a(SCRPTipt,DISPipt)

Status2('busy','Display B1 Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = DISPipt.Struct.labelstr;
%---------------------------------------------
% Get Input
%---------------------------------------------
DISP.method = DISPipt.Func;
DISP.plotfunc = DISPipt.('Mapfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
PLOTipt = DISPipt.('Mapfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'Mapfunc_Data')
        PLOTipt.('Mapfunc_Data') = DISPipt.([CallingLabel,'_Data']).('Mapfunc_Data');
    end
end

%------------------------------------------
% Get Maping Info
%------------------------------------------
func = str2func(DISP.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
DISP.PLOT = PLOT;

Status('done','');
Status2('done','',2);
Status2('done','',3);

