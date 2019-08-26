%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SimImagingMultKern_v1a(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

NoiseAddfunc = SCRPTipt(strcmp('NoiseAddfunc',{SCRPTipt.labelstr})).entrystr; 
Imagefunc = SCRPTipt(strcmp('Imagefunc',{SCRPTipt.labelstr})).entrystr; 

%--------------------------------------
% Sampling Test
%--------------------------------------
if not(isfield(SCRPTGBL,'kSampfunc'))
    err.flag = 1;
    err.msg = '(Re)Load or (Re)Sample k-Space'; 
    return
end

if not(isfield(SCRPTGBL.kSampfunc,'SampDat'))
    err.flag = 1;
    err.msg = '(Re)Load or (Re)Sample k-Space'; 
    return
end

%--------------------------------------
% Remove Old Image if Any
%--------------------------------------
if isfield(SCRPTGBL,'GrdDat')
    SCRPTGBL = rmfield(SCRPTGBL,'GrdDat');
end
if isfield(SCRPTGBL,'Image')
    SCRPTGBL = rmfield(SCRPTGBL,'Image');
end

reload = 0;
if reload == 1
    %--------------------------------------
    % Reload
    %--------------------------------------
    SCRPTGBL.Imp_File = SCRPTGBL.kSampfunc.Imp_File;
    SCRPTGBL.SampDat = SCRPTGBL.kSampfunc.SampDat;

    %--------------------------------------
    % Add Noise
    %--------------------------------------
    func = str2func(NoiseAddfunc);
    SCRPTGBL.RWSUI.funclabel = 'NoiseAddfunc';
    [SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);  
    if err.flag == 1
        return
    end
end

%--------------------------------------
% Create Image
%--------------------------------------
func = str2func(Imagefunc);
SCRPTGBL.RWSUI.funclabel = 'Imagefunc';
[SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);  
if err.flag == 1
    return
end

%SCRPTGBL = rmfield(SCRPTGBL,'Imp_File');
%SCRPTGBL = rmfield(SCRPTGBL,'SampDat');
%SCRPTGBL.Image = SCRPTGBL.Imagefunc.Image;

%--------------------------------------
% Save
%--------------------------------------
%button = questdlg('Save?');
button = 'no';
if strcmp(button,'Yes')
    [file,path] = uiputfile;
    saveSCRPTGBL = SCRPTGBL;
    saveSCRPTGBL = rmfield(saveSCRPTGBL,'kSampfunc');
    saveSCRPTGBL = rmfield(saveSCRPTGBL,'Imagefunc');
    [Out,err] = ExternalSave(SCRPTGBL.scrptnum,SCRPTGBL.scrpt,path);
    SCRPTipt = Out.saveSCRPTipt;
    saveSCRPTipt = Out.saveSCRPTipt;
    saveSCRPTIPTGBL = Out.saveSCRPTIPTGBL;
    saveSCRPTPATHS = Out.saveSCRPTPATHS;
    saveScript = Out.saveScript;
    save([path,file],'saveSCRPTipt','saveSCRPTGBL','saveSCRPTIPTGBL','saveSCRPTPATHS','saveScript');
end
if err.flag ~= 0
    return
end

Status('done','');
Status2('done','',2);
Status2('done','',3);



