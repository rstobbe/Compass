%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MultiImSNRCalc_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Multi Imaging SNR Calculation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------


%---------------------------------------------
% Load Input
%---------------------------------------------
SNR.script = SCRPTGBL.CurrentTree.Func;
SNR.minval = str2double(SCRPTGBL.CurrentTree.('MinVal'));

%---------------------------------------------
% Load Images
%---------------------------------------------
Im1 = SCRPTGBL.Image1_File_Data.IMG.Im;
sz = length(Im1);
Ims = zeros(sz,sz,sz,10);
Ims(:,:,:,1) = Im1;
Ims(:,:,:,2) = SCRPTGBL.Image2_File_Data.IMG.Im;
Ims(:,:,:,3) = SCRPTGBL.Image3_File_Data.IMG.Im;
Ims(:,:,:,4) = SCRPTGBL.Image4_File_Data.IMG.Im;
Ims(:,:,:,5) = SCRPTGBL.Image5_File_Data.IMG.Im;
Ims(:,:,:,6) = SCRPTGBL.Image6_File_Data.IMG.Im;
Ims(:,:,:,7) = SCRPTGBL.Image7_File_Data.IMG.Im;
Ims(:,:,:,8) = SCRPTGBL.Image8_File_Data.IMG.Im;
Ims(:,:,:,9) = SCRPTGBL.Image9_File_Data.IMG.Im;
Ims(:,:,:,10) = SCRPTGBL.Image10_File_Data.IMG.Im;

%---------------------------------------------
% Correct DWI Image
%---------------------------------------------
func = str2func([SNR.script,'_Func']);
INPUT.SNR = SNR;
INPUT.Ims = Ims;
[SNR,err] = func(INPUT,SNR);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {SNR};
SCRPTGBL.RWSUI.SaveVariableNames = 'SNR';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

