%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,SCRPTGBL,err] = Anlz_RFwfmV_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Analyze RF waveform');
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
TST.method = SCRPTGBL.CurrentTree.Func;
TST.pulsedur = str2double(SCRPTGBL.CurrentTree.('PlsDur'));
TST.flipangle = str2double(SCRPTGBL.CurrentTree.('FlipAngle'));
TST.plotbw = str2double(SCRPTGBL.CurrentTree.('PlotBW'));
TST.blochfunc = SCRPTGBL.CurrentTree.('Blochfunc').Func; 
RFfile = SCRPTGBL.('RF_File_Data').file;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
BLOCHipt = SCRPTGBL.CurrentTree.('Blochfunc');
if isfield(SCRPTGBL,('Blochfunc_Data'))
    BLOCHipt.Blochfunc_Data = SCRPTGBL.Blochfunc_Data;
end

%------------------------------------------
% Bloch Excite Function Info
%------------------------------------------
func = str2func(TST.blochfunc);           
[SCRPTipt,BLOCH,err] = func(SCRPTipt,BLOCHipt);
if err.flag
    return
end

%---------------------------------------------
% Test
%---------------------------------------------
func = str2func([TST.method,'_Func']);
INPUT.RFfile = RFfile;
INPUT.BLOCH = BLOCH;
[TST,err] = func(INPUT,TST);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
TST.ExpDisp = PanelStruct2Text(TST.PanelOutput);
set(findobj('tag','TestBox'),'string',TST.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
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

SCRPTGBL.RWSUI.SaveVariables = {TST};
SCRPTGBL.RWSUI.SaveVariableNames = {'TST'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);



