%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,MOF,err] = MontageOverlayFigure_v1a(SCRPTipt,MOFipt)

Status2('busy','Montage Overlay Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MOF.method = MOFipt.Func; 
MOF.imscalefunc = MOFipt.('ImScalefunc').Func;  
MOF.mapscalefunc = MOFipt.('MapScalefunc').Func;  
MOF.plotfunc = MOFipt.('Plotfunc').Func;  

CallingLabel = MOFipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMSCLipt = MOFipt.('ImScalefunc');
if isfield(MOFipt,([CallingLabel,'_Data']))
    if isfield(MOFipt.([CallingLabel,'_Data']),'ImScalefunc_Data')
        IMSCLipt.('ImScalefunc_Data') = MOFipt.([CallingLabel,'_Data']).('ImScalefunc_Data');
    end
end
MSCLipt = MOFipt.('MapScalefunc');
if isfield(MOFipt,([CallingLabel,'_Data']))
    if isfield(MOFipt.([CallingLabel,'_Data']),'MapScalefunc_Data')
        MSCLipt.('MapScalefunc_Data') = MOFipt.([CallingLabel,'_Data']).('MapScalefunc_Data');
    end
end
PLOTipt = MOFipt.('Plotfunc');
if isfield(MOFipt,([CallingLabel,'_Data']))
    if isfield(MOFipt.([CallingLabel,'_Data']),'Plotfunc_Data')
        PLOTipt.('Plotfunc_Data') = MOFipt.([CallingLabel,'_Data']).('Plotfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(MOF.imscalefunc);           
[SCRPTipt,IMSCL,err] = func(SCRPTipt,IMSCLipt);
if err.flag
    return
end
func = str2func(MOF.mapscalefunc);           
[SCRPTipt,MSCL,err] = func(SCRPTipt,MSCLipt);
if err.flag
    return
end
func = str2func(MOF.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
MOF.IMSCL = IMSCL;
MOF.MSCL = MSCL;
MOF.PLOT = PLOT;


Status2('done','',2);
Status2('done','',3);
