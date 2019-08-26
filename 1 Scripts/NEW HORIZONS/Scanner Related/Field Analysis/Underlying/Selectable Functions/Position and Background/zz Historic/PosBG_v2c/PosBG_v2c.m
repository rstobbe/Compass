%====================================================
% (v2c) 
%       - update Gloval handling
%====================================================

function [SCRPTipt,POSBGout,err] = PosBG_v2c(SCRPTipt,POSBG)

Status2('busy','Calculate Postition and Background Fields',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

POSBGout = struct();
CallingLabel = 'PosBgrndfunc';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(POSBG,[CallingLabel,'_Data']))
    if isfield(POSBG.('File_NoGrad1').Struct,'selectedfile')
        file = POSBG.('File_NoGrad1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad1';
            ErrDisp(err);
            return
        else
            POSBG.([CallingLabel,'_Data']).('File_NoGrad1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad1';
        ErrDisp(err);
        return
    end
    if isfield(POSBG.('File_NoGrad2').Struct,'selectedfile')
        file = POSBG.('File_NoGrad2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad2';
            ErrDisp(err);
            return
        else
            POSBG.([CallingLabel,'_Data']).('File_NoGrad2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad2';
        ErrDisp(err);
        return
    end
    if isfield(POSBG.('File_PosLoc1').Struct,'selectedfile')
        file = POSBG.('File_PosLoc1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc1';
            ErrDisp(err);
            return
        else
            POSBG.([CallingLabel,'_Data']).('File_PosLoc1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc1';
        ErrDisp(err);
        return
    end
    if isfield(POSBG.('File_PosLoc2').Struct,'selectedfile')
        file = POSBG.('File_PosLoc2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc2';
            ErrDisp(err);
            return
        else
            POSBG.([CallingLabel,'_Data']).('File_PosLoc2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc2';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
POSBGout.FilePosLoc1 = POSBG.([CallingLabel,'_Data']).File_PosLoc1_Data.path;
POSBGout.FilePosLoc2 = POSBG.([CallingLabel,'_Data']).File_PosLoc2_Data.path;
POSBGout.FileNoGrad1 = POSBG.([CallingLabel,'_Data']).File_NoGrad1_Data.path;
POSBGout.FileNoGrad2 = POSBG.([CallingLabel,'_Data']).File_NoGrad2_Data.path;
POSBGout.plstart = str2double(POSBG.PLstart);
POSBGout.plstop = str2double(POSBG.PLstop);
POSBGout.bgstart = str2double(POSBG.BGstart);
POSBGout.bgstop = str2double(POSBG.BGstop);
POSBGout.smthwin = str2double(POSBG.SmoothWinBG);

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
Sys = POSBG.EDDY.Sys;

%-------------------------------------
% Load PosLoc Data
%-------------------------------------
[PL_Fid1,PL_Fid2,PL_Params,PL_ExpDisp,err] = Load_2LocExperiment_v4a(POSBGout.FilePosLoc1,POSBGout.FilePosLoc2,'PosLoc_v1a',Sys);
if err.flag
    return
end
PL_expT = PL_Params.dwell*(0:1:PL_Params.np-1) + 0.5*PL_Params.dwell;           % puts difference value at centre of interval
[PL_PH1,PL_PH2,PL_PH1steps,PL_PH2steps] = PhaseEvolution_v2b(PL_Fid1,PL_Fid2);
[PL_Bloc1,PL_Bloc2] = FieldEvolution_v2a(PL_PH1,PL_PH2,PL_expT);
PL_ind1 = find(PL_expT>POSBGout.plstart,1,'first');
PL_ind2 = find(PL_expT>POSBGout.plstop,1,'first'); 

%-------------------------------------
% Load NoGradient Data
%-------------------------------------
[BG_Fid1,BG_Fid2,BG_Params,BG_ExpDisp,err] = Load_2LocExperiment_v4a(POSBGout.FileNoGrad1,POSBGout.FileNoGrad2,'NoGrad_v1a',Sys);
if err.flag
    return
end
BG_expT = BG_Params.dwell*(0:1:BG_Params.np-1) + 0.5*BG_Params.dwell;           % puts difference value at centre of interval
[BG_PH1,BG_PH2,BG_PH1steps,BG_PH2steps] = PhaseEvolution_v2b(BG_Fid1,BG_Fid2);
[BG_Bloc1,BG_Bloc2] = FieldEvolution_v2a(BG_PH1,BG_PH2,BG_expT);  
BG_ind1 = find(BG_expT>POSBGout.bgstart,1,'first');
BG_ind2 = find(BG_expT>POSBGout.bgstop,1,'first');

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
BG_smthBloc1 = smooth(BG_Bloc1,POSBGout.smthwin,'moving');
BG_smthBloc2 = smooth(BG_Bloc2,POSBGout.smthwin,'moving'); 

%---------------------------------------------
% Returned
%---------------------------------------------
ExpDisp.PL_ExpDisp = PL_ExpDisp;
ExpDisp.BG_ExpDisp = BG_ExpDisp;
POSBGout.ExpDisp = ExpDisp;
POSBGout.Loc1 = Loc1;
POSBGout.Loc2 = Loc2;
POSBGout.Sep = Sep;
POSBGout.meanBGGrad = meanBGGrad;
POSBGout.meanBGB0 = meanBGB0;
POSBGout.BG_expT = BG_expT;
POSBGout.BG_smthBloc1 = BG_smthBloc1;
POSBGout.BG_smthBloc2 = BG_smthBloc2; 
POSBGout.Data.PL_Params = PL_Params;
POSBGout.Data.BG_Params = BG_Params;
POSBGout.Data.PL_expT = PL_expT;
POSBGout.Data.BG_expT = BG_expT;
POSBGout.Data.PL_Fid1 = PL_Fid1;
POSBGout.Data.PL_Fid2 = PL_Fid2;
POSBGout.Data.BG_Fid1 = BG_Fid1;
POSBGout.Data.BG_Fid2 = BG_Fid2;
POSBGout.Data.PL_PH1 = PL_PH1;
POSBGout.Data.PL_PH2 = PL_PH2;
POSBGout.Data.BG_PH1 = BG_PH1;
POSBGout.Data.BG_PH2 = BG_PH2;
POSBGout.Data.PL_Bloc1 = PL_Bloc1;
POSBGout.Data.PL_Bloc2 = PL_Bloc2;
POSBGout.Data.BG_Bloc1 = BG_Bloc1;
POSBGout.Data.BG_Bloc2 = BG_Bloc2;
POSBGout.Data.PL_Grad = PL_Grad;
POSBGout.Data.PL_B01 = PL_B01;
POSBGout.Data.PL_B02 = PL_B02;
POSBGout.Data.BG_Grad = BG_Grad;
POSBGout.Data.BG_B01 = BG_B01;
POSBGout.Data.BG_B02 = BG_B02;
POSBGout.Data.maxPL_PH1step = maxPL_PH1step;
POSBGout.Data.maxPL_PH2step = maxPL_PH2step;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Loc1',Loc1,'Output'};
Panel(2,:) = {'Loc2',Loc2,'Output'};
Panel(3,:) = {'Sep',Sep,'Output'};
Panel(4,:) = {'meanBGGrad',meanBGGrad,'Output'};
Panel(5,:) = {'meanBGB0',meanBGB0,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
POSBGout.PanelOutput = PanelOutput;




