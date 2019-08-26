%====================================================
% 
%====================================================

function [POSBG,err] = PosBGdouble_v2e_Func(POSBG,INPUT)

Status2('busy','Calculate Postition and Background Fields',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
Sys = INPUT.Sys;
clear INPUT

%---------------------------------------------
% Calculate
%--------------------------------------------- 
OUTPUT(1) = CalcPosBG(POSBG,Sys,'a');
OUTPUT(2) = CalcPosBG(POSBG,Sys,'b');

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Loc1_A (cm)',OUTPUT(1).Loc1*100,'Output'};
Panel(2,:) = {'Loc2_A (cm)',OUTPUT(1).Loc2*100,'Output'};
Panel(3,:) = {'Sep_A (cm)',OUTPUT(1).Sep*100,'Output'};
Panel(4,:) = {'meanBGGrad_A (uT/m)',OUTPUT(1).meanBGGrad*1000,'Output'};
Panel(5,:) = {'meanBGB0_A (uT)',OUTPUT(1).meanBGB0*1000,'Output'};
Panel(6,:) = {'Loc1_B (cm)',OUTPUT(2).Loc1*100,'Output'};
Panel(7,:) = {'Loc2_B (cm)',OUTPUT(2).Loc2*100,'Output'};
Panel(8,:) = {'Sep_B (cm)',OUTPUT(2).Sep*100,'Output'};
Panel(9,:) = {'meanBGGrad_B (uT/m)',OUTPUT(2).meanBGGrad*1000,'Output'};
Panel(10,:) = {'meanBGB0_B (uT)',OUTPUT(2).meanBGB0*1000,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
POSBG.PanelOutput = PanelOutput;
POSBG.OUTPUT = OUTPUT;

%====================================================
% Calculate
%====================================================
function OUTPUT = CalcPosBG(POSBG,Sys,Case)

%-------------------------------------
% Load PosLoc Data
%-------------------------------------
[PL_Fid1,PL_Fid2,PL_Params,PL_ExpDisp,err] = Load_2LocExperiment_v4b(POSBG.(['FilePosLoc1',Case]),POSBG.(['FilePosLoc2',Case]),'PosLoc_v1a',Sys);
if err.flag
    return
end
PL_expT = PL_Params.dwell*(0:1:PL_Params.np-1) + 0.5*PL_Params.dwell;           % puts difference value at centre of interval
[PL_PH1,PL_PH2,PL_PH1steps,PL_PH2steps] = PhaseEvolution_v2b(PL_Fid1,PL_Fid2);
[PL_Bloc1,PL_Bloc2] = FieldEvolution_v2a(PL_PH1,PL_PH2,PL_expT);
PL_ind1 = find(PL_expT>POSBG.plstart,1,'first');
PL_ind2 = find(PL_expT>POSBG.plstop,1,'first'); 

%-------------------------------------
% Load NoGradient Data
%-------------------------------------
[BG_Fid1,BG_Fid2,BG_Params,BG_ExpDisp,err] = Load_2LocExperiment_v4b(POSBG.(['FileNoGrad1',Case]),POSBG.(['FileNoGrad2',Case]),'NoGrad_v1a',Sys);
if err.flag
    return
end
BG_expT = BG_Params.dwell*(0:1:BG_Params.np-1) + 0.5*BG_Params.dwell;           % puts difference value at centre of interval
[BG_PH1,BG_PH2,BG_PH1steps,BG_PH2steps] = PhaseEvolution_v2b(BG_Fid1,BG_Fid2);
[BG_Bloc1,BG_Bloc2] = FieldEvolution_v2a(BG_PH1,BG_PH2,BG_expT);  
BG_ind1 = find(BG_expT>POSBG.bgstart,1,'first');
BG_ind2 = find(BG_expT>POSBG.bgstop,1,'first');
if isempty(BG_ind2)
    BG_ind2 = length(BG_expT);
end

meanBGGrad = 0;
for w = 1:2
    %-------------------------------------
    % Deternime Position
    %-------------------------------------
    glocval = PL_Params.gval + meanBGGrad;
    Loc1 = mean(PL_Bloc1(PL_ind1:PL_ind2))/glocval;
    Loc2 = mean(PL_Bloc2(PL_ind1:PL_ind2))/glocval;
    Sep = Loc2 - Loc1;

    %-------------------------------------
    % Determine Background Fields
    %-------------------------------------    
    BG_Grad = (BG_Bloc2 - BG_Bloc1)/Sep;
    BG_B01 = BG_Bloc1 - BG_Grad*Loc1;
    BG_B02 = BG_Bloc2 - BG_Grad*Loc2;        
    meanBGGrad = mean(BG_Grad(BG_ind1:BG_ind2));
    meanBGB0 = mean([BG_B01(BG_ind1:BG_ind2) BG_B02(BG_ind1:BG_ind2)]);    
end

%-------------------------------------
% For Plotting
%-------------------------------------
PL_Grad = (PL_Bloc2 - PL_Bloc1)/Sep;
PL_B01 = PL_Bloc1 - PL_Grad*Loc1;         
PL_B02 = PL_Bloc2 - PL_Grad*Loc2;

%-------------------------------------
% Determine Max Phase in Averaged Regions
%-------------------------------------
PL_PH1steps = PL_PH1steps(PL_ind1:PL_ind2);
PL_PH2steps = PL_PH2steps(PL_ind1:PL_ind2);
maxPL_PH1step = max(abs(PL_PH1steps));
maxPL_PH2step = max(abs(PL_PH2steps));
if maxPL_PH1step > 2.75 || maxPL_PH2step > 2.75
    figure(100); hold on;
    plot(PL_expT(PL_ind1:PL_ind2),PL_PH1steps,'r'); 
    plot(PL_expT(PL_ind1:PL_ind2),PL_PH2steps,'b');
    err.flag = 1;
    err.msg = 'Probable error with probe displacement - increase sampling rate';
    return
end

%-------------------------------------
% Smooth BG fields
%-------------------------------------
Bloc1temp = NaN*ones(size(BG_Bloc1));
Bloc1temp(BG_ind1:BG_ind2) = BG_Bloc1(BG_ind1:BG_ind2);
Bloc2temp = NaN*ones(size(BG_Bloc2));
Bloc2temp(BG_ind1:BG_ind2) = BG_Bloc2(BG_ind1:BG_ind2);
BG_smthBloc1 = smooth(Bloc1temp,POSBG.smthwin,'moving');
BG_smthBloc2 = smooth(Bloc2temp,POSBG.smthwin,'moving');

%---------------------------------------------
% Returned
%---------------------------------------------
ExpDisp.PL_ExpDisp = PL_ExpDisp;
ExpDisp.BG_ExpDisp = BG_ExpDisp;
OUTPUT.ExpDisp = ExpDisp;
OUTPUT.Loc1 = Loc1;
OUTPUT.Loc2 = Loc2;
OUTPUT.Sep = Sep;
OUTPUT.meanBGGrad = meanBGGrad;
OUTPUT.meanBGB0 = meanBGB0;
OUTPUT.BG_expT = BG_expT;
OUTPUT.BG_smthBloc1 = BG_smthBloc1;
OUTPUT.BG_smthBloc2 = BG_smthBloc2; 
OUTPUT.PL_Params = PL_Params;
OUTPUT.BG_Params = BG_Params;
OUTPUT.Data.PL_expT = PL_expT;
OUTPUT.Data.BG_expT = BG_expT;
OUTPUT.Data.PL_Fid1 = PL_Fid1;
OUTPUT.Data.PL_Fid2 = PL_Fid2;
OUTPUT.Data.BG_Fid1 = BG_Fid1;
OUTPUT.Data.BG_Fid2 = BG_Fid2;
OUTPUT.Data.PL_PH1 = PL_PH1;
OUTPUT.Data.PL_PH2 = PL_PH2;
OUTPUT.Data.BG_PH1 = BG_PH1;
OUTPUT.Data.BG_PH2 = BG_PH2;
OUTPUT.Data.PL_Bloc1 = PL_Bloc1;
OUTPUT.Data.PL_Bloc2 = PL_Bloc2;
OUTPUT.Data.BG_Bloc1 = BG_Bloc1;
OUTPUT.Data.BG_Bloc2 = BG_Bloc2;
OUTPUT.Data.PL_Grad = PL_Grad;
OUTPUT.Data.PL_B01 = PL_B01;
OUTPUT.Data.PL_B02 = PL_B02;
OUTPUT.Data.BG_Grad = BG_Grad;
OUTPUT.Data.BG_B01 = BG_B01;
OUTPUT.Data.BG_B02 = BG_B02;
OUTPUT.Data.maxPL_PH1step = maxPL_PH1step;
OUTPUT.Data.maxPL_PH2step = maxPL_PH2step;




Status2('done','',2);
Status2('done','',3);


