%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Grid_SDC_v1b_perfsamptesting(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

err.flag = 0;
err.msg = '';

subsamp = str2double(SCRPTipt(strcmp('SubSamp',{SCRPTipt.labelstr})).entrystr); 

if not(isfield(SCRPTGBL.KernLoadfunc,'KRNprms'))
    err.flag = 1;
    err.msg = '(Re)Load KernFile';
    return
end

SDC = 0;
[file,path] = uigetfile();
load([path,file]);
whos
SDC = SDC;

%---------------------------------------------
% Kernel Load / Test
%---------------------------------------------
KRNprms = SCRPTGBL.KernLoadfunc.KRNprms;
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
KERN.Kern = SCRPTGBL.KernLoadfunc.Kern;
CONV.chW = ceil(((KRNprms.W*subsamp)-2)/2);                    % with mFCMexSingleR_v3

if (CONV.chW+1)*KERN.iKern > length(KERN.Kern)
    err.flag = 1;
    err.msg = 'zW of Kernel not large enough';
    return
end

%---------------------------------------------
% Normalize to Grid
%---------------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(kSampArr,0,0,kmax,kstep,KRNprms.W,subsamp,'A2A');

%---------------------------------------------
% Grid Data
%---------------------------------------------
Status('busy','Gridding Ones');
StatLev = 2;
[Cdat,~,~] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KERN,SDC,CONV,StatLev);  

SCRPTipt(strcmp('Ksz',{SCRPTipt.labelstr})).entrystr = num2str(Ksz);

Cdat = Cdat/KRNprms.convscaleval;

SCRPTGBL.Cdat = Cdat;

Status('done','');
Status2('done','',2);
Status2('done','',3);

