%=====================================================
% (v1a)
%     
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_YarnBallDefault_v1a(SCRPTipt,IMETHipt)

Status2('busy','Implement for Design Testing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMETH.method = IMETHipt.Func;
IMETH.orientfunc = IMETHipt.('Orientfunc').Func;
% IMETH.desoltimfunc = IMETHipt.('DeSolTimfunc').Func;
% IMETH.psmpfunc = IMETHipt.('ProjSampfunc').Func;
% IMETH.tsmpfunc = IMETHipt.('TrajSampfunc').Func;
% IMETH.radevfunc = IMETHipt.('RadSolEvfunc').Func;
% IMETH.accconstfunc = IMETHipt.('ConstEvolfunc').Func;
% IMETH.tendfunc = IMETHipt.('TrajEndfunc').Func;
% IMETH.sysrespfunc = IMETHipt.('SysRespfunc').Func;
% IMETH.ksampfunc = IMETHipt.('kSampfunc').Func;

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
% RADEVipt = IMETHipt.('RadSolEvfunc');
% if isfield(IMETHipt,([CallingFunction,'_Data']))
%     if isfield(IMETHipt.([CallingFunction,'_Data']),('RadSolEvfunc_Data'))
%         RADEVipt.RadSolEvfunc_Data = IMETHipt.([CallingFunction,'_Data']).RadSolEvfunc_Data;
%     end
% end
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
% CACCipt = IMETHipt.('ConstEvolfunc');
% if isfield(IMETHipt,([CallingFunction,'_Data']))
%     if isfield(IMETHipt.([CallingFunction,'_Data']),('ConstEvolfunc_Data'))
%         CACCipt.ConstEvolfunc_Data = IMETHipt.([CallingFunction,'_Data']).ConstEvolfunc_Data;
%     end
% end
% TSMPipt = IMETHipt.('TrajSampfunc');
% if isfield(IMETHipt,([CallingFunction,'_Data']))
%     if isfield(IMETHipt.([CallingFunction,'_Data']),('TrajSampfunc_Data'))
%         PSMPipt.TrajSampfunc_Data = IMETHipt.([CallingFunction,'_Data']).TrajSampfunc_Data;
%     end
% end
% TENDipt = IMETHipt.('TrajEndfunc');
% if isfield(IMETHipt,([CallingFunction,'_Data']))
%     if isfield(IMETHipt.([CallingFunction,'_Data']),('TrajEndfunc_Data'))
%         TENDipt.TrajEndfunc_Data = IMETHipt.([CallingFunction,'_Data']).TrajEndfunc_Data;
%     end
% end
% SYSRESPipt = IMETHipt.('SysRespfunc');
% if isfield(IMETHipt,([CallingFunction,'_Data']))
%     if isfield(IMETHipt.([CallingFunction,'_Data']),('SysRespfunc_Data'))
%         SYSRESPipt.SysRespfunc_Data = IMETHipt.([CallingFunction,'_Data']).SysRespfunc_Data;
%     end
% end
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
% func = str2func(IMETH.radevfunc);           
% [SCRPTipt,RADEV,err] = func(SCRPTipt,RADEVipt);
% if err.flag
%     return
% end
RADEV.method = 'RadSolEv_ForConstEvol_v1a';
% func = str2func(IMETH.desoltimfunc);           
% [SCRPTipt,DESOL,err] = func(SCRPTipt,DESOLipt);
% if err.flag
%     return
% end
DESOL.method = 'DeSolTim_YarnBallLookup_v1b';
% func = str2func(IMETH.psmpfunc);           
% [SCRPTipt,PSMP,err] = func(SCRPTipt,PSMPipt);
% if err.flag
%     return
% end
PSMP.method = 'ProjSamp_Wool_v1b';
% func = str2func(IMETH.tsmpfunc);           
% [SCRPTipt,TSMP,err] = func(SCRPTipt,TSMPipt);
% if err.flag
%     return
% end
TSMP.method = 'TrajSamp_SiemensLR_v3h';
TSMP.minbaseoversamp = 1.1;
TSMP.sysoversamp = 1.25;
% func = str2func(IMETH.accconstfunc);           
% [SCRPTipt,CACC,err] = func(SCRPTipt,CACCipt);
% if err.flag
%     return
% end
CACC.method = 'ConstEvol_ShapeAlongTraj_v1a';
CACC.gacc = 8000;
CACC.gvelprof = 'GvelProf_Exp2Decay_v1a';
CACC.GVP = struct();
CACC.GVP.tau = 0.02;                                    % make smarter in code
CACC.GVP.startfrac = 100;
CACC.GVP.decayrate = 15;
CACC.GVP.decayshift = 18;
CACC.GVP.enddrop = 15;
% func = str2func(IMETH.tendfunc);           
% [SCRPTipt,TEND,err] = func(SCRPTipt,TENDipt);
% if err.flag
%     return
% end
TEND.method = 'TrajEnd_StandardSpoil_v1b';
TEND.slope = 110;
TEND.spoilfactor = 1;
% func = str2func(IMETH.sysrespfunc);           
% [SCRPTipt,SYSRESP,err] = func(SCRPTipt,SYSRESPipt);
% if err.flag
%     return
% end
SYSRESP.method = 'SysResp_FromFileWithComp_v1g';
load('SysRespFIR_Siemens_Fall2016_2');
SYSRESP.GSYSMOD = saveData.GSYSMOD;
SYSRESP.errsmthkern = 3;
SYSRESP.iterations = 16;
% func = str2func(IMETH.ksampfunc);           
% [SCRPTipt,KSMP,err] = func(SCRPTipt,KSMPipt);
% if err.flag
%     return
% end
KSMP.method = 'kSamp_Standard_v1c';

IMETH.vis = 'basic';

%------------------------------------------
% Return
%------------------------------------------
IMETH.ORNT = ORNT;
IMETH.DESOL = DESOL;
IMETH.PSMP = PSMP;
IMETH.TSMP = TSMP;
IMETH.CACC = CACC;
IMETH.RADEV = RADEV;
IMETH.TEND = TEND;
IMETH.SYSRESP = SYSRESP;
IMETH.KSMP = KSMP;

Status2('done','',2);
Status2('done','',3);
