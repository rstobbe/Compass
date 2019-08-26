%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,MONT,err] = MontageFigureRoi_v1a(SCRPTipt,SCRPTGBL,MONTipt)

Status2('busy','Montage Figure With ROI',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MONT.method = MONTipt.Func; 
MONT.imscalefunc = MONTipt.('ImScalefunc').Func;
MONT.roiloadfunc = MONTipt.('RoiLoadfunc').Func; 
MONT.roiplotfunc = MONTipt.('RoiPlotfunc').Func;  
MONT.plotfunc = MONTipt.('Plotfunc').Func;  

CallingLabel = MONTipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMSCLipt = MONTipt.('ImScalefunc');
if isfield(MONTipt,([CallingLabel,'_Data']))
    if isfield(MONTipt.([CallingLabel,'_Data']),'ImScalefunc_Data')
        IMSCLipt.('ImScalefunc_Data') = MONTipt.([CallingLabel,'_Data']).('ImScalefunc_Data');
    end
end
ROILOADipt = MONTipt.('RoiLoadfunc');
if isfield(MONTipt,([CallingLabel,'_Data']))
    if isfield(MONTipt.([CallingLabel,'_Data']),'RoiLoadfunc_Data')
        ROILOADipt.('RoiLoadfunc_Data') = MONTipt.([CallingLabel,'_Data']).('RoiLoadfunc_Data');
    end
end
ROIPLOTipt = MONTipt.('RoiPlotfunc');
if isfield(MONTipt,([CallingLabel,'_Data']))
    if isfield(MONTipt.([CallingLabel,'_Data']),'RoiPlotfunc_Data')
        ROIPLOTipt.('RoiPlotfunc_Data') = MONTipt.([CallingLabel,'_Data']).('RoiPlotfunc_Data');
    end
end
PLOTipt = MONTipt.('Plotfunc');
if isfield(MONTipt,([CallingLabel,'_Data']))
    if isfield(MONTipt.([CallingLabel,'_Data']),'Plotfunc_Data')
        PLOTipt.('Plotfunc_Data') = MONTipt.([CallingLabel,'_Data']).('Plotfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(MONT.imscalefunc);           
[SCRPTipt,IMSCL,err] = func(SCRPTipt,IMSCLipt);
if err.flag
    return
end
func = str2func(MONT.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end
func = str2func(MONT.roiloadfunc);           
[SCRPTipt,SCRPTGBL,ROILOAD,err] = func(SCRPTipt,SCRPTGBL,ROILOADipt);
if err.flag
    return
end
func = str2func(MONT.roiplotfunc);           
[SCRPTipt,ROIPLOT,err] = func(SCRPTipt,ROIPLOTipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
MONT.IMSCL = IMSCL;
MONT.PLOT = PLOT;
MONT.ROILOAD = ROILOAD;
MONT.ROIPLOT = ROIPLOT;

Status2('done','',2);
Status2('done','',3);
