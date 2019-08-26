%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBLout,err] = LR_Ideal_v1a(SCRPTipt,SCRPTGBL)

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
orient = SCRPTipt(strcmp('Orient',{SCRPTipt.labelstr})).entrystr;
if iscell(orient)
    orient = SCRPTipt(strcmp('Orient',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Orient',{SCRPTipt.labelstr})).entryvalue};
end
PROJimp.orient = orient;
PROJimp.tsmpmeth = SCRPTipt(strcmp('TrajSampfunc',{SCRPTipt.labelstr})).entrystr;
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
if isfield(SCRPTGBL,'T')
    T = SCRPTGBL.T;
    KSA = SCRPTGBL.KSA;
end

%----------------------------------------------------
% Check
%----------------------------------------------------
if not(strcmp(PROJdgn.destype,'LR'))
    err(errnum).flag = 1;
    err(errnum).msg = 'Implementation Method Not Appropriate';
    return
end 

%====================================================
% Generate Projections
%====================================================
Status('busy','Generate Trajectories');
if SCRPTGBL.testing == 0
    genproj = 'generate';
    PROJGBL.AIDipt = AIDipt;
    PROJGBL.genproj = genproj;
    func = str2func(AIDipt.projdes);
    [PROJipt,PROJGBL,err] = func(PROJipt,PROJGBL);
    PROJdgn = PROJGBL.PROJdgn;
    T = PROJGBL.T;
    KSA = PROJGBL.KSA;
end

%----------------------------------------------------
% Define Sampling
%----------------------------------------------------
sampfunc = str2func(PROJimp.tsmpmeth);
SAMP = struct();
[PROJimp,SAMP,SCRPTipt,err] = sampfunc(PROJdgn,PROJimp,SAMP,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%---------------------------------------
% Resample k-Space
%---------------------------------------
samp = (PROJimp.sampstart:PROJimp.dwell:PROJdgn.tro);
projlen = T(length(T));
[L,~,~] = size(KSA);
for n = 1:L
    Kmat(n,:,1) = interp1(PROJdgn.tro*T(n,:)/projlen,KSA(n,:,1)*PROJdgn.kmax,samp);
    Kmat(n,:,2) = interp1(PROJdgn.tro*T(n,:)/projlen,KSA(n,:,2)*PROJdgn.kmax,samp);
    Kmat(n,:,3) = interp1(PROJdgn.tro*T(n,:)/projlen,KSA(n,:,3)*PROJdgn.kmax,samp);
end

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
PROJimp.meanrelkmax = 1;
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'meanRelKmax','0output',PROJimp.meanrelkmax,'0numout');

%---------------------------------------
% Visuals
%---------------------------------------
if strcmp(kVis,'On') 
    figure(2000); hold on; title('Ksamp Traj: 1');
    plot(samp,Kmat(1,:,1),'k-*');       
    plot(samp,Kmat(1,:,2),'k-*');
    plot(samp,Kmat(1,:,3),'k-*');
end

%---------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------
rKmag = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(1/2))/PROJdgn.kmax;
Testing.r = mean(rKmag,1);
Testing.tatr = (PROJimp.sampstart:PROJimp.dwell:PROJimp.tro);
Testing.meanRelKmax = PROJimp.meanrelkmax;
if strcmp(STVis,'On')
    figure(5);
    plot(Testing.tatr,Testing.r,'r');
end
       
SCRPTGBLout.SCRPTGBL = SCRPTGBL;
SCRPTGBLout.SCRPTipt = SCRPTipt;
SCRPTGBLout.PROJimp = PROJimp;
SCRPTGBLout.PROJdgn = PROJdgn;
SCRPTGBLout.PROJdgn = PROJdgn;
SCRPTGBLout.Kmat = Kmat;
SCRPTGBLout.Testing = Testing;

