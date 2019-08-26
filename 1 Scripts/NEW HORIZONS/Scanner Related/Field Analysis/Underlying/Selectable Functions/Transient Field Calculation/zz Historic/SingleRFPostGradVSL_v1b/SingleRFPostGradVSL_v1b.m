%====================================================
% (v1b)
%       - add selection for timing start    
%====================================================

function [SCRPTipt,TFout,err] = SingleRFPostGradVSL_v1b(SCRPTipt,TF)

Status('busy','Calculate Transient Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

TFout = struct();
CallingLabel = TF.Struct.labelstr;

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(TF,[CallingLabel,'_Data']))
    if isfield(TF.('File_Grad1').Struct,'selectedfile')
        file = TF.('File_Grad1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad1';
            ErrDisp(err);
            return
        else
            TF.([CallingLabel,'_Data']).('File_Grad1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad1';
        ErrDisp(err);
        return
    end
    if isfield(TF.('File_Grad2').Struct,'selectedfile')
        file = TF.('File_Grad2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad2';
            ErrDisp(err);
            return
        else
            TF.([CallingLabel,'_Data']).('File_Grad2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad2';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
TFout.FileGrad1 = TF.([CallingLabel,'_Data']).('File_Grad1_Data').path;
TFout.FileGrad2 = TF.([CallingLabel,'_Data']).('File_Grad2_Data').path;
TFout.gstart = str2double(TF.Gstart);
TFout.gstop = str2double(TF.Gstop);
TFout.timestart = (TF.Timing_Start);

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
Sys = TF.EDDY.Sys;
POSBG = TF.POSBG;

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
[TF_Fid1,TF_Fid2,TF_Params,TF_ExpDisp,err] = Load_2LocExperiment_v4a(TFout.FileGrad1,TFout.FileGrad2,'SingleRFPostGradVSL_v1a',Sys);
if err.flag
    return
end
TF_expT = TF_Params.dwell*(0:1:TF_Params.np-1) + 0.5*TF_Params.dwell;           % puts difference value at centre of interval
[TF_PH1,TF_PH2] = PhaseEvolution_v2a(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);
BG_smthBloc1 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc1,TF_expT);
BG_smthBloc2 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc2,TF_expT);

%-------------------------------------
% Subtract background and separate
%-------------------------------------
[nexp,~,nacq] = size(TF_Fid1);
corTF_Bloc1 = zeros(size(TF_Fid1));
corTF_Bloc2 = zeros(size(TF_Fid1));
TF_Grad = zeros(size(TF_Fid1));
TF_B01 = zeros(size(TF_Fid1));
TF_B02 = zeros(size(TF_Fid1));
for n = 1:nexp
    for m = 1:nacq
        corTF_Bloc1(n,:,m) = TF_Bloc1(n,:,m) - BG_smthBloc1;
        corTF_Bloc2(n,:,m) = TF_Bloc2(n,:,m) - BG_smthBloc2;
        TF_Grad(n,:,m) = (corTF_Bloc2(n,:,m) - corTF_Bloc1(n,:,m))/POSBG.Sep;
        TF_B01(n,:,m) = corTF_Bloc1(n,:,m) - TF_Grad(n,:,m)*POSBG.Loc1;         % TF_B01 and TF_B02 should be identical
        TF_B02(n,:,m) = corTF_Bloc2(n,:,m) - TF_Grad(n,:,m)*POSBG.Loc2;
    end
end

%-------------------------------------
% Join
%-------------------------------------
ind1 = find(TF_expT>=TFout.gstart,1,'first');
ind2 = find(TF_expT>=TFout.gstop,1,'first');
TF_B0_Joined = NaN*zeros(nexp,1000*TF_Params.initdels(nexp)/TF_Params.dwell+ind2);
TF_Grad_Joined = NaN*zeros(size(TF_B0_Joined));
for n = 1:nexp 
    start = 1000*TF_Params.initdels(n)/TF_Params.dwell + ind1;
    TF_B0_Joined(n,start:start+ind2-ind1) = TF_B01(n,ind1:ind2);
    TF_Grad_Joined(n,start:start+ind2-ind1) = TF_Grad(n,ind1:ind2);
end
for m = 1:length(TF_B0_Joined)
    totB = 0;
    totG = 0;
    vals = 0;
    for n = 1:nexp
        if not(isnan(TF_B0_Joined(n,m)))
            totB = totB + TF_B0_Joined(n,m);
            totG = totG + TF_Grad_Joined(n,m);
            vals = vals + 1;
        end
    end
    if vals == 0
        TF_B0_Ave(m) = NaN;
        TF_Grad_Ave(m) = NaN;
    else
        TF_B0_Ave(m) = totB/vals;
        TF_Grad_Ave(m) = totG/vals;
    end
end
TF_expT_Joined = (0:TF_Params.dwell:TF_Params.dwell*(length(TF_B0_Joined)-1));

%-------------------------------------
% Add Additional times
%-------------------------------------
TF_expT_Joined = TF_expT_Joined + TF_Params.seqtime/1000;
if strcmp(TFout.timestart,'Middle of Fall');
    TF_expT_Joined = TF_expT_Joined + TF_Params.falltime/2000;
end

%-------------------------------------
% Returned
%-------------------------------------
ExpDisp.TF_ExpDisp = TF_ExpDisp;
TFout.ExpDisp = ExpDisp;
TFout.gval = TF_Params.gval;
TFout.Time = TF_expT_Joined;
TFout.Geddy = TF_Grad_Ave;
TFout.B0eddy = TF_B0_Ave;
TFout.Data.TF_Params = TF_Params;
TFout.Data.TF_expT = TF_expT;
TFout.Data.TF_Fid1 = TF_Fid1;
TFout.Data.TF_Fid2 = TF_Fid2;
TFout.Data.TF_PH1 = TF_PH1;
TFout.Data.TF_PH2 = TF_PH2;
TFout.Data.TF_Bloc1 = TF_Bloc1;
TFout.Data.TF_Bloc2 = TF_Bloc2;
TFout.Data.corTF_Bloc1 = corTF_Bloc1;
TFout.Data.corTF_Bloc2 = corTF_Bloc2;
TFout.Data.TF_Grad = TF_Grad;
TFout.Data.TF_B01 = TF_B01;
TFout.Data.TF_B02 = TF_B02;


