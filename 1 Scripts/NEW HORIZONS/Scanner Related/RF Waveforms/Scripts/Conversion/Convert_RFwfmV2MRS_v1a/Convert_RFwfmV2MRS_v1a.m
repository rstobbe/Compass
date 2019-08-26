%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,SCRPTGBL,err] = Convert_RFwfmV2MRS_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Convert RF waveform');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Test_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'RF_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('RF_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('RF_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load RF_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('RF_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load RF_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
WFM.method = SCRPTGBL.CurrentTree.Func;
RFfile = SCRPTGBL.('RF_File_Data').file;

%---------------------------------------------
% Test
%---------------------------------------------
func = str2func([WFM.method,'_Func']);
INPUT.RFfile = RFfile;
[WFM,err] = func(INPUT,WFM);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
%IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
%set(findobj('tag','TestBox'),'string',IMG.ExpDisp);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
%SCRPTGBL.RWSUI.LocalOutput = WFM.PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Test:');
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('Test_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {WFM};
SCRPTGBL.RWSUI.SaveVariableNames = {'WFM'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);



