%==================================================
% 
%==================================================

function [GSYSMOD,err] = ModelFull_GradSysResponse_v1a_Func(GSYSMOD,INPUT)

Status('busy','Model Gradient System Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO{1} = INPUT.MFEVOX;
MFEVO{2} = INPUT.MFEVOY;
MFEVO{3} = INPUT.MFEVOZ;
MOD = INPUT.MOD;
clear INPUT;

%-----------------------------------------------------
% Plot Type
%-----------------------------------------------------
dirarr = ('XYZ');
for n = 1:3
    func = str2func([GSYSMOD.modelfunc,'_Func']);
    if not(strcmp(MFEVO{n}.graddir,dirarr(n)))
        err.flag = 1;
        err.msg = 'Get gradient directions right';
        return
    end
    INPUT.Number = n;
    INPUT.MFEVO = MFEVO{n};
    [MOD,err] = func(MOD,INPUT);
    if err.flag
        return
    end
    clear INPUT
    
    ExpDisp{n} = MOD.ExpDisp;
    filtcoeff(:,n) = MOD.filtcoeff; 
    delaygradient(n) = MOD.delaygradient;
    regressiondelay(n) = MOD.regressiondelay;
    efftrajdel(n) = MOD.efftrajdel; 
    dwell(n) = MOD.dwell;
end

%----------------------------------------------------
% Save Figures
%----------------------------------------------------
if isfield(MOD,'Figure')
    GSYSMOD.Figure = MOD.Figure;
end

if round(dwell(1)*1e6) == round(dwell(2)*1e6) && round(dwell(2)*1e6) == round(dwell(3)*1e6)
    GSYSMOD.dwell = dwell(1);
else
    %test = round(dwell*1e6)
    err.flag = 1;
    err.msg = 'Use same experiment for each';
    return
end
    
GSYSMOD.ExpDisp = [ExpDisp{1},ExpDisp{2},ExpDisp{3}];
GSYSMOD.delaygradient = delaygradient(1);                           % should all be the same
GSYSMOD.regressiondelay = regressiondelay(1);
GSYSMOD.filtcoeff = filtcoeff;
GSYSMOD.efftrajdel = max(efftrajdel);                               % for determining when to stop sampling

Status('done','');
Status2('done','',2);
Status2('done','',3);