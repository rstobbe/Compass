%====================================================
% 
%====================================================

function [GMAG,err] = GradMagMeas_v1a_Func(GMAG,INPUT)

Status2('busy','Calculate Gradient Magnitude',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
FEVOL = INPUT.FEVOL;
clear INPUT

%---------------------------------------------
% Load Input
%---------------------------------------------
PL_Fid1 = mean(FEVOL.PL_Fid1,1);
PL_Fid2 = mean(FEVOL.PL_Fid2,1);
BG_Fid1 = mean(FEVOL.BG_Fid1,1);
BG_Fid2 = mean(FEVOL.BG_Fid2,1);

%-------------------------------------
% PosLoc Data
%-------------------------------------
PL_expT = FEVOL.PL_Params.dwell*(0:1:FEVOL.PL_Params.np-1) + 0.5*FEVOL.PL_Params.dwell;           % puts difference value at centre of interval
[PL_PH1,PL_PH2,PL_PH1steps,PL_PH2steps] = PhaseEvolution_v2b(PL_Fid1,PL_Fid2);
[PL_Bloc1,PL_Bloc2] = FieldEvolution_v2a(PL_PH1,PL_PH2,PL_expT);
PL_ind1 = find(PL_expT>GMAG.plstart,1,'first');
PL_ind2 = find(PL_expT>GMAG.plstop,1,'first'); 

%-------------------------------------
% Load NoGradient Data
%-------------------------------------
BG_expT = FEVOL.BG_Params.dwell*(0:1:FEVOL.BG_Params.np-1) + 0.5*FEVOL.BG_Params.dwell;           % puts difference value at centre of interval
[BG_PH1,BG_PH2,BG_PH1steps,BG_PH2steps] = PhaseEvolution_v2b(BG_Fid1,BG_Fid2);
[BG_Bloc1,BG_Bloc2] = FieldEvolution_v2a(BG_PH1,BG_PH2,BG_expT);  
BG_ind1 = find(BG_expT>GMAG.bgstart,1,'first');
BG_ind2 = find(BG_expT>GMAG.bgstop,1,'first');
if isempty(BG_ind2)
    BG_ind2 = length(BG_expT);
end

%-------------------------------------
% Deternime Gradient Magnitude
%------------------------------------- 
gval = (mean(PL_Bloc2(PL_ind1:PL_ind2)) - mean(PL_Bloc1(PL_ind1:PL_ind2)))/(GMAG.sep/100); 
gvalbg = (mean(BG_Bloc2(BG_ind1:BG_ind2)) - mean(BG_Bloc1(BG_ind1:BG_ind2)))/(GMAG.sep/100);
gmag = abs(gval-gvalbg);
gmagbg = abs(gvalbg);

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

%---------------------------------------------
% Returned
%---------------------------------------------
ExpDisp.PL_ExpDisp = [];
ExpDisp.BG_ExpDisp = [];
GMAG.ExpDisp = ExpDisp;
GMAG.BG_expT = BG_expT;
GMAG.PL_Params = FEVOL.PL_Params;
GMAG.BG_Params = FEVOL.BG_Params;
GMAG.Data.PL_expT = PL_expT;
GMAG.Data.BG_expT = BG_expT;
GMAG.Data.PL_Fid1 = PL_Fid1;
GMAG.Data.PL_Fid2 = PL_Fid2;
GMAG.Data.BG_Fid1 = BG_Fid1;
GMAG.Data.BG_Fid2 = BG_Fid2;
GMAG.Data.PL_PH1 = PL_PH1;
GMAG.Data.PL_PH2 = PL_PH2;
GMAG.Data.BG_PH1 = BG_PH1;
GMAG.Data.BG_PH2 = BG_PH2;
GMAG.Data.PL_Bloc1 = PL_Bloc1;
GMAG.Data.PL_Bloc2 = PL_Bloc2;
GMAG.Data.BG_Bloc1 = BG_Bloc1;
GMAG.Data.BG_Bloc2 = BG_Bloc2;
GMAG.Data.maxPL_PH1step = maxPL_PH1step;
GMAG.Data.maxPL_PH2step = maxPL_PH2step;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Gradient Measured (mT/m)',gmag,'Output'};
Panel(2,:) = {'Gradient Param (mT/m)',FEVOL.PL_Params.gval,'Output'};
Panel(3,:) = {'Background Gradient (uT/m)',gmagbg,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GMAG.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);


