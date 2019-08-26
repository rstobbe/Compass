%=========================================================
% (v2a)
%   - 'GenProj' added to function
%   - 'ProjSampfunc' added to function
%=========================================================

function [SCRPTipt,SCRPTGBLout,err] = TPI_Ideal_v2a(SCRPTipt,SCRPTGBL)

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
PROJimp.prsmpmeth = SCRPTipt(strcmp('ProjSampfunc',{SCRPTipt.labelstr})).entrystr;
PROJimp.tsmpmeth = SCRPTipt(strcmp('TrajSampfunc',{SCRPTipt.labelstr})).entrystr;

PROJdgn = SCRPTGBL.PROJdgn;

%----------------------------------------------------
% Check
%----------------------------------------------------
if not(isfield(PROJdgn,'iseg'))
    err(errnum).flag = 1;
    err(errnum).msg = 'Implementation Method Not Appropriate';
    return
end 

%----------------------------------------------------
% impPROJdgn (alteration in practical implementation)
%----------------------------------------------------
impPROJdgn = PROJdgn;

%----------------------------------------------------
% Projection Sampling
%----------------------------------------------------
PROJimp.tnproj = 20;
func = str2func(PROJimp.prsmpmeth);
[SCRPTipt,PROJimp,err] = func(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%----------------------------------------------------
% Get Gamma Design Function
%----------------------------------------------------
func = str2func(PROJdgn.GamFunc);
GAMFUNC.setup = 'yes';
[SCRPTipt,GAMFUNC,err] = func(SCRPTipt,GAMFUNC);
PROJdgn.GamFunc = GAMFUNC.GamFunc;
if err.flag ~= 0
    return
end

%----------------------------------------------------
% Generate Implemented Projections
%----------------------------------------------------
ImpStrct.slvno = PROJimp.slvno;
ImpStrct.IV = PROJimp.projdist.IV;
[T,KSA] = TPI_GenProj_v2a(PROJdgn,ImpStrct);

%----------------------------------------------------
% Define Sampling
%----------------------------------------------------
sampfunc = str2func(PROJimp.tsmpmeth);
SAMP = struct();
[PROJimp,SAMP,SCRPTipt,err] = sampfunc(impPROJdgn,PROJimp,SAMP,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%---------------------------------------
% Resample k-Space
%---------------------------------------
samp = (PROJimp.sampstart:PROJimp.dwell:impPROJdgn.tro);
projlen = T(length(T));
[L,~,~] = size(KSA);
Kmat = zeros(L,length(samp),3);
for n = 1:L
    Kmat(n,:,1) = interp1(impPROJdgn.tro*T/projlen,KSA(n,:,1)*impPROJdgn.kmax,samp,'cubic','extrap');
    Kmat(n,:,2) = interp1(impPROJdgn.tro*T/projlen,KSA(n,:,2)*impPROJdgn.kmax,samp,'cubic','extrap');
    Kmat(n,:,3) = interp1(impPROJdgn.tro*T/projlen,KSA(n,:,3)*impPROJdgn.kmax,samp,'cubic','extrap');
end
if isnan(Kmat)
    error('NaN Problem');
end

%---------------------------------------
% Test Maximum
%---------------------------------------
if SCRPTGBL.testing == 1
    phi = PROJimp.projdist.IV(1,:);
    for n = 1:PROJimp.nproj
        elipphi(n) = atan(sin(phi(n))/(impPROJdgn.elip*cos(phi(n)))); 
        dKmax(n) = sqrt(((impPROJdgn.elip*impPROJdgn.kmax)^2)/(impPROJdgn.elip^2*(sin(elipphi(n)))^2 + (cos(elipphi(n)))^2));
        Kmax(n) = (Kmat(n,PROJimp.npro,1).^2 + Kmat(n,PROJimp.npro,2).^2 + Kmat(n,PROJimp.npro,3).^2).^(1/2);
    end
    %Kmax
    rKmax = Kmax./impPROJdgn.kmax;
else
    phi = PROJimp.projdist.IV(1,:);
    for n = 1:length(phi)
        elipphi(n) = atan(sin(phi(n))/(PROJdgn.elip*cos(phi(n)))); 
        dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax)^2)/(PROJdgn.elip^2*(sin(elipphi(n)))^2 + (cos(elipphi(n)))^2));
        Kmax(n) = (Kmat(n,PROJimp.npro,1).^2 + Kmat(n,PROJimp.npro,2).^2 + Kmat(n,PROJimp.npro,3).^2).^(1/2);
    end
    %Kmax
    rKmax = Kmax./PROJdgn.kmax;
