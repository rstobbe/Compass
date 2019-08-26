%=========================================================
% (v1b)
%      - remove 'FigChars'
%=========================================================

function [SCRPTipt,SCRPTGBL,DISP,err] = SubPlotMontage_v1b(SCRPTipt,SCRPTGBL,DISPipt)

Status2('busy','Display Image Monage',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DISP.method = DISPipt.Func;
DISP.imcharsfunc = DISPipt.('ImCharsfunc').Func;  
DISP.createfunc = DISPipt.('Createfunc').Func;  

CallingLabel = DISPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMCHRSipt = DISPipt.('ImCharsfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'ImCharsfunc_Data')
        IMCHRSipt.('ImCharsfunc_Data') = DISPipt.([CallingLabel,'_Data']).('ImCharsfunc_Data');
    end
end
CREATEipt = DISPipt.('Createfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'Createfunc_Data')
        CREATEipt.('Createfunc_Data') = DISPipt.([CallingLabel,'_Data']).('Createfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(DISP.imcharsfunc);           
[SCRPTipt,IMCHRS,err] = func(SCRPTipt,IMCHRSipt);
if err.flag
    return
end
func = str2func(DISP.createfunc);           
[SCRPTipt,SCRPTGBL,CREATE,err] = func(SCRPTipt,SCRPTGBL,CREATEipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
DISP.IMCHRS = IMCHRS;
DISP.CREATE = CREATE;

Status2('done','',2);
Status2('done','',3);
