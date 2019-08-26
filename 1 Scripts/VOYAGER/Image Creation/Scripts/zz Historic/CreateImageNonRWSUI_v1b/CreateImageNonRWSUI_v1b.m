%====================================================
% (v1b)
%      no functionality change (new run method test) 
%====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateImageNonRWSUI_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Create Image Setup');
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
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Clear Text Box
%---------------------------------------------
set(findobj('tag','TestBox'),'string','');

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Optionfunc_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Optionfunc').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Optionfunc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Optionfunc - path no longer valid';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('Optionfunc_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Optionfunc';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Execfunc_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Execfunc').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Execfunc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Execfunc - path no longer valid';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('Execfunc_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Execfunc';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
IMG.method = SCRPTGBL.CurrentTree.Func;
IMG.selectdatafunc = SCRPTGBL.CurrentTree.('SelectDatafunc').Func;
IMG.optionfunc = SCRPTGBL.('Optionfunc_Data').file;
IMG.execfunc = SCRPTGBL.('Execfunc_Data').file;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
DIRipt = SCRPTGBL.CurrentTree.('SelectDatafunc');
if isfield(SCRPTGBL,('SelectDatafunc_Data'))
    DIRipt.SelectDatafunc_Data = SCRPTGBL.SelectDatafunc_Data;
end

%------------------------------------------
% Get Image Create Function Info
%------------------------------------------
func = str2func(IMG.selectdatafunc);           
[SCRPTipt,SCRPTGBL,DIR,err] = func(SCRPTipt,SCRPTGBL,DIRipt);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
INPUT.DIR = DIR;
SCRPTGBL.newrunmeth = 'Yes';
SCRPTGBL.INPUT = INPUT;
SCRPTGBL.FUNCDAT = IMG;


Status('done','');
Status2('done','',2);
Status2('done','',3);
