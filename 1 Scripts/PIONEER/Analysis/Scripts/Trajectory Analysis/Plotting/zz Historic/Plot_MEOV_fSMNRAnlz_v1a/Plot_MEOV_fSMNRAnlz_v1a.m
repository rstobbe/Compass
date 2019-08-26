%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_MEOV_fSMNRAnlz_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot MEOV Arrary Analysis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get EDDY Currents
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Implementation in Global Memory';
    return  
end
ANLZ = TOTALGBL{2,val};

%-----------------------------------------------------
% Test
%-----------------------------------------------------
if not(isfield(ANLZ,'Nroi'))
    err.flag = 1;
    err.msg = 'Global is not from Analysis';
    return
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.snvr = str2double(SCRPTGBL.CurrentTree.('SNVR'));
PLOT.smnr = str2double(SCRPTGBL.CurrentTree.('SMNR'));
PLOT.colour = SCRPTGBL.CurrentTree.('Colour');

%---------------------------------------------
% Plot 
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.ANLZ = ANLZ;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
