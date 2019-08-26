%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = DisplayShim_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Display Shim');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Image
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Image in Global Memory';
    return  
end
SHIM = TOTALGBL{2,val};

%---------------------------------------------
% Get Input
%---------------------------------------------
DISP.method = SCRPTGBL.CurrentTree.Func;
DISP.plotfunc = SCRPTGBL.CurrentTree.('Plotfunc').Func;
DISP.orient = SCRPTGBL.CurrentTree.('Orientation');
DISP.inset = SCRPTGBL.CurrentTree.('Inset');
DISP.disporigfullwid = SCRPTGBL.CurrentTree.('DispOrigFull');
DISP.disporigmaskwid = SCRPTGBL.CurrentTree.('DispOrigMask');
DISP.dispfitmaskwid = SCRPTGBL.CurrentTree.('DispFitMask');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
PLOTipt = SCRPTGBL.CurrentTree.('Plotfunc');
if isfield(SCRPTGBL,('Plotfunc_Data'))
    PLOTipt.Plotfunc_Data = SCRPTGBL.Plotfunc_Data;
end

%------------------------------------------
% Get Plot Function Info
%------------------------------------------
func = str2func(DISP.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([DISP.method,'_Func']);
INPUT.SHIM = SHIM;
INPUT.PLOT = PLOT;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.KeepEdit = 'yes';

Status('done','');
Status2('done','',2);
Status2('done','',3);

