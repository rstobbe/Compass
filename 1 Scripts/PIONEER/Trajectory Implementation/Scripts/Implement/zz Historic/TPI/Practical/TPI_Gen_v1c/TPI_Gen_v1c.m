%=========================================================
% (v1c)
%   - posterity update
%=========================================================

function [SCRPTipt,SCRPTGBLout,err] = TPI_Gen_v1c(SCRPTipt,SCRPTGBL)

errnum = 1;
err.flag = 0;
err.msg = '';
SCRPTGBLout = struct();

%----------------------------------------------------
% Input Values
%----------------------------------------------------
PROJimp.name = SCRPTipt(strcmp('Imp_Name',{SCRPTipt.labelstr})).entrystr;
PROJimp.system = 'Varian Inova';
nucleus = SCRPTipt(strcmp('Nucleus',{SCRPTipt.labelstr})).entrystr;
if iscell(nucleus)
    nucleus = SCRPTipt(strcmp('Nucleus',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Nucleus',{SCRPTipt.labelstr})).entryvalue};
end
PROJimp.nucleus = nucleus;
if strcmp(nucleus,'1H')
    PROJimp.gamma = 42.577;
elseif strcmp(nucleus,'23Na')
    PROJimp.gamma = 11.26;
end
PROJimp.slvno = str2double(SCRPTipt(strcmp('SlvNo',{SCRPTipt.labelstr})).entrystr);
orient = SCRPTipt(strcmp('Orient',{SCRPTipt.labelstr})).entrystr;
if iscell(orient)
    orient = SCRPTipt(strcmp('Orient',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Orient',{SCRPTipt.labelstr})).entryvalue};
end
PROJimp.orient = orient;

PROJimp.qvecslvfunc = SCRPTipt(strcmp('QVecSlvfunc',{SCRPTipt.labelstr})).entrystr;
PROJimp.gwfmfunc = SCRPTipt(strcmp('GWFMfunc',{SCRPTipt.labelstr})).entrystr;
PROJimp.prsmpmeth = SCRPTipt(strcmp('ProjSampfunc',{SCRPTipt.labelstr})).entrystr;
PROJimp.tsmpfunc = SCRPTipt(strcmp('TrajSampfunc',{SCRPTipt.labelstr})).entrystr;
PROJimp.ksmpfunc = SCRPTipt(strcmp('kSampfunc',{SCRPTipt.labelstr})).entrystr;

AIDipt = SCRPTGBL.AIDipt;
PROJdgn = SCRPTGBL.PROJdgn;
PROJipt = SCRPTGBL.PROJipt;

%----------------------------------------------------
% Check
%----------------------------------------------------
destest = strcmp('Iseg',{PROJipt.labelstr});
if not(destest)
    err(errnum).flag = 1;
    err(errnum).msg = 'Design / Implementation Not Compatible';
    return
end 

%----------------------------------------------------
% Solve Quantization Vector
%----------------------------------------------------
Status('busy','Solve Quantization Vector');
qvecslvfunc = str2func(PROJimp.qvecslvfunc);
GQNT.return = 'FindPossible';
[PROJimp,GQNT,SCRPTipt,err] = qvecslvfunc(PROJdgn,PROJimp,GQNT,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%----------------------------------------------------
% Calculate Split
%----------------------------------------------------
totwpp = GQNT.twwords+10;
tw = totwpp*(PROJdgn.nproj/2);
split0 = ceil(tw/64000);
split = split0;
go = 1;
while go == 1
    if rem(PROJdgn.nproj/2,split) == 0
        break
    end    
    split = split + 1;
end
if split > 2*split0
    err(errnum).flag = 1;
    err(errnum).msg = ['Projection number error.  Try ',num2str(2*split0*round((PROJdgn.nproj/2)/split0)),' projections'];
    return
end
if split > split0
    err(errnum).flag = 3;
    err(errnum).msg = ['Split can be reduced. Try ',num2str(2*split0*round((PROJdgn.nproj/2)/split0)),' projections'];
    errnum = errnum + 1;
end
PROJimp.split = split;
PROJimp.sym = 'PosNeg';

%----------------------------------------------------
% System and Proj-Mult
%----------------------------------------------------
projpersplit = (PROJdgn.nproj/2)/split;
go = 1;
n = 1;
while go == 1
    if rem(projpersplit,n) == 0 
        if projpersplit/n <= 670
            PROJimp.projmult = projpersplit/n;
            break
        end
    end
    n = n+1;
    if n > 20
        err(errnum).flag = 1;
        err(errnum).msg = 'Projection Number Error - Try Different Number of Projections';
        return
    end
end

%----------------------------------------------------
% Tweak design to accomodate quantization
%----------------------------------------------------
Status('busy','Tweak Design to Accomodate Quantization');
PROJGBL.AIDipt = AIDipt;
func = str2func(AIDipt.projdes);
[PROJipt,PROJGBL,err] = func(PROJipt,PROJGBL);
impPROJdgn = PROJGBL.PROJdgn;

%----------------------------------------------------
% Projection Sampling
%----------------------------------------------------
PROJimp.tnproj = 10;
func = str2func(PROJimp.prsmpmeth);
[SCRPTipt,PROJimp,err] = func(SCRPTipt,SCRPTGBL,PROJimp,impPROJdgn);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%----------------------------------------------------
% Get Gamma Design Function
%----------------------------------------------------
func = str2func(impPROJdgn.GamFunc);
GAMFUNC.setup = 'yes';
[SCRPTipt,GAMFUNC,err] = func(SCRPTipt,GAMFUNC);
impPROJdgn.GamFunc = GAMFUNC.GamFunc;
if err.flag ~= 0
    return
end

%====================================================
% Generate Projections
%====================================================
Status('busy','Generate Trajectories');
ImpStrct.slvno = PROJimp.slvno;
ImpStrct.IV = PROJimp.projdist.IV;
[T,KSA] = TPI_GenProj_v3a(impPROJdgn,ImpStrct);
PROJimp.p = impPROJdgn.p;

%----------------------------------------------------
% Build Quantization Vector
%----------------------------------------------------
Status('busy','Build Quantization Vector');
qvecslvfunc = str2func(PROJimp.qvecslvfunc);
GQNT.return = 'Output';
[PROJimp,GQNT,SCRPTipt,err] = qvecslvfunc(PROJdgn,PROJimp,GQNT,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end
if GQNT.reqtro ~= PROJimp.tro
    error();
end
PROJimp.GQNT = GQNT;

%----------------------------------------------------
% Define Sampling
%----------------------------------------------------
TSMP.writeout = 'yes';
sampfunc = str2func(PROJimp.tsmpfunc);
sampPROJdgn = impPROJdgn;
sampPROJdgn.tro = PROJimp.tro;
[PROJimp,TSMP,SCRPTipt,err] = sampfunc(sampPROJdgn,PROJimp,TSMP,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%---------------------------------------
% Create Gradient Waveform
%---------------------------------------
Status('busy','Create Gradient Waveform');
wfmfunc = str2func(PROJimp.gwfmfunc);
GWFM = struct();
if isfield(SCRPTGBL,'GWFMfunc');
    GWFM.Data = SCRPTGBL.GWFMfunc;
end
[PROJimp,G,GQKSA,GWFM,SCRPTipt,err] = wfmfunc(impPROJdgn,PROJimp,T,KSA,GWFM,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%---------------------------------------
% Test Gradient Waveform
%---------------------------------------
%Status('busy','Test Gradient Waveform');
%func = str2func(PROJimp.wfmtestmeth);
%[PROJimp,SCRPTipt,err] = func(PROJimp,G,SCRPTipt,err);
%for n = 1:length(err)
%    if err(n).flag == 1
%        return
%    end
%end

%---------------------------------------
% Resample k-Space
%---------------------------------------
Status('busy','Resample k-Space');
func = str2func(PROJimp.ksmpfunc);
KSMP = struct();
if isfield(SCRPTGBL,'kSampfunc');
    KSMP.Data = SCRPTGBL.kSampfunc;
end
KSMP.testing = SCRPTGBL.testing;
[PROJimp,samp,Kmat,Kend,KSMP,SCRPTipt,err] = func(impPROJdgn,PROJimp,G,KSMP,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%---------------------------------------
% Visuals
%---------------------------------------
kVis = 'On';
if strcmp(kVis,'On') 
    qTscnr = PROJimp.GQNT.scnrarr;
    figure(2000); hold on; 
    plot(samp,Kmat(1,:,1),'k*'); plot(qTscnr,GQKSA(1,:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,1),'k-'); title('Ksamp Traj1');      
    plot(samp,Kmat(1,:,2),'k*'); plot(qTscnr,GQKSA(1,:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,2),'k-');  
    plot(samp,Kmat(1,:,3),'k*'); plot(qTscnr,GQKSA(1,:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,3),'k-');
    figure(2001); hold on; 
    [L,~,~] = size(Kmat);
    L = L-1;
    plot(samp,Kmat(L,:,1),'k*'); plot(qTscnr,GQKSA(L,:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L,:,1),'k-'); title(['Ksamp Traj',num2str(L)]);      
    plot(samp,Kmat(L,:,2),'k*'); plot(qTscnr,GQKSA(L,:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L,:,2),'k-');  
    plot(samp,Kmat(L,:,3),'k*'); plot(qTscnr,GQKSA(L,:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L,:,3),'k-');
end

%---------------------------------------
% Check if Elip Proper...
%---------------------------------------
if SCRPTGBL.testing == 1
    phi = PROJimp.projdist.conephi;
    deslen = length(KSA(1,:,1));
    for n = 1:PROJimp.nproj/2
        elipphi(n) = atan(sin(phi(n))/(impPROJdgn.elip*cos(phi(n)))); 
        dKmax(n) = sqrt(((impPROJdgn.elip*impPROJdgn.kmax)^2)/(impPROJdgn.elip^2*(sin(elipphi(n)))^2 + (cos(elipphi(n)))^2));
        dKmax2(n) = impPROJdgn.kmax*(KSA(n,deslen,1).^2 + KSA(n,deslen,2).^2 + KSA(n,deslen,3).^2).^(1/2);
        Kmax(n) = (Kmat(n,PROJimp.npro,1).^2 + Kmat(n,PROJimp.npro,2).^2 + Kmat(n,PROJimp.npro,3).^2).^(1/2);
        if abs((1 - dKmax(n)/dKmax2(n))) > 0.001 
            error();
        end
    end
else
    phi = PROJimp.projdist.conephi;
    projindx = PROJimp.projdist.projindx;
    deslen = length(KSA(1,:,1));
    for n = 1:length(phi)/2
        elipphi(n) = atan(sin(phi(n))/(PROJdgn.elip*cos(phi(n)))); 
        dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax)^2)/(PROJdgn.elip^2*(sin(elipphi(n)))^2 + (cos(elipphi(n)))^2));
        dKmax2(n) = impPROJdgn.kmax*(KSA(projindx{n}(1),deslen,1).^2 + KSA(projindx{n}(1),deslen,2).^2 + KSA(projindx{n}(1),deslen,3).^2).^(1/2);
        Kmax(n) = (Kmat(projindx{n}(1),PROJimp.npro,1).^2 + Kmat(projindx{n}(1),PROJimp.npro,2).^2 + Kmat(projindx{n}(1),PROJimp.npro,3).^2).^(1/2);
        if abs((1 - dKmax(n)/dKmax2(n))) > 0.001 
            error();
        end
    end
end

%---------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------
if SCRPTGBL.testing == 1
    for n = 1:PROJimp.nproj/2
        rKmag(n,:) = ((Kmat(n,:,1).^2 + Kmat(n,:,2).^2 + Kmat(n,:,3).^2).^(1/2))/Kmax(n);
    end
else
    for n = 1:length(phi)/2
        rKmag(n,:) = ((Kmat(projindx{n}(1),:,1).^2 + Kmat(projindx{n}(1),:,2).^2 + Kmat(projindx{n}(1),:,3).^2).^(1/2))/Kmax(n);
    end
end
Testing.r = mean(rKmag,1);
Testing.tatr = (PROJimp.sampstart:PROJimp.dwell:PROJimp.tro);
Testing.meanRelKmax = PROJimp.meanrelkmax;
       
%SCRPTGBLout.SCRPTGBL = SCRPTGBL;
SCRPTGBLout.IMPipt = SCRPTipt;
SCRPTGBLout.PROJimp = PROJimp;
SCRPTGBLout.PROJdgn = PROJdgn;
SCRPTGBLout.impPROJdgn = impPROJdgn;
SCRPTGBLout.Kmat = Kmat;
SCRPTGBLout.Kend = Kend;
SCRPTGBLout.G = G;
SCRPTGBLout.Testing = Testing;

%---------------------------------------
% Panel 
%---------------------------------------
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Split','0output',PROJimp.split,'0numout');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'ProjMult','0output',PROJimp.projmult,'0numout');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Tro_Imp (ms)','0output',PROJimp.tro,'0text');
