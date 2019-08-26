%=========================================================
% (v1d) - add projection sampling to implementation
%=========================================================

function [SCRPTipt,SCRPTGBLout,err] = TPI_noSRA_v1d(SCRPTipt,SCRPTGBL)

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

%====================================================
% Build Quantization Vector
%====================================================
PROJimp.destwseg = destwseg;
Status('busy','Build Quantization Vector');
PROJimp.gqntmeth = 'TPI_INOVA_v6a';
quantfunc = str2func(PROJimp.gqntmeth);
GQNT.wantediseg = PROJdgn.iseg;
GQNT.noisegs = 1;
GQNT.wantedtro = PROJdgn.tro; 
GQNT.wantedtwseg = PROJimp.destwseg;
GQNT.return = 'FindPossible';
sampfunc = str2func(PROJimp.tsmpfunc);
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
GQNT = struct();
GQNT.wantediseg = bestiseg;
GQNT.noisegs = 1;
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
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Tro_Imp (ms)','0output',PROJimp.tro,'0text');

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
wfmfunc = str2func(PROJimp.gwfmfunc);
WFM = struct();
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
func = str2func(PROJimp.ksmpfunc);
IMP.testing = SCRPTGBL.testing;
[PROJimp,samp,Kmat,Kend,IMP,SCRPTipt,err] = func(impPROJdgn,PROJimp,G,IMP,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
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
       
SCRPTGBLout.SCRPTGBL = SCRPTGBL;
SCRPTGBLout.IMPipt = SCRPTipt;
SCRPTGBLout.PROJimp = PROJimp;
SCRPTGBLout.PROJdgn = PROJdgn;
SCRPTGBLout.impPROJdgn = impPROJdgn;
SCRPTGBLout.Kmat = Kmat;
SCRPTGBLout.Kend = Kend;
SCRPTGBLout.G = G;
SCRPTGBLout.Testing = Testing;





