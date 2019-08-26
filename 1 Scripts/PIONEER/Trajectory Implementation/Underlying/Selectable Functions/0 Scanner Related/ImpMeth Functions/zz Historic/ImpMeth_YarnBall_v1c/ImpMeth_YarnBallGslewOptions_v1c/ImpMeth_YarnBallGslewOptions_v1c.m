%=====================================================
% (v1a)
%     
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_YarnBallGslewOptions_v1c(SCRPTipt,IMETHipt)

Status2('busy','Implement for Design Testing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMETH.method = IMETHipt.Func;
%IMETH.desoltimfunc = IMETHipt.('DeSolTimfunc').Func;
%IMETH.psmpfunc = IMETHipt.('ProjSampfunc').Func;
IMETH.tsmpfunc = IMETHipt.('TrajSampfunc').Func;
IMETH.imptypefunc = IMETHipt.('ImpTypefunc').Func;
IMETH.timadjfunc = IMETHipt.('TimingAdjustfunc').Func;
IMETH.tendfunc = IMETHipt.('TrajEndfunc').Func;
IMETH.orientfunc = IMETHipt.('Orientfunc').Func;
%IMETH.ksampfunc = IMETHipt.('kSampfunc').Func;
IMETH.vis = 'full';

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = IMETHipt.Struct.labelstr;
ORNTipt = IMETHipt.('Orientfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('Orientfunc_Data'))
        ORNTipt.Orientfunc_Data = IMETHipt.([CallingFunction,'_Data']).Orientfunc_Data;
    end
end
IMPTYPEipt = IMETHipt.('ImpTypefunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('ImpTypefunc_Data'))
        IMPTYPEipt.ImpTypefunc_Data = IMETHipt.([CallingFunction,'_Data']).ImpTypefunc_Data;
    end
end
% DESOLipt = IMETHipt.('DeSolTimfunc');
% if isfield(IMETHipt,([CallingFunction,'_Data']))
%     if isfield(IMETHipt.([CallingFunction,'_Data']),('DeSolTimfunc_Data'))
%         DESOLipt.DeSolTimfunc_Data = IMETHipt.([CallingFunction,'_Data']).DeSolTimfunc_Data;
%     end
% end
% PSMPipt = IMETHipt.('ProjSampfunc');
% if isfield(IMETHipt,([CallingFunction,'_Data']))
%     if isfield(IMETHipt.([CallingFunction,'_Data']),('ProjSampfunc_Data'))
%         PSMPipt.ProjSampfunc_Data = IMETHipt.([CallingFunction,'_Data']).ProjSampfunc_Data;
%     end
% end
TIMADJipt = IMETHipt.('TimingAdjustfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('TimingAdjustfunc_Data'))
        TIMADJipt.TimingAdjustfunc_Data = IMETHipt.([CallingFunction,'_Data']).TimingAdjustfunc_Data;
    end
end
TSMPipt = IMETHipt.('TrajSampfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('TrajSampfunc_Data'))
        TSMPipt.TrajSampfunc_Data = IMETHipt.([CallingFunction,'_Data']).TrajSampfunc_Data;
    end
end
TENDipt = IMETHipt.('TrajEndfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('TrajEndfunc_Data'))
        TENDipt.TrajEndfunc_Data = IMETHipt.([CallingFunction,'_Data']).TrajEndfunc_Data;
    end
end
% KSMPipt = IMETHipt.('kSampfunc');
% if isfield(IMETHipt,([CallingFunction,'_Data']))
%     if isfield(IMETHipt.([CallingFunction,'_Data']),('kSampfunc_Data'))
%         KSMPipt.kSampfunc_Data = IMETHipt.([CallingFunction,'_Data']).kSampfunc_Data;
%     end
% end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(IMETH.orientfunc);           
[SCRPTipt,ORNT,err] = func(SCRPTipt,ORNTipt);
if err.flag
    return
end
func = str2func(IMETH.imptypefunc);           
[SCRPTipt,IMPTYPE,err] = func(SCRPTipt,IMPTYPEipt);
if err.flag
    return
end
% func = str2func(IMETH.desoltimfunc);           
% [SCRPTipt,DESOL,err] = func(SCRPTipt,DESOLipt);
% if err.flag
%     return
% end
DESOL.method = 'DeSolTim_YarnBallLookupImp_v1e';
RADEV.method = 'RadSolEv_ForConstEvol_v1a';
DESOL.RADEV = RADEV;
% func = str2func(IMETH.psmpfunc);           
% [SCRPTipt,PSMP,err] = func(SCRPTipt,PSMPipt);
% if err.flag
%     return
% end
PSMP.method = 'ProjSamp_Wool_v1b';
func = str2func(IMETH.tsmpfunc);           
[SCRPTipt,TSMP,err] = func(SCRPTipt,TSMPipt);
if err.flag
    return
end
func = str2func(IMETH.timadjfunc);           
[SCRPTipt,TIMADJ,err] = func(SCRPTipt,TIMADJipt);
if err.flag
    return
end
func = str2func(IMETH.tendfunc);           
[SCRPTipt,TEND,err] = func(SCRPTipt,TENDipt);
if err.flag
    return
end
% func = str2func(IMETH.ksampfunc);           
% [SCRPTipt,KSMP,err] = func(SCRPTipt,KSMPipt);
% if err.flag
%     return
% end
KSMP.method = 'kSamp_Standard_v1c';

%------------------------------------------
% Other
%------------------------------------------
SOLFINTEST.method = 'SolFinTest_YarnBall_v1a';

%------------------------------------------
% Return
%------------------------------------------
IMETH.ORNT = ORNT;
IMETH.DESOL = DESOL;
IMETH.PSMP = PSMP;
IMETH.TSMP = TSMP;
IMETH.TIMADJ = TIMADJ;
IMETH.IMPTYPE = IMPTYPE;
IMETH.TEND = TEND;
IMETH.KSMP = KSMP;
IMETH.SOLFINTEST = SOLFINTEST;

Status2('done','',2);
Status2('done','',3);

