%====================================================
% (v1a)
%  
%====================================================

function [SCRPTipt,SCRPTGBL,err] = Imaging_NaPA_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create NaPA Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

importfunc = SCRPTGBL.CurrentTree.ImportFIDfunc.Func;
dccorfunc = SCRPTGBL.CurrentTree.DCcorfunc.Func;
imagefunc = SCRPTGBL.CurrentTree.CreateImagefunc.Func;

SCRPTGBL.FID = struct();
%-----------------------------------------------------
% Import FID
%-----------------------------------------------------
func = str2func(importfunc);
[SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
if err.flag
    ErrDisp(err);
    return
end
SCRPTGBL.FID.FIDmat = SCRPTGBL.FID.origFIDmat;
FIDpath = SCRPTGBL.FID.FIDpath;

%---------------------------------------------
% DCcor FID
%---------------------------------------------
func = str2func(dccorfunc);
[SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
if err.flag
    ErrDisp(err);
    return
end
SCRPTGBL.FID.FIDmat = SCRPTGBL.FID.dccorFIDmat;

%---------------------------------------------
% Plot
%---------------------------------------------
plotFID = 1;
if plotFID == 1;
    figure(1); hold on;
    Dat = SCRPTGBL.FID.origFIDmat;
    abstest = mean(abs(Dat),1);
    plot(abstest,'r');
    Dat = SCRPTGBL.FID.FIDmat;
    abstest = mean(abs(Dat),1);
    plot(abstest,'b');
    title('Original');

    figure(2); hold on;
    Dat = SCRPTGBL.FID.origFIDmat;
    meantest = mean(Dat,1);
    plot(1:length(meantest),real(meantest),'r');
    Dat = SCRPTGBL.FID.FIDmat;
    meantest = mean(Dat,1);
    plot(1:length(meantest),real(meantest),'b');
    title('DCcor');

    figure(3); hold on;
    Dat = SCRPTGBL.FID.FIDmat(:,1);
    plot(abs(Dat));
    title('First Data Point');
end

%---------------------------------------------
% Put in array form
%---------------------------------------------
[nproj,npro] = size(SCRPTGBL.FID.FIDmat);
SCRPTGBL.FID.FIDarr = DatMat2Arr(SCRPTGBL.FID.FIDmat,nproj,npro);

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func(imagefunc);
[SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
if err.flag
    ErrDisp(err);
    return
end

%---------------------------------------------
% Display
%---------------------------------------------
%SCRPTGBL.RWSUI.LocalOutput(1).label = '';
%SCRPTGBL.RWSUI.LocalOutput(1).value = '';

%--------------------------------------------
% Output
%--------------------------------------------
Image = SCRPTGBL.Image;
Image.FID = SCRPTGBL.FID;
SCRPTGBL = rmfield(SCRPTGBL,'Image');
SCRPTGBL = rmfield(SCRPTGBL,'FID');

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = [FIDpath,'\Image'];
SCRPTGBL.RWSUI.SaveVariables = {Image};
SCRPTGBL.RWSUI.SaveVariableNames = {'Image'};


