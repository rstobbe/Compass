%=========================================================
% (v1a) 
%     
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ConvTest_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Test Convolution');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Kern_File_Data'))
    file = SCRPTGBL.CurrentTree.('Kern_File').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    else
        load(file);
        saveData.path = file;
        SCRPTGBL.('Kern_File_Data') = saveData;
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
SS = str2double(SCRPTGBL.CurrentTree.SubSamp);

%---------------------------------------------
% Convolution Tests
%---------------------------------------------
KRNprms = SCRPTGBL.Kern_File_Data.KRNprms;
KRNprms = KRNprms.DblKern;
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
% Sampling Point Location
%---------------------------------------------
Kx = 30;
Ky = 30;
Kz = 30;
Ksz = 60;

figure(200); hold on;
plot(KERN.Kern(:,1,1))

%---------------------------------------------
% Test Convolution
%---------------------------------------------
Status('busy','Test Convolution');
StatLev = 2;
[GrdDat,~,~] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KERN,1,CONV,StatLev);  
test = sum(GrdDat(:))


%--------------------------------------------
% Display
%--------------------------------------------
figure(100); hold on;
plot(GrdDat(:,30,30),'r-*');
%plot(squeeze(GrdDat(Kx,:,Kx)),'-*');
%plot(squeeze(GrdDat(Kx,Kx,:)),'-*');

Status('done','');
Status2('done','',2);
Status2('done','',3);

