%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Grid_noSDC_v1a(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

err.flag = 0;
err.msg = '';

subsamp = str2double(SCRPTipt(strcmp('SubSamp',{SCRPTipt.labelstr})).entrystr); 

if not(isfield(SCRPTGBL.Kernfunc,'KRNprms'))
    err.flag = 1;
    err.msg = 'Load KernFile';
    return
end

PROJimp = SCRPTGBL.Imp_File.PROJimp;
PROJdgn = SCRPTGBL.Imp_File.PROJdgn;
Kmat = SCRPTGBL.Imp_File.Kmat;
KRNprms = SCRPTGBL.Kernfunc.KRNprms;

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
KERN.Kern = SCRPTGBL.Kernfunc.Kern;
CONV.chW = ceil(((KRNprms.W*subsamp)-2)/2);                    % with mFCMexSingleR_v3

if (CONV.chW+1)*KERN.iKern > length(KERN.Kern)
    err.flag = 1;
    err.msg = 'zW of Kernel not large enough';
    return
end

kmax = (PROJimp.meanrelkmax*PROJdgn.kmax);
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJdgn.nproj;
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,nproj,npro,kmax,kstep,KRNprms.W,subsamp,'M2A');
clear Kmat

Status('busy','Gridding Ones');
StatLev = 2;
[Cdat,~,~] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KERN,ones(size(Kx)),CONV,StatLev);  

SCRPTipt(strcmp('Ksz',{SCRPTipt.labelstr})).entrystr = num2str(Ksz);

Cdat = Cdat/KRNprms.convscaleval;
Cdat = Cdat/PROJimp.osamp;

SCRPTGBL.Cdat = Cdat;

Status('done','');
Status2('done','',2);
Status2('done','',3);


