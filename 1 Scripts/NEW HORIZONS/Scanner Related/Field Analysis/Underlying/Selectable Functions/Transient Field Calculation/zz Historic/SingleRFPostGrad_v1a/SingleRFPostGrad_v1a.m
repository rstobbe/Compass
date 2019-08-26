%====================================================
% (v1a)
%  
%====================================================

function [SCRPTipt,TFout,err] = SingleRFPostGrad_v1a(SCRPTipt,TF)

Status('busy','Calculate Transient Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

TFout = struct();
CallingLabel = 'TransientFieldfunc';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(TF,[CallingLabel,'_Data']))
    if isfield(TF.('File_Grad1_Data').Struct,'selectedfile')
        file = TF.('File_Grad1_Data').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad1';
            ErrDisp(err);
            return
        else
            load(file);
            TF.([CallingLabel,'_Data']).('File_Grad1_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad1';
        ErrDisp(err);
        return
    end
end
if not(isfield(TF,[CallingLabel,'_Data']))
    if isfield(TF.('File_Grad2_Data').Struct,'selectedfile')
        file = TF.('File_Grad2_Data').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad2';
            ErrDisp(err);
            return
        else
            load(file);
            TF.([CallingLabel,'_Data']).('File_Grad2_Data') = saveData;
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
FileGrad1 = TF.([CallingLabel,'_Data']).File_Grad1_Data.path;
FileGrad2 = TF.([CallingLabel,'_Data']).File_Grad2_Data.path;
gstart = str2double(TF.Gstart);
gstop = str2double(TF.Gstop);
Sys = TF.EDDY.Sys;
POSBG = TF.POSGB;

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
ExpDisp = [];
[TF_Fid1,TF_Fid2,TF_expT,TF_Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3a(FileGrad1,FileGrad2,'Transient',Sys,'PostGradEddySingle_v1a',ExpDisp);
if errorflag == 1
    err.flag = 1;
    err.msg = error;
    return
end
[TF_PH1,TF_PH2] = PhaseEvolution_v2a(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);
BG_smthBloc1 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc1,TF_expT);
BG_smthBloc2 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc2,TF_expT);
%BG_smthBloc1 = zeros(size(TF_expT));
%BG_smthBloc2 = zeros(size(TF_expT));

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
ind1 = find(TF_expT>gstart,1,'first');
ind2 = find(TF_expT>gstop,1,'first');
TF_B0_Joined = NaN*zeros(nexp,1000*TF_Params.gofftime(nexp)/TF_Params.dwell+ind2);
TF_Grad_Joined = NaN*zeros(size(TF_B0_Joined));
for n = 1:nexp 
    start = 1000*TF_Params.gofftime(n)/TF_Params.dwell + ind1;
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

do = 0;
if do == 1
    %-------------------------------------
    % Filter
    %-------------------------------------
    ind = find(isnan(TF_Grad_Ave),1,'last');
    TF_Grad_Ave2 = TF_Grad_Ave(ind+1:length(TF_Grad_Ave));
    func = str2func(filtGfunc);
    [Gfilt,SCRPTipt] = func(TF_Grad_Ave2,TF_Params,SCRPTipt);
    TF_Grad_Ave_Filt = [zeros(1,ind) Gfilt];
    figure(1); hold on;
    plot(TF_expT_Joined,TF_Grad_Ave*1000,'b','linewidth',2)
    plot(TF_expT_Joined,TF_Grad_Ave_Filt*1000,'r','linewidth',2)
    xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(TF_expT_Joined)]); title('Transient Field (Gradient)');

    TF_B0_Ave2 = TF_B0_Ave(ind+1:length(TF_B0_Ave));
    func = str2func(filtB0func);
    [Gfilt,SCRPTipt] = func(TF_B0_Ave2,TF_Params,SCRPTipt);
    TF_B0_Ave_Filt = [zeros(1,ind) Gfilt];
    figure(2); hold on;
    plot(TF_expT_Joined,TF_B0_Ave*1000,'b','linewidth',2)
    plot(TF_expT_Joined,TF_B0_Ave_Filt*1000,'r','linewidth',2)
    xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(TF_expT_Joined)]); title('Transient Field (B0)');
end
%-------------------------------------
% Returned
%-------------------------------------
TF.ExpDisp = ExpDisp;
TF.gval = TF_Params.gval;
TF.Time = gofftime*1000;
TF.Geddy = Geddy;
TF.B0eddy = B0eddy;
TF.Path = FileGrad1;
TF.Data.TF_Params = TF_Params;
TF.Data.TF_expT = TF_expT;
TF.Data.TF_Fid1 = TF_Fid1;
TF.Data.TF_Fid2 = TF_Fid2;
TF.Data.TF_PH1 = TF_PH1;
TF.Data.TF_PH2 = TF_PH2;
TF.Data.TF_Bloc1 = TF_Bloc1;
TF.Data.TF_Bloc2 = TF_Bloc2;
TF.Data.corTF_Bloc1 = corTF_Bloc1;
TF.Data.corTF_Bloc2 = corTF_Bloc2;
TF.Data.TF_Grad = TF_Grad;
TF.Data.TF_B01 = TF_B01;
TF.Data.TF_B02 = TF_B02;

SCRPTGBL.TF = TF;


