%=========================================================
% 
%=========================================================

function [GRID,SCRPTipt,err] = Grid_Standard_v1a(GRID,SCRPTipt,err)


ConvKernPath = SCRPTipt(strcmp('ConvKernPath',{SCRPTipt.labelstr})).runfuncoutput{1};

Kernel = 'KBv2_w5_r0p0125_b10p5_zW5p6';
ConvKernFile = [ConvKernPath,'Kaiser_v2\',Kernel];

load(ConvKernFile);
%Kern;
%KRNprms;

kmax = (PROJimp.meanrelkmax*PROJdgn.kmax);
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJdgn.nproj;

[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,nproj,npro,kmax,kstep,KRNprms.W,subsamp,'M2A');

Status('busy','Gridding Ones');

KERN.W = KRNprms.W*subsamp;
KERN.res = KRNprms.res*subsamp;
KERN.iKern = 1/(KRNprms.res*subsamp);
KERN.Kern = SCRPTGBL.Kern;
CONV.chW = ceil(((KRNprms.W*subsamp)-2)/2);                    % with mFCMexSingleR_v3
StatLev = 2;

[Cdat,~,~] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KERN,SDC,CONV,StatLev);  

SCRPTipt(strcmp('Ksz',{SCRPTipt.labelstr})).entrystr = num2str(Ksz);

Cdat = Cdat/KRNprms.convscaleval;
Cdat = Cdat/PROJimp.osamp;

SCRPTGBL.Cdat = Cdat;

% - output inversion filter name...

Status('done','');
Status2('done','',2);
Status2('done','',3);



