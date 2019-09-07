%=========================================================
% (v1b) 
%   - remove 'Plot' Function
%=========================================================

function [SCRPTipt,SCRPTGBL,MOF,err] = MontageOverlayFigure_v1b(SCRPTipt,SCRPTGBL,MOFipt)

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
MOF.slclbl = MOFipt.('SliceLabel');
MOF.scale = MOFipt.('Scale');
MOF.visible = MOFipt.('FigureVisible');
MOF.opacity = MOFipt.('Opacity');

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

%------------------------------------------
% Return
%------------------------------------------
MOF.IMSCL = IMSCL;
MOF.MSCL = MSCL;


Status2('done','',2);
Status2('done','',3);
