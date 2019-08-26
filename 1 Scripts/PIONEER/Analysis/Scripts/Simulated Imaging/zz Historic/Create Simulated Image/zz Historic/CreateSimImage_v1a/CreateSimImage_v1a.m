%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CreateSimImage_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

SS = str2double(SCRPTGBL.CurrentScript.SubSamp);
ZF = str2double(SCRPTGBL.CurrentScript.ZeroFill);

%---------------------------------------------
% Kernel Load / Test
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File'))
    err.flag = 1;
    err.msg = '(Re)Load Imp_File';
    return
end
if not(isfield(SCRPTGBL,'Samp_File'))
    err.flag = 1;
    err.msg = '(Re)Load Samp_File';
    return
end
if not(isfield(SCRPTGBL,'SDC_File'))
    err.flag = 1;
    err.msg = '(Re)Load SDC_File';
    return
end
if not(isfield(SCRPTGBL,'Kern_File'))
    err.flag = 1;
    err.msg = '(Re)Load Kern_File';
    return
end
if not(isfield(SCRPTGBL,'InvFilt_File'))
    err.flag = 1;
    err.msg = '(Re)Load InvFilt_File';
    return
end

%---------------------------------------------
% Convolution Tests
%---------------------------------------------
KRNprms = SCRPTGBL.Kern_File.KRNprms;
IFprms = SCRPTGBL.InvFilt_File.IFprms;
if KRNprms.DesforSS ~= SS
    err.flag = 1;
    err.msg = 'SubSamp not the same at kernel design';
    return
end
if IFprms.SS ~= SS
    err.flag = 1;
    err.msg = 'SubSamp not the same at IF design';
    return
end
if rem(round(1e9*(1/(KRNprms.res*SS)))/1e9,1)
    err.flag = 1;
    err.msg = '1/(kernres*SS) not an integer';
    return
elseif rem((KRNprms.W/2)/KRNprms.res,1)
    err.flag = 1;
    err.msg = '(W/2)/kernres not an integer';
    return
end

%---------------------------------------------
% Data
%---------------------------------------------
SDC = SCRPTGBL.SDC_File.SDC;
Kmat = SCRPTGBL.Imp_File.Kmat;
Dat = SCRPTGBL.Samp_File.SampDat;

%---------------------------------------------
% Convolution Kernel
%---------------------------------------------
KERN.W = KRNprms.W*SS;
KERN.res = KRNprms.res*SS;
KERN.iKern = round(1e9*(1/(KRNprms.res*SS)))/1e9;
KERN.Kern = KRNprms.Kern;
CONV.chW = ceil(((KRNprms.W*SS)-2)/2);                    % with mFCMexSingleR_v3
if (CONV.chW+1)*KERN.iKern > length(KERN.Kern)
    err.flag = 1;
    err.msg = 'zW of Kernel not large enough';
    return
end

%---------------------------------------------
% Normalize to Grid
%---------------------------------------------
PROJimp = SCRPTGBL.Imp_File.PROJimp;
PROJdgn = SCRPTGBL.Imp_File.PROJdgn;
kmax = (PROJimp.meanrelkmax*PROJdgn.kmax);
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJimp.nproj;
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,nproj,npro,kmax,kstep,KRNprms.W,SS,'M2A');
if Ksz > ZF
    err.flag = 1;
    err.msg = 'ZeroFill is too small';
    return    
end

%---------------------------------------------
% Grid Data
%---------------------------------------------
Status('busy','Gridding Data');
StatLev = 2;
[GrdDat,~,~] = mFCMexSingleC_v3(Ksz,Kx,Ky,Kz,KERN,Dat.*SDC,CONV,StatLev);  
GrdDat = GrdDat/KRNprms.convscaleval;

%---------------------------------------------
% Zero Fill / FT
%---------------------------------------------
Status('busy','Zero-Fill / FT');
GrdDat = ifftshift(GrdDat);
Im = zerofill_isotropic_odd_doubles(GrdDat,ZF);
Im = fftshift(ifftn(Im));

%---------------------------------------------
% Inverse Filter
%---------------------------------------------
Im = Im./IFprms.V;

%--------------------------------------
% ReturnFov
%--------------------------------------
returnfov = 0;
if returnfov == 1
    bot = ZF*(SS-1)/(2*SS)+1;
    top = ZF*(SS+1)/(2*SS);
    Im = Im(bot:top,bot:top,bot:top);
    sz = ZF/SS; 
else
    sz = ZF; 
end

%--------------------------------------
% Get Image in right orientation (for some reason flipped)
%--------------------------------------
Im = flipdim(Im,1);
Im = flipdim(Im,2);
Im = flipdim(Im,3);

%---------------------------------------------
% Display
%---------------------------------------------
%SCRPTGBL.RWSUI.LocalOutput(1).label = 'kSz';
%SCRPTGBL.RWSUI.LocalOutput(1).value = num2str(Ksz);

%---------------------------------------------
% Returned
%---------------------------------------------
Image.Im = Im;
Image.kSz = Ksz;
SCRPTGBL.Image = Image;

%--------------------------------------------
% Output
%--------------------------------------------
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = path;
SCRPTGBL.RWSUI.SaveVariables = {Image};
SCRPTGBL.RWSUI.SaveVariableNames = {'Image'};

Status('done','');
Status2('done','',2);
Status2('done','',3);
