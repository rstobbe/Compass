%===========================================
% 
%===========================================

function [PCAL,err] = PowerCalibration_v1a_Func(PCAL,INPUT)

Status('busy','Power Calibration');
Status2('busy','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
DISP = INPUT.DISP;
DATCOL = INPUT.DATCOL;
SYSWRT = INPUT.SYSWRT;
clear INPUT;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([PCAL.dispfunc,'_Func']);  
INPUT.Im = IMG.Im;
INPUT.DPROPS.hist = 'No';
INPUT.DPROPS.figno = '1000';
INPUT.DPROPS.returnmont = 'Yes';
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;
Img = DISP.CRTE.Img;

%---------------------------------------------
% Get Data
%---------------------------------------------
func = str2func([PCAL.datcolfunc,'_Func']);  
INPUT.Im = Img;
INPUT.figno = '1000';
[DATCOL,err] = func(DATCOL,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Write Data
%---------------------------------------------
if not(isnan(DATCOL.value))
    func = str2func([PCAL.syswrtfunc,'_Func']);  
    INPUT.DATCOL = DATCOL;
    INPUT.IMG = IMG;
    [SYSWRT,err] = func(SYSWRT,INPUT);
    if err.flag
        return
    end
    clear INPUT;
else
    err.flag = 4;
    err.msg = 'No Power Change';
    return
end

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'Power Change (dB)',-DATCOL.value,'Output'};
if isfield(DATCOL,'value2')
    Panel(2,:) = {'Power Change2 (dB)',-DATCOL.value2,'Output'};
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    
%---------------------------------------------
% Return
%---------------------------------------------
PCAL.DATCOL = DATCOL;
PCAL.PanelOutput = PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

