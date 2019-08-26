%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_SingleGradTestFile_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Test File with Single Gradient');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Gradient File
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Gradient File in Global Memory';
    return  
end
GRD = TOTALGBL{2,val};

%-----------------------------------------------------
% Test
%-----------------------------------------------------
if not(isfield(GRD,'Gvis'))
    err.flag = 1;
    err.msg = 'Global Does Not Contain a Gradient File';
    return
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.clr = SCRPTGBL.CurrentTree.('Colour');
    
%---------------------------------------------
% Plot Eddy Currents
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.GRD = GRD;
[PLOT,err] = func(INPUT,PLOT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
