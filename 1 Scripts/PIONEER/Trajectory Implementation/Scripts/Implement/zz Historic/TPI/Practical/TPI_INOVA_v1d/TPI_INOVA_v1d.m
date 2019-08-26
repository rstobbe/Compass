%=========================================================
% (v1d)
%   - update for RWSUI_BA (from TPI_Gen_v1c)
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = TPI_INOVA_v1d(SCRPTipt,SCRPTGBL)

Status('busy','Implement Trajectory Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Des_File_Data'))
    err.flag = 1;
    err.msg = '(Re) Load Des_File';
    ErrDisp(err);
    return
end

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('Imp_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
PROJimp = struct();
PROJimp.method = SCRPTGBL.CurrentTree.Func;
PROJimp.system = SCRPTGBL.CurrentTree.('System');
PROJimp.nucleus = SCRPTGBL.CurrentTree.('Nucleus');
if strcmp(PROJimp.nucleus,'1H')
    PROJimp.gamma = 42.577;
elseif strcmp(PROJimp.nucleus,'23Na')
    PROJimp.gamma = 11.26;
end
PROJimp.slvno = str2double(SCRPTGBL.CurrentTree.('SlvNo'));
PROJimp.orient = SCRPTGBL.CurrentTree.('Orient');
PROJimp.sysimpfunc = SCRPTGBL.CurrentTree.('SysImpfunc').Func;
PROJimp.qvecslvfunc = SCRPTGBL.CurrentTree.('QVecSlvfunc').Func;
PROJimp.gwfmfunc = SCRPTGBL.CurrentTree.('GWFMfunc').Func;
PROJimp.prsmpmeth = SCRPTGBL.CurrentTree.('ProjSampfunc').Func;
PROJimp.tsmpfunc = SCRPTGBL.CurrentTree.('TrajSampfunc').Func;
PROJimp.ksmpfunc = SCRPTGBL.CurrentTree.('kSampfunc').Func;

%---------------------------------------------
% Trajecory Design Testing
%---------------------------------------------
testing = SCRPTGBL.CurrentTree.('Testing_Only');
tnproj = 10;

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
PROJimp.genfunc = 'TPI_GenProj_v3b';
if not(exist(PROJimp.genfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common TPI routines must be added to path';
    return
end

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
PROJdgn = SCRPTGBL.Des_File_Data.DES.PROJdgn;
GAMFUNC = SCRPTGBL.Des_File_Data.DES.GAMFUNC;

SYS = SCRPTGBL.CurrentTree.('SysImpfunc');
if isfield(SCRPTGBL,('SysImpfunc_Data'))
    SYS.SysImpfunc_Data = SCRPTGBL.SysImpfunc_Data;
end
GWFM = SCRPTGBL.CurrentTree.('GWFMfunc');
if isfield(SCRPTGBL,('GWFMfunc_Data'))
    GWFM.GWFMfunc_Data = SCRPTGBL.GWFMfunc_Data;
end
GQNT = SCRPTGBL.CurrentTree.('QVecSlvfunc');  
if isfield(SCRPTGBL,('QVecSlvfunc_Data'))
    GQNT.QVecSlvfunc_Data = SCRPTGBL.QVecSlvfunc_Data;
end
PSMP = SCRPTGBL.CurrentTree.('ProjSampfunc');
if isfield(SCRPTGBL,('ProjSampfunc_Data'))
    PSMP.ProjSampfunc_Data = SCRPTGBL.ProjSampfunc_Data;
end
TSMP = SCRPTGBL.CurrentTree.('TrajSampfunc');
if isfield(SCRPTGBL,('TrajSampfunc_Data'))
    TSMP.TrajSampfunc_Data = SCRPTGBL.TrajSampfunc_Data;
end
KSMP = SCRPTGBL.CurrentTree.('kSampfunc');
if isfield(SCRPTGBL,('kSampfunc_Data'))
    KSMP.kSampfunc_Data = SCRPTGBL.kSampfunc_Data;
end

%----------------------------------------------------
% Check
%----------------------------------------------------
if not(isfield(PROJdgn,'iseg'))
    err.flag = 1;
    err.msg = 'Design / Implementation Not Compatible';
    return
end 

%----------------------------------------------------
% Solve Gradient Quantization Vector
%----------------------------------------------------
Status('busy','Solve Gradient Quantization Vector');
func = str2func(PROJimp.qvecslvfunc);
GQNT.PROJdgn = PROJdgn;
GQNT.PROJimp = PROJimp;
GQNT.return = 'FindBest';
[SCRPTipt,GQNTout,err] = func(SCRPTipt,GQNT);
if err.flag
    return
end
PROJimp.tro = GQNTout.besttro;
PROJimp.iseg = GQNTout.bestiseg;
PROJimp.twseg = GQNTout.besttwseg;

%----------------------------------------------------
% Determine System Implementation Aspects
%----------------------------------------------------
Status('busy','Determine System Implementation Aspects');
func = str2func(PROJimp.sysimpfunc);
SYS.PROJdgn = PROJdgn;
SYS.twwords = GQNTout.twwords;
[SCRPTipt,SYS,err] = func(SCRPTipt,SYS);
if err.flag
    return
end

%----------------------------------------------------
% Recalculate 'p' and 'projlen' for new 'tro' and 'iseg'
%----------------------------------------------------
Status('busy','Determine Effect of Design Tweak');
func = str2func([PROJdgn.method,'_Func']);
impPROJdgn = PROJdgn;
impPROJdgn.tro = PROJimp.tro;
impPROJdgn.iseg = PROJimp.iseg;
DES.PROJdgn = impPROJdgn;
DES.GAMFUNC = GAMFUNC;
[DES,err] = func(DES);
if err.flag ~= 0
    return
end
impPROJdgn = DES.PROJdgn;
PROJimp.p = impPROJdgn.p;

%----------------------------------------------------
% Define Projection Sampling
%----------------------------------------------------
Status('busy','Define Projection Sampling');
func = str2func(PROJimp.prsmpmeth);
PSMP.PROJdgn = impPROJdgn;
PSMP.PROJimp = PROJimp;
PSMP.testing = testing;
PSMP.tnproj = tnproj;
[SCRPTipt,PSMP,err] = func(SCRPTipt,PSMP);
if err.flag
    return
end
PROJimp.projosamp = PSMP.projosamp;
PROJimp.nproj = PSMP.nproj;

%----------------------------------------------------
% Generate Projections
%----------------------------------------------------
Status('busy','Generate Trajectories');
func = str2func(PROJimp.genfunc);
ImpStrct.slvno = PROJimp.slvno;
ImpStrct.IV = PSMP.IV;
[T,KSA,err] = func(impPROJdgn,GAMFUNC,ImpStrct);
if err.flag
    return
end

%----------------------------------------------------
% Test/Build Quantization Vector
%----------------------------------------------------
Status('busy','Build Quantization Vector');
func = str2func(PROJimp.qvecslvfunc);
GQNT.PROJdgn = impPROJdgn;
GQNT.PROJimp = PROJimp;
GQNT.return = 'Output';
[SCRPTipt,GQNT,err] = func(SCRPTipt,GQNT);
if err.flag
    return
end
if GQNT.tro ~= PROJimp.tro || GQNT.iseg ~= PROJimp.iseg || GQNT.twseg ~= PROJimp.twseg
    error();
end

%---------------------------------------
% Create Gradient Waveforms
%---------------------------------------
Status('busy','Create Gradient Waveforms');
func = str2func(PROJimp.gwfmfunc);
GWFM.GQNT = GQNT;
GWFM.SYS = SYS;
GWFM.PROJdgn = impPROJdgn;
GWFM.PROJimp = PROJimp;
GWFM.T = T;
GWFM.KSA = KSA;
[SCRPTipt,GWFM,err] = func(SCRPTipt,GWFM);
if err.flag
    return
end
G = GWFM.G;

%---------------------------------------
% Visuals
%---------------------------------------
kVis = 'On';
if strcmp(kVis,'On') 
    figure(2000); hold on; 
    plot(GQNT.samparr,GWFM.GQKSA(1,:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,1),'k-');     
    plot(GQNT.samparr,GWFM.GQKSA(1,:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,2),'k-');  
    plot(GQNT.samparr,GWFM.GQKSA(1,:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,3),'k-');
    title('Ksamp Traj1'); 
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');
    figure(2001); hold on; 
    plot(GQNT.samparr,GWFM.GQKSA(5,:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(5,:,1),'k-');      
    plot(GQNT.samparr,GWFM.GQKSA(5,:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(5,:,2),'k-');  
    plot(GQNT.samparr,GWFM.GQKSA(5,:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(5,:,3),'k-');
    title('Ksamp Traj5');
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');    
    figure(2002); hold on; 
    [L,~,~] = size(GWFM.GQKSA);
    L = L-1;
    plot(GQNT.samparr,GWFM.GQKSA(L,:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L,:,1),'k-');      
    plot(GQNT.samparr,GWFM.GQKSA(L,:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L,:,2),'k-');  
    plot(GQNT.samparr,GWFM.GQKSA(L,:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L,:,3),'k-');
    title(['Ksamp Traj',num2str(L)]);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');    
end

%----------------------------------------------------
% Define Trajectory Sampling
%----------------------------------------------------
func = str2func(PROJimp.tsmpfunc);
TSMP.PROJdgn = impPROJdgn;
TSMP.PROJimp = PROJimp;
TSMP.GWFM = GWFM;
[SCRPTipt,TSMP,err] = func(SCRPTipt,TSMP);
if err.flag
    ErrDisp(err);
    return
end
PROJimp.npro = TSMP.npro;
PROJimp.sampstart = TSMP.sampstart;
PROJimp.dwell = TSMP.dwell;
PROJimp.trajosamp = TSMP.trajosamp;

%---------------------------------------
% Resample k-Space
%---------------------------------------
Status('busy','Resample k-Space');
func = str2func(PROJimp.ksmpfunc);
KSMP.testing = testing;
KSMP.GQNT = GQNT;
KSMP.GWFM = GWFM;
KSMP.PSMP = PSMP;
KSMP.TSMP = TSMP;
KSMP.PROJimp = PROJimp;
KSMP.PROJdgn = impPROJdgn;
KSMP.G = G;
KSMP.KSA = KSA;
[SCRPTipt,KSMP,err] = func(SCRPTipt,KSMP);
if err.flag
    return
end
Kmat = KSMP.Kmat;
Kend = KSMP.Kend;
PROJimp.meanrelkmax = KSMP.meanrelkmax;
PROJimp.maxrelkmax = KSMP.maxrelkmax;

%--------------------------------------------
% Output Structure
%--------------------------------------------
GWFM = rmfield(GWFM,{'G' 'GQKSA' 'qTscnr'});
KSMP = rmfield(KSMP,{'samp' 'Kmat' 'Kend'});
IMP.PROJimp = PROJimp;
IMP.PROJdgn = PROJdgn;
IMP.impPROJdgn = impPROJdgn;
IMP.SYS = SYS;
IMP.GQNT = GQNT;
IMP.PSMP = PSMP;
IMP.GWFM = GWFM;
IMP.TSMP = TSMP;
IMP.KSMP = KSMP;
IMP.Kmat = Kmat;
IMP.Kend = Kend;
IMP.G = G;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Implementation:','Name',1,{'IMP_'});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Imp_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {IMP};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMP';

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

if strcmp(testing,'No');
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
    SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
    SCRPTGBL.RWSUI.SaveScriptName = 'ProjImp';
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
end

Status('done','');
Status2('done','',2);
Status2('done','',3);


