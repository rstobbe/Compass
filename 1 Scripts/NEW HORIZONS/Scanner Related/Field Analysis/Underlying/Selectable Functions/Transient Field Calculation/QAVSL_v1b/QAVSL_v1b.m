%====================================================
% (v1b)
%       - add selection for timing start    
%====================================================

function [SCRPTipt,TFout,err] = QAVSL_v1b(SCRPTipt,TF)

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
[TF_Fid1,TF_Fid2,TF_Params,TF_ExpDisp,err] = Load_2LocExperiment_v4a(TFout.FileGrad1,TFout.FileGrad2,'MultiRFPostGradVSL_v1a',Sys);
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
ind1 = find(TF_expT>TFout.gstart,1,'first');
ind2 = find(TF_expT>TFout.gstop,1,'first');
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
        mean_TF_Grad(n,m) = mean(TF_Grad(n,ind1:ind2,m));
        mean_TF_B01(n,m) = mean(TF_B01(n,ind1:ind2,m));
        mean_TF_B02(n,m) = mean(TF_B02(n,ind1:ind2,m));
    end
end

%-------------------------------------
% Join Longs
%-------------------------------------
gofftime0 = TF_Params.initdels + TF_Params.seqtime/1e6;
if strcmp(TFout.timestart,'Middle of Fall');
    gofftime0 = gofftime0 + TF_Params.falltime/2e6;
end
gofftimeL = gofftime0 + (TFout.gstop+TFout.gstart)/2000;
LongB0eddy = zeros(1,nacq*nexp);
LongGeddy = zeros(1,nacq*nexp);
LongEddyTime = zeros(1,nacq*nexp);
for n = 1:nexp
    for m = 1:nacq
        LongEddyTime((m-1)*nexp+n) = gofftimeL(n,m);
        LongGeddy((m-1)*nexp+n) =  mean_TF_Grad(n,m);
        LongB0eddy((m-1)*nexp+n) = mean_TF_B01(n,m);
    end
end

%-------------------------------------
% Join Short
%-------------------------------------
ShortB0eddy = NaN*zeros(nexp,1000*TF_Params.initdels(nexp,1)/TF_Params.dwell+ind2);
ShortGeddy = NaN*zeros(size(ShortB0eddy));
for n = 1:nexp 
    start = 1000*TF_Params.initdels(n)/TF_Params.dwell + ind1;
    ShortB0eddy(n,start:start+ind2-ind1) = TF_B01(n,ind1:ind2);
    ShortGeddy(n,start:start+ind2-ind1) = TF_Grad(n,ind1:ind2);
end
ShortB0eddyAve = zeros(1,length(ShortB0eddy));
ShortGeddyAve = zeros(1,length(ShortGeddy));
for m = 1:length(ShortB0eddy)
    totB = 0;
    totG = 0;
    vals = 0;
    for n = 1:nexp
        if not(isnan(ShortB0eddy(n,m)))
            totB = totB + ShortB0eddy(n,m);
            totG = totG + ShortGeddy(n,m);
            vals = vals + 1;
        end
    end
    if vals == 0
        ShortB0eddyAve(m) = NaN;
        ShortGeddyAve(m) = NaN;
    else
        ShortB0eddyAve(m) = totB/vals;
        ShortGeddyAve(m) = totG/vals;
    end
end
ShortEddyTime = (0:TF_Params.dwell:TF_Params.dwell*(length(ShortB0eddy)-1)) + TF_Params.seqtime/1000;
if strcmp(TFout.timestart,'Middle of Fall');
    ShortEddyTime = ShortEddyTime + TF_Params.falltime/2000;
end

%-------------------------------------
% Returned
%-------------------------------------
ExpDisp.TF_ExpDisp = TF_ExpDisp;
TFout.ExpDisp = ExpDisp;
TFout.gval = TF_Params.gval;
TFout.Time = LongEddyTime*1000;
TFout.Geddy = LongGeddy;
TFout.B0eddy = LongB0eddy;
TFout.LongEddyTime = LongEddyTime*1000;
TFout.LongGeddy = LongGeddy;
TFout.LongB0eddy = LongB0eddy;
TFout.ShortEddyTime = ShortEddyTime;
TFout.ShortGeddy = ShortGeddyAve;
TFout.ShortB0eddy = ShortB0eddyAve;
TFout.Params = TF_Params;
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


