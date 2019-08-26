%=========================================================
% (v1e) 
%     - Update for RWSUI_B9
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Grid_noSDC_v1e(SCRPTipt,SCRPTGBL)

Status('busy','Grid Data with no SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    err.flag = 1;
    err.msg = '(Re) Load Imp_File';
    ErrDisp(err);
    return
end
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
if KRNprms.DesforSS ~= SS
    err.flag = 1;
    err.msg = 'SubSamp not the same as kernel design';
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
% Projection Set Info
%---------------------------------------------
if isfield(SCRPTGBL.Imp_File_Data,'Kmat')
    Kmat = SCRPTGBL.Imp_File_Data.Kmat;
    PROJimp = SCRPTGBL.Imp_File_Data.PROJimp;
    PROJdgn = SCRPTGBL.Imp_File_Data.PROJdgn;
else
    Kmat = SCRPTGBL.Imp_File_Data.IMP.Kmat;
    PROJimp = SCRPTGBL.Imp_File_Data.IMP.PROJimp;
    PROJdgn = SCRPTGBL.Imp_File_Data.IMP.impPROJdgn;
end

%---------------------------------------------
% Normalize to Grid
%---------------------------------------------
if not(isfield(PROJimp,'maxrelkmax'))
    maxrelkmax = 1;
else
    maxrelkmax = PROJimp.maxrelkmax;
end
maxkmax = (maxrelkmax*PROJdgn.kmax);
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJimp.nproj;
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,nproj,npro,maxkmax,kstep,KRNprms.W,SS,'M2A');
clear Kmat

%---------------------------------------------
% Grid Data
%---------------------------------------------
Status('busy','Gridding Ones');
StatLev = 2;
[GrdDat,~,~] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KERN,ones(size(Kx)),CONV,StatLev);  
GrdDat = GrdDat/KRNprms.convscaleval;

%--------------------------------------------
% Display
%--------------------------------------------
[SCRPTGBL] = AddToPanelOutput_B9(SCRPTGBL,'kSz',Ksz,'Output');

%--------------------------------------------
% Output
%--------------------------------------------
Grd.GrdDat = GrdDat;
Grd.Ksz = Ksz;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Output:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

SCRPTGBL.RWSUI.SaveVariables = {Grd};
SCRPTGBL.RWSUI.SaveVariableNames = {'Grd'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'Grid_noSDC';


Status('done','');
Status2('done','',2);
Status2('done','',3);

