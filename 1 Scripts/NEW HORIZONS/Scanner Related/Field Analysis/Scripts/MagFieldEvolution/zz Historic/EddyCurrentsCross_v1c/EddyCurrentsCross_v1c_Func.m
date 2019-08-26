%====================================================
%
%====================================================

function [EDDY,err] = EddyCurrentsCross_v1c_Func(EDDY,INPUT)

Status('busy','Determine Cross Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PBG1 = INPUT.PBG1;
TF = INPUT.TF;
clear INPUT

%-----------------------------------------------------
% Determine Primary Probe Displacement and BackGround Fields
%-----------------------------------------------------
func = str2func([EDDY.psbgfunc,'_Func']);
INPUT.Sys = EDDY.Sys;
[PBG1,err] = func(PBG1,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Determine Transient Fields
%-----------------------------------------------------
func = str2func([EDDY.tffunc,'_Func']);
INPUT.Sys = EDDY.Sys;
INPUT.POSBG = PBG1.OUTPUT;
[TF,err] = func(TF,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Locations
%-----------------------------------------------------
EDDY.Loc12_1A = PBG1.OUTPUT(1).Loc1;
EDDY.Loc12_2A = PBG1.OUTPUT(1).Loc2;
EDDY.Loc12_1B = PBG1.OUTPUT(2).Loc1;
EDDY.Loc12_2B = PBG1.OUTPUT(2).Loc2;
EDDY.LocAB_1A = PBG1.OUTPUT(3).Loc1;
EDDY.LocAB_1B = PBG1.OUTPUT(3).Loc2;
EDDY.LocAB_2A = PBG1.OUTPUT(4).Loc1;
EDDY.LocAB_2B = PBG1.OUTPUT(4).Loc2;
EDDY.Sep12_A = PBG1.OUTPUT(1).Sep;
EDDY.Sep12_B = PBG1.OUTPUT(2).Sep;
EDDY.SepAB_1 = PBG1.OUTPUT(3).Sep;
EDDY.SepAB_2 = PBG1.OUTPUT(4).Sep;

%-----------------------------------------------------
% Transient Fields
%-----------------------------------------------------
EDDY.Time = TF.OUTPUT(1).Time;
EDDY.G12m12_A = TF.OUTPUT(1).Geddy;
EDDY.G12m12_B = TF.OUTPUT(2).Geddy;
EDDY.GABmAB_1 = TF.OUTPUT(3).Geddy;
EDDY.GABmAB_2 = TF.OUTPUT(4).Geddy;
EDDY.GABm12_A = TF.OUTPUT(5).Geddy;
EDDY.GABm12_B = TF.OUTPUT(6).Geddy;
EDDY.G12mAB_1 = TF.OUTPUT(7).Geddy;
EDDY.G12mAB_2 = TF.OUTPUT(8).Geddy;
EDDY.B012m12_A = TF.OUTPUT(1).B0eddy;
EDDY.B012m12_B = TF.OUTPUT(2).B0eddy;
EDDY.B0ABmAB_1 = TF.OUTPUT(3).B0eddy;
EDDY.B0ABmAB_2 = TF.OUTPUT(4).B0eddy;
EDDY.B0ABm12_A = TF.OUTPUT(5).B0eddy;
EDDY.B0ABm12_B = TF.OUTPUT(6).B0eddy;
EDDY.B012mAB_1 = TF.OUTPUT(7).B0eddy;
EDDY.B012mAB_2 = TF.OUTPUT(8).B0eddy;

%-----------------------------------------------------
% Cross Gradient Contribution to B0
%-----------------------------------------------------
G12cAB = EDDY.G12mAB_1/EDDY.Loc12_1A;
GABc12 = EDDY.GABm12_A;

figure(1000); hold on; 
plot([0 max(EDDY.Time)],[0 0],'k:'); 
plot(EDDY.Time,G12cAB,'b-');
plot(EDDY.Time,GABc12,'r-');

%ylim([-max(abs(Geddy1)) max(abs(Geddy1))]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(EDDY.Time)]); title('Transient Field (Gradient)');

%-----------------------------------------------------
% Determine Cross Field (1)
%-----------------------------------------------------
MeanCrossSepAB = mean([PBG1.OUTPUT(3).Sep PBG1.OUTPUT(4).Sep]);
B0eddyA = TF.OUTPUT(1).B0eddy;
B0eddyB = TF.OUTPUT(2).B0eddy;
GeddyCrossAB = (B0eddyB - B0eddyA)/MeanCrossSepAB;

%-----------------------------------------------------
% Determine Cross Field (1)
%-----------------------------------------------------
MeanCrossSep12 = mean([PBG1.OUTPUT(1).Sep PBG1.OUTPUT(2).Sep]);
B0eddy1 = TF.OUTPUT(3).B0eddy;
B0eddy2 = TF.OUTPUT(4).B0eddy;
GeddyCross12 = (B0eddy2 - B0eddy1)/MeanCrossSep12;

%-----------------------------------------------------
% Remnant B0
%-----------------------------------------------------
EDDY.B0eddyRem12a = B0eddyA - GeddyCrossAB*PBG1.OUTPUT(4).Loc1;                % with 12 gradient
EDDY.B0eddyRem12b = B0eddyB - GeddyCrossAB*PBG1.OUTPUT(4).Loc2;

EDDY.B0eddyRemAB1 = B0eddy1 - GeddyCross12*PBG1.OUTPUT(1).Loc1;                % with AB gradient
EDDY.B0eddyRemAB2 = B0eddy2 - GeddyCross12*PBG1.OUTPUT(1).Loc2;

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
StudyDisp = TF.OUTPUT(1).ExpDisp.TF_ExpDisp.StudyDisp;
PosLocDisp = PBG1.OUTPUT(1).ExpDisp.PL_ExpDisp.ParamsDisp;
NoGradDisp = PBG1.OUTPUT(1).ExpDisp.BG_ExpDisp.ParamsDisp;
TFDisp = TF.OUTPUT(1).ExpDisp.TF_ExpDisp.ParamsDisp;
PLoutput = PanelStruct2Text(PBG1.PanelOutput);
EDDY.ExpDisp = [StudyDisp PosLocDisp char(10) NoGradDisp char(10) TFDisp PLoutput];

%--------------------------------------------
% Output Structure
%--------------------------------------------
EDDY.Loc1A = PBG1.OUTPUT(1).Loc1;
EDDY.Loc2A = PBG1.OUTPUT(1).Loc2;
EDDY.Loc1B = PBG1.OUTPUT(2).Loc1;
EDDY.Loc2B = PBG1.OUTPUT(2).Loc2;
EDDY.SepA = PBG1.OUTPUT(1).Sep;
EDDY.SepB = PBG1.OUTPUT(2).Sep;
EDDY.LocA1 = PBG1.OUTPUT(3).Loc1;
EDDY.LocB1 = PBG1.OUTPUT(3).Loc2;
EDDY.LocA2 = PBG1.OUTPUT(4).Loc1;
EDDY.LocB2 = PBG1.OUTPUT(4).Loc2;
EDDY.Sep1 = PBG1.OUTPUT(3).Sep;
EDDY.Sep2 = PBG1.OUTPUT(4).Sep;

EDDY.MeanCrossSepAB = MeanCrossSepAB;
EDDY.MeanCrossSep12 = MeanCrossSep12;

EDDY.Time = TF.OUTPUT(1).Time;
EDDY.Geddy12m12_A = TF.OUTPUT(1).Geddy;
EDDY.Geddy12m12_B = TF.OUTPUT(2).Geddy;
EDDY.GeddyABmAB_1 = TF.OUTPUT(3).Geddy;
EDDY.GeddyABmAB_2 = TF.OUTPUT(4).Geddy;
EDDY.GeddyABm12_A = TF.OUTPUT(5).Geddy;
EDDY.GeddyABm12_B = TF.OUTPUT(6).Geddy;
EDDY.Geddy12mAB_1 = TF.OUTPUT(7).Geddy;
EDDY.Geddy12mAB_2 = TF.OUTPUT(8).Geddy;
EDDY.B0eddy12m12_A = TF.OUTPUT(1).B0eddy;
EDDY.B0eddy12m12_B = TF.OUTPUT(2).B0eddy;
EDDY.B0eddyABmAB_1 = TF.OUTPUT(3).B0eddy;
EDDY.B0eddyABmAB_2 = TF.OUTPUT(4).B0eddy;
EDDY.B0eddyABm12_A = TF.OUTPUT(5).B0eddy;
EDDY.B0eddyABm12_B = TF.OUTPUT(6).B0eddy;
EDDY.B0eddy12mAB_1 = TF.OUTPUT(7).B0eddy;
EDDY.B0eddy12mAB_2 = TF.OUTPUT(8).B0eddy;
EDDY.GeddyCrossAB = GeddyCrossAB;
EDDY.GeddyCross12 = GeddyCross12;
EDDY.POSBG = PBG1;
EDDY.TF = TF;


Status('done','');
Status2('done','',2);
Status2('done','',3);
