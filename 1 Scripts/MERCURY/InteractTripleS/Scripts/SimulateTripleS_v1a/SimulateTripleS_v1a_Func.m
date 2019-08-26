%=========================================================
% 
%=========================================================

function [STUDY,err] = SimulateTripleS_v1a_Func(STUDY,INPUT)

Status('busy','Simulate TripleS');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SIM = INPUT.SIM;
PLOT = INPUT.PLOT;
OUT = INPUT.OUT;
clear INPUT

%---------------------------------------------
% TripleS GblAPP
%---------------------------------------------
global GblAPP
if not(isvalid(GblAPP))
    GblAPP = TripleS_2018_App;
end

%---------------------------------------------------
% Get Models for Saving
%---------------------------------------------------
for n = 1:3
    ModChar = num2str(n);
    SavedModel(n).Name = GblAPP.(['SDModel',ModChar]).Value;
    SavedModel(n).J0 = GblAPP.(['J0',ModChar]).Value;
    SavedModel(n).J1 = GblAPP.(['J1',ModChar]).Value;
    SavedModel(n).J2 = GblAPP.(['J2',ModChar]).Value;
    SavedModel(n).dist = GblAPP.(['dist',ModChar]).Value;
    SavedModel(n).p1 = GblAPP.(['p1',ModChar]).Value;
    SavedModel(n).p2 = GblAPP.(['p2',ModChar]).Value;
    SavedModel(n).nave = GblAPP.(['nave',ModChar]).Value;
end
STUDY.SavedModelTripleS = SavedModel;

%---------------------------------------------------
% Get Sequence for Saving
%---------------------------------------------------
for n = 1:12
    SeqElmChar = num2str(n,'%02.0f');
    SavedSeq.Type{n} = GblAPP.(['type',SeqElmChar]).Value;
    SavedSeq.Dur{n} = str2double(GblAPP.(['length',SeqElmChar]).Value);
    SavedSeq.RFShape{n} = GblAPP.(['shape',SeqElmChar]).Value;
    SavedSeq.Flip{n} = str2double(GblAPP.(['idealflip',SeqElmChar]).Value);
    SavedSeq.Phase{n} = str2double(GblAPP.(['phase',SeqElmChar]).Value);
    SavedSeq.Grad{n} = str2double(GblAPP.(['grads',SeqElmChar]).Value);
    SavedSeq.PhaseCyc{n} = str2double(GblAPP.(['pphasecyc',SeqElmChar]).Value);
    SavedSeq.Step{n} = str2double(GblAPP.(['step',SeqElmChar]).Value);
    SavedSeq.Seg = GblAPP.segmentsequence.Value;
end   
STUDY.SavedSeqTripleS = SavedSeq;

%---------------------------------------------
% Build Experiment
%---------------------------------------------
func = str2func([SIM.method,'_Func']);  
INPUT.APP = GblAPP;
[SIM,err] = func(SIM,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Plot Data
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);  
INPUT.APP = GblAPP;
INPUT.SIM = SIM;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
if isfield(PLOT,'Figure')
    STUDY.Figure{1} = PLOT.Figure;
end

%---------------------------------------------
% Output Data
%---------------------------------------------
func = str2func([OUT.method,'_Func']);  
INPUT.APP = GblAPP;
INPUT.SIM = SIM;
[OUT,err] = func(OUT,INPUT);
if err.flag
    return
end

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Study',STUDY.method,'Output'};
STUDY.Panel = [Panel;SIM.Panel;PLOT.Panel;OUT.Panel];
STUDY.PanelOutput = cell2struct(STUDY.Panel,{'label','value','type'},2);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
