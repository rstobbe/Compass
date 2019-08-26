%====================================================
% (v1a)
%           
%====================================================

function [SCRPTipt,TFout,err] = RFPreGrad_v1a(SCRPTipt,TF)

Status('busy','Calculate Magnetic Fields');
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
Sys = TF.EDDY.Sys;
POSBG = TF.POSBG;

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
[TF_Fid1,TF_Fid2,TF_Params,TF_ExpDisp,err] = Load_2LocExperiment_v4a(TFout.FileGrad1,TFout.FileGrad2,'RFPreSingleGrad_v1a',Sys);
if err.flag
    return
end
TF_expT = TF_Params.dwell*(0:1:TF_Params.np-1) + 0.5*TF_Params.dwell;           % puts difference value at centre of interval
[TF_PH1,TF_PH2,TF_PH1steps,TF_PH2steps] = PhaseEvolution_v2b(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);
BG_smthBloc1 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc1,TF_expT);
BG_smthBloc2 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc2,TF_expT);
corTF_Bloc1 = TF_Bloc1 - BG_smthBloc1;
corTF_Bloc2 = TF_Bloc2 - BG_smthBloc2;
TF_Grad = (corTF_Bloc2 - corTF_Bloc1)/POSBG.Sep;
TF_B01 = corTF_Bloc1 - TF_Grad*POSBG.Loc1;         % TF_B01 and TF_B02 should be identical
TF_B02 = corTF_Bloc2 - TF_Grad*POSBG.Loc2;

%-------------------------------------
% Determine Phase Steps
%-------------------------------------
TF_PH1steps = TF_PH1steps(1:length(TF_PH1steps)-1);
TF_PH2steps = TF_PH2steps(1:length(TF_PH2steps)-1);
%maxTF_PH1step = max(abs(TF_PH1steps));
%maxTF_PH2step = max(abs(TF_PH2steps));
%if maxTF_PH1step > 2.75 || maxTF_PH2step > 2.75
%    figure(100); hold on;
%    plot(TF_expT(1:length(TF_expT)-1),TF_PH1steps,'r'); 
%    plot(TF_expT(1:length(TF_expT)-1),TF_PH2steps,'b');
%    title('Phase Steps During Gradient');
%    err.flag = 1;
%    err.msg = 'Probable error with probe displacement - increase sampling rate';
%    return
%end

%-------------------------------------
% Returned
%-------------------------------------
ExpDisp.TF_ExpDisp = TF_ExpDisp;
TFout.ExpDisp = ExpDisp;
TFout.gval = TF_Params.gval;
TFout.Time = TF_expT;
TFout.Geddy = TF_Grad;
TFout.B0eddy = TF_B01;
TFout.Params = TF_Params;
TFout.Data.TF_expT = TF_expT;
TFout.Data.TF_Fid1 = TF_Fid1;
TFout.Data.TF_Fid2 = TF_Fid2;
TFout.Data.TF_PH1 = TF_PH1;
TFout.Data.TF_PH2 = TF_PH2;
TFout.Data.TF_PH1steps = TF_PH1steps;
TFout.Data.TF_PH2steps = TF_PH2steps;
TFout.Data.TF_Bloc1 = TF_Bloc1;
TFout.Data.TF_Bloc2 = TF_Bloc2;
TFout.Data.corTF_Bloc1 = corTF_Bloc1;
TFout.Data.corTF_Bloc2 = corTF_Bloc2;
TFout.Data.TF_Grad = TF_Grad;
TFout.Data.TF_B01 = TF_B01;
TFout.Data.TF_B02 = TF_B02;



