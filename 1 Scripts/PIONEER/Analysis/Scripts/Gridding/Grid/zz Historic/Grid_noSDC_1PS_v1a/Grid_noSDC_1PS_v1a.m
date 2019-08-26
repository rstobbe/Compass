%=========================================================
% Gridding Large Matricies
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Grid_noSDC_1PS_v1a(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

err.flag = 0;
err.msg = '';

subsamp = str2double(SCRPTipt(strcmp('SubSamp',{SCRPTipt.labelstr})).entrystr); 

PROJimp = SCRPTGBL.Imp_File.PROJimp;
PROJdgn = SCRPTGBL.Imp_File.PROJdgn;
Kmat = SCRPTGBL.Imp_File.Kmat;
kmax = (PROJimp.meanrelkmax*PROJdgn.kmax);
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJdgn.nproj;

KRNprms = SCRPTGBL.KRNprms;
KERN.W = KRNprms.W*subsamp;
KERN.res = KRNprms.res*subsamp;
KERN.iKern = 1/(KRNprms.res*subsamp);
KERN.Kern = SCRPTGBL.Kern;
CONV.chW = ceil(((KRNprms.W*subsamp)-2)/2);                    % with mFCMexSingleR_v3
StatLev = 2;

if rem(1/(KRNprms.res*subsamp),1)
    err.flag = 1;
    err.msg = '1/(kernres*subsamp) not an integer';
    return
elseif rem((KRNprms.W/2)/KRNprms.res,1)
    err.flag = 1;
    err.msg = '(W/2)/kernres not an integer';
    return
end

kmax = max(max((Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2).^(0.5)));

for n = 1:nproj
    PROJNO = n
    KmatSub = Kmat(n,:,:);
    nprojSub = 1; 
    [Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(KmatSub,nprojSub,npro,kmax,kstep,KRNprms.W,subsamp,'M2A');
    Status('busy','Gridding Ones');
    [Cdat0,~,~] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KERN,ones(size(Kx)),CONV,StatLev);  
    if n == 1
        Cdat = Cdat0;
    else
        Cdat = Cdat + Cdat0;
    end
end

SCRPTipt(strcmp('Ksz',{SCRPTipt.labelstr})).entrystr = num2str(Ksz);

Cdat = Cdat/KRNprms.convscaleval;
Cdat = Cdat/PROJimp.osamp;

SCRPTGBL.Cdat = Cdat;

Status('done','');
Status2('done','',2);
Status2('done','',3);



