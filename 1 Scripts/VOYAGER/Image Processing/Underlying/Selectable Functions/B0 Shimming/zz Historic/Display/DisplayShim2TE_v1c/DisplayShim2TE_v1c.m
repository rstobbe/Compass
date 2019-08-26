%=========================================================
% (v1c)
%      Update for Plotting Routine updates
%=========================================================

function [SCRPTipt,DISP,err] = DisplayShim2TE_v1c(SCRPTipt,DISPipt)

Status2('busy','Display Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DISP.method = DISPipt.Func;
DISP.imcharsfunc = DISPipt.('ImCharsfunc').Func;  
DISP.figcharsfunc = DISPipt.('FigCharsfunc').Func;   
DISP.createfunc = DISPipt.('Createfunc').Func;  

CallingLabel = DISPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ICHRSipt = DISPipt.('ImCharsfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'ImCharsfunc_Data')
        ICHRSipt.('ImCharsfunc_Data') = DISPipt.([CallingLabel,'_Data']).('ImCharsfunc_Data');
    end
end
FCHRSipt = DISPipt.('FigCharsfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'FigCharsfunc_Data')
        FCHRSipt.('FigCharsfunc_Data') = DISPipt.([CallingLabel,'_Data']).('FigCharsfunc_Data');
    end
end
CRTEipt = DISPipt.('Createfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'Createfunc_Data')
        CRTEipt.('Createfunc_Data') = DISPipt.([CallingLabel,'_Data']).('Createfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(DISP.imcharsfunc);           
[SCRPTipt,ICHRS,err] = func(SCRPTipt,ICHRSipt);
if err.flag
    return
end
func = str2func(DISP.figcharsfunc);           
[SCRPTipt,FCHRS,err] = func(SCRPTipt,FCHRSipt);
if err.flag
    return
end
func = str2func(DISP.createfunc);           
[SCRPTipt,CRTE,err] = func(SCRPTipt,CRTEipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
DISP.ICHRS = ICHRS;
DISP.FCHRS = FCHRS;
DISP.CRTE = CRTE;

Status2('done','',2);
Status2('done','',3);
