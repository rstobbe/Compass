%=========================================================
% (v1b)
%       - Add Hist Step Input
%=========================================================

function [SCRPTipt,DISP,err] = DisplayShim2TE_v1b(SCRPTipt,DISPipt)

Status2('busy','Plot Shimming',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = DISPipt.Struct.labelstr;
%---------------------------------------------
% Get Input
%---------------------------------------------
DISP.method = DISPipt.Func;
DISP.plotfunc = DISPipt.('Plotfunc').Func;
DISP.orient = DISPipt.('Orientation');
DISP.inset = DISPipt.('Inset');
DISP.dispfullwid = DISPipt.('DispFull');
DISP.dispmaskwid = DISPipt.('DispMask');
DISP.histstepfull = str2double(DISPipt.('HistStepFull'));
DISP.histstepmask = str2double(DISPipt.('HistStepMask'));

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
% Get Plotting Info
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

