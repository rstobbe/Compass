%=========================================================
% (v1d) 
%     - Plot removed from default2 file
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Grid_noSDC_v1d(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

subsamp = str2double(SCRPTipt(strcmp('SubSamp',{SCRPTipt.labelstr})).entrystr); 

if not(isfield(SCRPTGBL,'Imp_File'))
    err.flag = 1;
    err.msg = '(Re)Load Imp_File';
    return
end
if not(isfield(SCRPTGBL,'Kern_File'))
    err.flag = 1;
    err.msg = '(Re)Load Kern_File';
    return
end

PROJimp = SCRPTGBL.Imp_File.PROJimp;
PROJdgn = SCRPTGBL.Imp_File.PROJdgn;
Kmat = SCRPTGBL.Imp_File.Kmat;

%---------------------------------------------
% Kernel Load / Test
%---------------------------------------------
KRNprms = SCRPTGBL.Kern_File.KRNprms;
if isfield(KRNprms,'DblKern');
    KRNprms = KRNprms.DblKern;
end
if rem(round(1e9*(1/(KRNprms.res*subsamp)))/1e9,1)
    err.flag = 1;
    err.msg = '1/(kernres*subsamp) not an integer';
    return
elseif rem((KRNprms.W/2)/KRNprms.res,1)
    err.flag = 1;
    err.msg = '(W/2)/kernres not an integer';
    return
end

KERN.W = KRNprms.W*subsamp;
KERN.res = KRNprms.res*subsamp;
KERN.iKern = round(1e9*(1/(KRNprms.res*subsamp)))/1e9;
KERN.Kern = KRNprms.Kern;
CONV.chW = ceil(((KRNprms.W*subsamp)-2)/2);                    % with mFCMexSingleR_v3

if (CONV.chW+1)*KERN.iKern > length(KERN.Kern)
    err.flag = 1;
    err.msg = 'zW of Kernel not large enough';
    return
end

%---------------------------------------------
% Normalize to Grid
%---------------------------------------------
kmax = (PROJimp.meanrelkmax*PROJdgn.kmax);
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJimp.nproj;
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,nproj,npro,kmax,kstep,KRNprms.W,subsamp,'M2A');
clear Kmat

%---------------------------------------------
% Grid Data
%---------------------------------------------
Status('busy','Gridding Ones');
StatLev = 2;
[Cdat,~,~] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KERN,ones(size(Kx)),CONV,StatLev);  

SCRPTGBL.LocalOutput(1).label = 'Ksz';
SCRPTGBL.LocalOutput(1).value = num2str(Ksz);

Cdat = Cdat/KRNprms.convscaleval;
SCRPTGBL.Cdat = Cdat;

Status('done','');
Status2('done','',2);
Status2('done','',3);

