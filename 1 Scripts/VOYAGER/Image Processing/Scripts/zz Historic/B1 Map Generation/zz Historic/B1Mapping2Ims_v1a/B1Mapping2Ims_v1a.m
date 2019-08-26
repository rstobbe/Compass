%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = B1Mapping2Ims_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Map B1');
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
% Return Panel Input
%---------------------------------------------
B1MAP.method = SCRPTGBL.CurrentTree.Func;
B1MAP.mapfunc = SCRPTGBL.CurrentTree.('B1Mapfunc').Func;
B1MAP.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Get Image
%---------------------------------------------
if not(isfield(SCRPTGBL,'Image_File1_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Image_File1').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Image_File1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Image_File1 - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Loading Image');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Image_File1_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Image_File1';
        return
    end
end
B1MAP.impath = SCRPTGBL.('Image_File1_Data').path;
if isfield(SCRPTGBL.('Image_File1_Data'),'IMG');
    IMG1 = SCRPTGBL.('Image_File1_Data').IMG;
elseif isfield(SCRPTGBL.('Image_File1_Data'),'FTK');
    IMG1.Im = SCRPTGBL.('Image_File1_Data').FTK;
else
    err.flag = 1;
    err.msg = 'Image_File1 Selection Does Not Contain An Image';
    return
end

if not(isfield(SCRPTGBL,'Image_File2_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Image_File2').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Image_File2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Image_File2 - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Loading Image');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Image_File2_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Image_File2';
        return
    end
end
B1MAP.impath = SCRPTGBL.('Image_File2_Data').path;
if isfield(SCRPTGBL.('Image_File2_Data'),'IMG');
    IMG2 = SCRPTGBL.('Image_File2_Data').IMG;
elseif isfield(SCRPTGBL.('Image_File2_Data'),'FTK');
    IMG2.Im = SCRPTGBL.('Image_File2_Data').FTK;
else
    err.flag = 1;
    err.msg = 'Image_File2 Selection Does Not Contain An Image';
    return
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MAPipt = SCRPTGBL.CurrentTree.('B1Mapfunc');
if isfield(SCRPTGBL,('B1Mapfunc_Data'))
    MAPipt.B1Mapfunc_Data = SCRPTGBL.B1Mapfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get Mapping Function Info
%------------------------------------------
func = str2func(B1MAP.mapfunc);           
[SCRPTipt,MAP,err] = func(SCRPTipt,MAPipt);
if err.flag
    return
end

%------------------------------------------
% Get Display Function Info
%------------------------------------------
func = str2func(B1MAP.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% B1 Map
%---------------------------------------------
func = str2func([B1MAP.method,'_Func']);
INPUT.IMG1 = IMG1;
INPUT.IMG2 = IMG2;
INPUT.MAP = MAP;
INPUT.DISP = DISP;
[B1MAP,err] = func(B1MAP,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
B1MAP.ExpDisp = PanelStruct2Text(B1MAP.PanelOutput);
set(findobj('tag','TestBox'),'string',B1MAP.ExpDisp);

%--------------------------------------------
% Name
%--------------------------------------------
ind = strfind(IMG1.name,'IMG1');
if not(isempty(ind))
    name0 = ['B1MAP_',IMG.name(5:end)];
else
    name0 = 'B1MAP_';
end
name = inputdlg('Name Image:','Name Image',1,{name0});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end
B1MAP.name = name;

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {B1MAP};
SCRPTGBL.RWSUI.SaveVariableNames = 'B1MAP';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

