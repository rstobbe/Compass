%=========================================================
% (v1a)
%      
%=========================================================

function [SCRPTipt,DISP,err] = DisplayRelMap_v1a(SCRPTipt,DISPipt)

Status2('busy','Display Relative Image Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DISP.method = DISPipt.Func;
DISP.imcharsfunc = DISPipt.('ImCharsfunc').Func;  
DISP.figcharsfunc = DISPipt.('FigCharsfunc').Func;   
DISP.imscalefunc = DISPipt.('ImScalefunc').Func;  
DISP.plotfunc = DISPipt.('Plotfunc').Func;  

CallingLabel = DISPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ISCLipt = DISPipt.('ImScalefunc');
if isfield(DISPipt,([CallingLabel,'_Data']))
    if isfield(DISPipt.([CallingLabel,'_Data']),'ImScalefunc_Data')
        ISCLipt.('ImScalefunc_Data') = DISPipt.([CallingLabel,'_Data']).('ImScalefunc_Data');
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
func = str2func(DISP.imscalefunc);           
[SCRPTipt,ISCL,err] = func(SCRPTipt,ISCLipt);
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
DISP.ISCL = ISCL;
DISP.ICHRS = ICHRS;
DISP.FCHRS = FCHRS;
DISP.PLOT = PLOT;


Status2('done','',2);
Status2('done','',3);
