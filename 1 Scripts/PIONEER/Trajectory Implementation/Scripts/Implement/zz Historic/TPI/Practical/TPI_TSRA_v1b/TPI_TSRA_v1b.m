%=========================================================
% TPI_TSRA_v1b
%=========================================================

function [SCRPTipt,SCRPTGBLout,err] = TPI_TSRA_v1b(SCRPTipt,SCRPTGBL)

SCRPTGBLout.TextBox = '';
SCRPTGBLout.Figs = [];
SCRPTGBLout.Data = [];

errnum = 1;
err.flag = 0;
err.msg = '';

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
destwseg = str2double(SCRPTipt(strcmp('twGseg (ms)',{SCRPTipt.labelstr})).entrystr);
slvprior1 = SCRPTipt(strcmp('Solve_Priority1',{SCRPTipt.labelstr})).entrystr;
if iscell(slvprior1)
    slvprior1 = SCRPTipt(strcmp('Solve_Priority1',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Solve_Priority1',{SCRPTipt.labelstr})).entryvalue};
end
slvprior2 = SCRPTipt(strcmp('Solve_Priority2',{SCRPTipt.labelstr})).entrystr;
if iscell(slvprior2)
    slvprior2 = SCRPTipt(strcmp('Solve_Priority2',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Solve_Priority2',{SCRPTipt.labelstr})).entryvalue};
end
PROJimp.wfmmeth = SCRPTipt(strcmp('Grad_WFM',{SCRPTipt.labelstr})).entrystr;
PROJimp.srameth = SCRPTipt(strcmp('SRA_Func',{SCRPTipt.labelstr})).entrystr;
PROJimp.tsmpmeth = SCRPTipt(strcmp('Traj_Samp',{SCRPTipt.labelstr})).entrystr;
PROJimp.ksmpmeth = SCRPTipt(strcmp('k_Samp',{SCRPTipt.labelstr})).entrystr;
PROJimp.srimeth = SCRPTipt(strcmp('SRI_Func',{SCRPTipt.labelstr})).entrystr;
kVis = SCRPTipt(strcmp('ksmp Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(kVis)
    kVis = SCRPTipt(strcmp('ksmp Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('ksmp Vis',{SCRPTipt.labelstr})).entryvalue};
end
STVis = SCRPTipt(strcmp('SampTim Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(STVis)
    STVis = SCRPTipt(strcmp('SampTim Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('SampTim Vis',{SCRPTipt.labelstr})).entryvalue};
end

AIDipt = SCRPTGBL.AIDipt;
PROJdgn = SCRPTGBL.PROJdgn;
PROJipt = SCRPTGBL.PROJipt;

%----------------------------------------------------
% Check
%----------------------------------------------------
if not(isfield(PROJdgn,'iseg'))
    err(errnum).flag = 1;
    err(errnum).msg = 'Implementation Method Not Appropriate';
    return
end 

%====================================================
% Accomodate SR
%====================================================
PROJimp.destwseg = destwseg;
twseg1 = PROJdgn.iseg;
while true
    %----------------------------------------------------
    % Build Test Projections
    %----------------------------------------------------
    Status('busy','Generate Trajectories');
    IMP.slvno = 1000; 
    IMP.tnproj = 10;
    genproj = 'testing';
    PROJGBL.AIDipt = AIDipt;
    PROJGBL.IMP = IMP;
    PROJGBL.genproj = genproj;
    func = str2func(AIDipt.projdes);
    [PROJipt,PROJGBL,err] = func(PROJipt,PROJGBL);
    impPROJdgn = PROJGBL.PROJdgn;
    T = PROJGBL.T;
    KSA = PROJGBL.KSA;

    %----------------------------------------------------
    % Quantize Trajectories
    %----------------------------------------------------
    qT0 = [0 impPROJdgn.iseg impPROJdgn.iseg+twseg1];
    [GQKSA] = Quantize_Projections_v1a(impPROJdgn,T,qT0,KSA);
    GQKSA = impPROJdgn.kmax*GQKSA;

    %----------------------------------------------------
    % Solve Gradient Quantization
    %----------------------------------------------------
    [G0] = SolveGradQuant_v1a(impPROJdgn,qT0,GQKSA,PROJimp.gamma);

    %----------------------------------------------------
    % Compensate for Step Response
    %----------------------------------------------------
    Status('busy','Compensate for Step Response');
    srafunc = str2func(PROJimp.srameth);
    WFM.incstepdur = 1;
    PROJimp.twseg1 = twseg1;
    [PROJimp,qT,G0,WFM,SCRPTipt,err] = srafunc(PROJdgn,PROJimp,qT0,G0,WFM,SCRPTipt,err);
    for errn = 1:length(err)
        if err(errn).flag == 1
            return
        end
    end

    %----------------------------------------------------
    % Test
    %----------------------------------------------------
    addedlength = qT(3) - qT0(3);
    if abs(((addedlength + impPROJdgn.tro)/PROJdgn.tro) - 1) < 0.001
        break
    end
    AIDipt.tro = PROJdgn.tro - addedlength;  
end

%====================================================
% Build Quantization Vector
%====================================================
Status('busy','Build Quantization Vector');
PROJimp.gqntmeth = 'TPI_INOVA_v5a';
quantfunc = str2func(PROJimp.gqntmeth);
GQNT.wantediseg = qT(2);
GQNT.noisegs = 2;
GQNT.wantedtro = PROJdgn.tro; 
GQNT.wantedtwseg = PROJimp.destwseg;
GQNT.return = 'FindPossible';
sampfunc = str2func(PROJimp.tsmpmeth);
SAMP.writeout = 'no';
good = [];
while true
    [PROJimp,GQNT,SCRPTipt,err0] = quantfunc(PROJdgn,PROJimp,GQNT,SCRPTipt,[]);
    besttro = GQNT.besttro;
    bestiseg = GQNT.bestiseg;
    besttwseg = GQNT.besttwseg;
    osamp = [];
    for n = 1:length(besttro)
        testPROJdgn = PROJdgn;
        testPROJdgn.tro = besttro(n);
        [PROJimp,SAMP,SCRPTipt,err0] = sampfunc(testPROJdgn,PROJimp,SAMP,SCRPTipt,[]);
        osamp(n) = SAMP.osamp;    
    end
    if strcmp(slvprior1,'OvrSamp1');        
        osampbound = 1.05;
        trobound = 0.005;
        isegbound = 0.005;
        ind = find(osamp < SAMP.sampling*osampbound);
        if not(isempty(ind))
            n = 0;
            for i = 1:length(ind)
                if abs(besttro(ind(i))-GQNT.wantedtro) < GQNT.wantedtro*trobound
                    if abs(bestiseg(ind(i))-GQNT.wantediseg) < GQNT.wantediseg*isegbound
                        n = n+1;
                        good(n) = ind(i);
                    end
                end
            end
            if strcmp(slvprior2,'OvrSamp2');   
                good = good(find(osamp(good) == min(osamp(good)),1,'first'));        
            elseif strcmp(slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-GQNT.wantedtro) == min(abs(besttro(good)-GQNT.wantedtro)),1,'first'));        
            elseif strcmp(slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNT.wantedtwseg) == min(abs(besttwseg(good)-GQNT.wantedtwseg)),1,'first'));  
            elseif strcmp(slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-GQNT.wantediseg) == min(abs(bestiseg(good)-GQNT.wantediseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end
        end
    elseif strcmp(slvprior1,'TwGseg1');        
        osampbound = 1.5;
        trobound = 0.005;
        isegbound = 0.005;
        twsegbound = 0.002;
        ind = find(osamp < SAMP.osampdes*osampbound);
        if not(isempty(ind))
            n = 0;
            for i = 1:length(ind)
                if abs(besttro(ind(i))-GQNT.wantedtro) < GQNT.wantedtro*trobound
                    if abs(bestiseg(ind(i))-GQNT.wantediseg) < GQNT.wantediseg*isegbound
                        if abs(((besttro(ind(i))-bestiseg(ind(i)))/GQNT.twwords)-PROJimp.wantedtwseg) < PROJimp.wantedtwseg*twsegbound
                            n = n+1;
                            good(n) = ind(i);
                        end
                    end
                end
            end
            if strcmp(slvprior2,'OvrSamp2');   
                good = good(find(osamp(good) == min(osamp(good)),1,'first'));        
            elseif strcmp(slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-GQNT.wantedtro) == min(abs(besttro(good)-GQNT.wantedtro)),1,'first'));        
            elseif strcmp(slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNT.wantedtwseg) == min(abs(besttwseg(good)-GQNT.wantedtwseg)),1,'first'));  
            elseif strcmp(slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-GQNT.wantediseg) == min(abs(bestiseg(good)-GQNT.wantediseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end 
        end
    elseif strcmp(slvprior1,'Tro1');        
        osampbound = 1.5;
        trobound = 0.002;
        isegbound = 0.002;
        ind = find(osamp < SAMP.osampdes*osampbound);
        if not(isempty(ind))
            n = 0;
            for i = 1:length(ind)
                if abs(besttro(ind(i))-GQNT.wantedtro) < GQNT.wantedtro*trobound
                    if abs(bestiseg(ind(i))-GQNT.wantediseg) < GQNT.wantediseg*isegbound
                        n = n+1;
                        good(n) = ind(i);
                    end
                end
            end
            if strcmp(slvprior2,'OvrSamp2');   
                good = good(find(osamp(good) == min(osamp(good)),1,'first'));        
            elseif strcmp(slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-GQNT.wantedtro) == min(abs(besttro(good)-GQNT.wantedtro)),1,'first'));        
            elseif strcmp(slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNT.wantedtwseg) == min(abs(besttwseg(good)-GQNT.wantedtwseg)),1,'first'));   
            elseif strcmp(slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-GQNT.wantediseg) == min(abs(bestiseg(good)-GQNT.wantediseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end
        end
    elseif strcmp(slvprior1,'iGseg1');        
        osampbound = 1.5;
        trobound = 0.002;
        isegbound = 0.002;
        ind = find(osamp < SAMP.osampdes*osampbound);
        if not(isempty(ind))
            n = 0;
            for i = 1:length(ind)
                if abs(besttro(ind(i))-GQNT.wantedtro) < GQNT.wantedtro*trobound
                    if abs(bestiseg(ind(i))-GQNT.wantediseg) < GQNT.wantediseg*isegbound
                        n = n+1;
                        good(n) = ind(i);
                    end
                end
            end
            if strcmp(slvprior2,'OvrSamp2');   
                good = good(find(osamp(good) == min(osamp(good)),1,'first'));        
            elseif strcmp(slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-GQNT.wantedtro) == min(abs(besttro(good)-GQNT.wantedtro)),1,'first'));        
            elseif strcmp(slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNT.wantedtwseg) == min(abs(besttwseg(good)-GQNT.wantedtwseg)),1,'first'));  
            elseif strcmp(slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-GQNT.wantediseg) == min(abs(bestiseg(good)-GQNT.wantediseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end
        end         
    end
    GQNT.wantedtwseg = round(10000*(GQNT.wantedtro-GQNT.noisegs*GQNT.wantediseg)/(GQNT.twwords-1))/10000;
end
besttro = besttro(good);
bestiseg = bestiseg(good);
besttwseg = besttwseg(good);

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
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Split','0output',PROJimp.split,'0numout');

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
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'ProjMult','0output',PROJimp.projmult,'0numout');

%====================================================
% Generate Projections
%====================================================
Status('busy','Generate Trajectories');
AIDipt.tro = besttro - (bestiseg-impPROJdgn.iseg) - (bestiseg-PROJimp.twseg1);  
if SCRPTGBL.testing == 1
    IMP.tnproj = 10;                                 
    genproj = 'testing';
else
    genproj = 'generate';
end
IMP.slvno = PROJimp.slvno;
PROJGBL.AIDipt = AIDipt;
PROJGBL.IMP = IMP;
PROJGBL.genproj = genproj;
func = str2func(AIDipt.projdes);
[PROJipt,PROJGBL,err] = func(PROJipt,PROJGBL);
impPROJdgn = PROJGBL.PROJdgn;

T = PROJGBL.T;
KSA = PROJGBL.KSA;
PROJimp.p = impPROJdgn.p;
if SCRPTGBL.testing == 1
    PROJimp.nproj = IMP.tnproj*2;
else
    PROJimp.nproj = impPROJdgn.nproj;
end

%----------------------------------------------------
% Build Quantization Vector
%----------------------------------------------------
GQNT = struct();
GQNT.wantediseg = bestiseg;
GQNT.noisegs = 2;
GQNT.wantedtro = besttro; 
GQNT.wantedtwseg = besttwseg;
GQNT.return = 'Output';
[PROJimp,GQNT,SCRPTipt,err] = quantfunc(PROJdgn,PROJimp,GQNT,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end
if besttro ~= PROJimp.tro
    error();
end
GQNT.arr0 = [0 impPROJdgn.iseg (impPROJdgn.iseg+PROJimp.twseg1:GQNT.twseg:impPROJdgn.tro*1.001)];
%test = GQNT.arr0(length(GQNT.arr0))
if round(100*GQNT.arr0(length(GQNT.arr0))) ~= round(100*impPROJdgn.tro)
    error();
end
PROJimp.GQNT.arr0 = GQNT.arr0;
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Tro_Imp','0output',PROJimp.tro,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'p_Imp','0output',impPROJdgn.p,'0text');

%----------------------------------------------------
% Define Sampling
%----------------------------------------------------
SAMP.writeout = 'yes';
sampPROJdgn = impPROJdgn;
sampPROJdgn.tro = PROJimp.tro;
[PROJimp,SAMP,SCRPTipt,err] = sampfunc(sampPROJdgn,PROJimp,SAMP,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%---------------------------------------
% Create Gradient Waveform
%---------------------------------------
Status('busy','Create Gradient Waveform');
wfmfunc = str2func(PROJimp.wfmmeth);
WFM.incstepdur = 0;
[PROJimp,G,GQKSA,WFM,SCRPTipt,err] = wfmfunc(impPROJdgn,PROJimp,T,KSA,WFM,SCRPTipt,err);
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
func = str2func(PROJimp.ksmpmeth);
[PROJimp,samp,Kmat,Kend,SCRPTipt,err] = func(impPROJdgn,PROJimp,G,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%---------------------------------------
% Visuals
%---------------------------------------
if strcmp(kVis,'On') 
    figure(2000); hold on; 
    plot(samp,Kmat(1,:,1),'k*'); plot(GQNT.arr,GQKSA(1,:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,1),'k-'); title('Ksamp Traj1');      
    plot(samp,Kmat(1,:,2),'k*'); plot(GQNT.arr,GQKSA(1,:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,2),'k-');  
    plot(samp,Kmat(1,:,3),'k*'); plot(GQNT.arr,GQKSA(1,:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,3),'k-');
    figure(2001); hold on; 
    [L,~,~] = size(Kmat);
    L = L-1;
    plot(samp,Kmat(L,:,1),'k*'); plot(GQNT.arr,GQKSA(L,:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L,:,1),'k-'); title('Ksamp Traj1');      
    plot(samp,Kmat(L,:,2),'k*'); plot(GQNT.arr,GQKSA(L,:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L,:,2),'k-');  
    plot(samp,Kmat(L,:,3),'k*'); plot(GQNT.arr,GQKSA(L,:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L,:,3),'k-');
end

%---------------------------------------
% Check if Elip Proper...
%---------------------------------------
if SCRPTGBL.testing == 1
    phi = impPROJdgn.TestInitProjVec.conephi;
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
    phi = PROJdgn.InitProjVec.conephi;
    projindx = PROJdgn.InitProjVec.projindx;
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
if strcmp(STVis,'On')
    figure(5);
    plot(Testing.tatr,Testing.r,'r');
end
       
SCRPTGBLout.SCRPTGBL = SCRPTGBL;
SCRPTGBLout.IMPipt = SCRPTipt;
SCRPTGBLout.PROJimp = PROJimp;
SCRPTGBLout.PROJdgn = PROJdgn;
SCRPTGBLout.impPROJdgn = impPROJdgn;
SCRPTGBLout.Kmat = Kmat;
SCRPTGBLout.Kend = Kend;
SCRPTGBLout.G = G;
SCRPTGBLout.Testing = Testing;