end
PROJimp.meanrelkmax = mean(rKmax);
PROJimp.varrelkmax = var(rKmax);
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'meanRelKmax','0output',PROJimp.meanrelkmax,'0numout');

%----------------------------------------------------
% Testing Relative Sampling Steps
%----------------------------------------------------
Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
rRad = Rad/PROJdgn.kstep;
for n = 2:PROJimp.npro
    rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
end
PROJimp.rRadStep = max(rRadStep(:));
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'maxRelRadStep','0output',PROJimp.rRadStep,'0numout');

%---------------------------------------
% Check if Elip Proper...
%---------------------------------------
%if SCRPTGBL.testing == 1
%    phi = impPROJdgn.TestInitProjVec.IV(1,:);
%    deslen = length(KSA(1,:,1));
%    for n = 1:PROJimp.nproj/2
%        elipphi(n) = atan(sin(phi(n))/(impPROJdgn.elip*cos(phi(n)))); 
%        dKmax(n) = sqrt(((impPROJdgn.elip*impPROJdgn.kmax)^2)/(impPROJdgn.elip^2*(sin(elipphi(n)))^2 + (cos(elipphi(n)))^2));
%        dKmax2(n) = impPROJdgn.kmax*(KSA(n,deslen,1).^2 + KSA(n,deslen,2).^2 + KSA(n,deslen,3).^2).^(1/2);
%        if abs((1 - dKmax(n)/dKmax2(n))) > 0.001 
%            error();
%        end
%        Kmax(n) = (Kmat(n,PROJimp.npro,1).^2 + Kmat(n,PROJimp.npro,2).^2 + Kmat(n,PROJimp.npro,3).^2).^(1/2);
%    end
%else
%    phi = PROJimp.projdist.IV(1,:);
%    deslen = length(KSA(1,:,1));
%    for n = 1:length(phi)/2
%        elipphi(n) = atan(sin(phi(n))/(PROJdgn.elip*cos(phi(n)))); 
%        dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax)^2)/(PROJdgn.elip^2*(sin(elipphi(n)))^2 + (cos(elipphi(n)))^2));
%        dKmax2(n) = PROJdgn.kmax*(KSA(n,deslen,1).^2 + KSA(n,deslen,2).^2 + KSA(n,deslen,3).^2).^(1/2);
%        if abs((1 - dKmax(n)/dKmax2(n))) > 0.001 
%            error();
%        end
%        Kmax(n) = (Kmat(n,PROJimp.npro,1).^2 + Kmat(n,PROJimp.npro,2).^2 + Kmat(n,PROJimp.npro,3).^2).^(1/2);
%    end
%end

%---------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------
if SCRPTGBL.testing == 1
    for n = 1:PROJimp.nproj/2
        rKmag(n,:) = ((Kmat(n,:,1).^2 + Kmat(n,:,2).^2 + Kmat(n,:,3).^2).^(1/2))/impPROJdgn.kmax;
    end
else
    phi = PROJimp.projdist.IV(1,:);
    for n = 1:length(phi)/2
        rKmag(n,:) = ((Kmat(n,:,1).^2 + Kmat(n,:,2).^2 + Kmat(n,:,3).^2).^(1/2))/PROJdgn.kmax;
    end
end
Testing.r = mean(rKmag,1);
Testing.tatr = (PROJimp.sampstart:PROJimp.dwell:PROJimp.tro);
Testing.meanRelKmax = PROJimp.meanrelkmax;
       
SCRPTGBLout.SCRPTipt = SCRPTipt;
SCRPTGBLout.PROJimp = PROJimp;
SCRPTGBLout.PROJdgn = PROJdgn;
SCRPTGBLout.impPROJdgn = impPROJdgn;
SCRPTGBLout.Kmat = Kmat;
SCRPTGBLout.Testing = Testing;
%SCRPTGBLout.T = T;                                 % file size too big...
%SCRPTGBLout.KSA = KSA;

