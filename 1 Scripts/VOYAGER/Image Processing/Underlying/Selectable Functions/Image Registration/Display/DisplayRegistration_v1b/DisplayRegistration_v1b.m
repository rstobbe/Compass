%=========================================================
% (v1a)
%      
%=========================================================

function [SCRPTipt,DISP,err] = DisplayRegistration_v1b(SCRPTipt,DISPipt)

Status2('busy','Display Registration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DISP.method = DISPipt.Func;
DISP.imcharsfunc = DISPipt.('ImCharsfunc').Func;  
DISP.figcharsfunc = DISPipt.('FigCharsfunc').Func;   
DISP.contrast1func = DISPipt.('Im1Contrastfunc').Func;  
DISP.contrast2func = DISPipt.('Im2Contrastfunc').Func;  
DISP.plotfunc = DISPipt.('Plotfunc').Func;  

CallingLabel = DISPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IM1CONTipt = DISPipt.('Im1Contrastfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'Im1Contrastfunc_Data')
        IM1CONTipt.('Im1Contrastfunc_Data') = DISPipt.([CallingLabel,'_Data']).('Im1Contrastfunc_Data');
    end
end
IM2CONTipt = DISPipt.('Im2Contrastfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'Im2Contrastfunc_Data')
        IM2CONTipt.('Im2Contrastfunc_Data') = DISPipt.([CallingLabel,'_Data']).('Im2Contrastfunc_Data');
    end
end
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
PLOTipt = DISPipt.('Plotfunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'Plotfunc_Data')
        PLOTipt.('Plotfunc_Data') = DISPipt.([CallingLabel,'_Data']).('Plotfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(DISP.contrast1func);           
[SCRPTipt,IM1CONT,err] = func(SCRPTipt,IM1CONTipt);
if err.flag
    return
end
func = str2func(DISP.contrast2func);           
[SCRPTipt,IM2CONT,err] = func(SCRPTipt,IM2CONTipt);
if err.flag
    return
end
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
func = str2func(DISP.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
DISP.IM1CONT = IM1CONT;
DISP.IM2CONT = IM2CONT;
DISP.ICHRS = ICHRS;
DISP.FCHRS = FCHRS;
DISP.PLOT = PLOT;

Status2('done','',2);
Status2('done','',3);
