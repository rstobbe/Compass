%=====================================================
% (v1a) 
%       - 
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = LocalECC_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Local Eddy-Current Compensation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('GradSet_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'GradDes_File_Data'))
    file = SCRPTGBL.CurrentTree.('GradDes_File').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load GradDes_File';
        ErrDisp(err);
        return
    else
        Status('busy','Load Gradient Design');
        load(file);
        saveData.path = file;
        SCRPTGBL.('GradDes_File_Data') = saveData;
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
GECC.method = SCRPTGBL.CurrentTree.Func;
xtc = SCRPTGBL.CurrentTree.('Xtc');
xmag = SCRPTGBL.CurrentTree.('Xmag');
ytc = SCRPTGBL.CurrentTree.('Ytc');
ymag = SCRPTGBL.CurrentTree.('Ymag');
ztc = SCRPTGBL.CurrentTree.('Ztc');
zmag = SCRPTGBL.CurrentTree.('Zmag');
GECC.wrtgradfunc = SCRPTGBL.CurrentTree.('WrtGradfunc').Func; 
GECC.wrtparamfunc = SCRPTGBL.CurrentTree.('WrtParamfunc').Func; 
GRD = SCRPTGBL.('GradDes_File_Data').GRD;

%---------------------------------------------
% X
%---------------------------------------------
inds1 = strfind(xtc,',');
inds2 = strfind(xmag,',');
if length(inds1) ~= length(inds2)
    err.flag = 1;
    err.msg = '''xtc'' and ''xmag'' must be the same length';
    return
end
if isempty(inds1)
    GECC.xtc = str2double(xtc);
    GECC.xmag = str2double(xmag);
else
    GECC.xtc(1) = str2double(xtc(1:inds1(1)-1));
    GECC.xmag(1) = str2double(xmag(1:inds2(1)-1));    
    for n = 2:length(inds1)
        GECC.xtc(n) = str2double(xtc(inds1(n-1)+1:inds1(n)-1));
        GECC.xmag(n) = str2double(xmag(inds2(n-1)+1:inds1(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    GECC.xtc(length(inds1)+1) = str2double(xtc(inds1(n)+1:length(xtc)));
    GECC.xmag(length(inds1)+1) = str2double(xmag(inds2(n)+1:length(xmag)));     
end

%---------------------------------------------
% Y
%---------------------------------------------
inds1 = strfind(ytc,',');
inds2 = strfind(ymag,',');
if length(inds1) ~= length(inds2)
    err.flag = 1;
    err.msg = '''ytc'' and ''ymag'' must be the same length';
    return
end
if isempty(inds1)
    GECC.ytc = str2double(ytc);
    GECC.ymag = str2double(ymag);
else
    GECC.ytc(1) = str2double(ytc(1:inds1(1)-1));
    GECC.ymag(1) = str2double(ymag(1:inds2(1)-1));    
    for n = 2:length(inds1)
        GECC.ytc(n) = str2double(ytc(inds1(n-1)+1:inds1(n)-1));
        GECC.ymag(n) = str2double(ymag(inds2(n-1)+1:inds1(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    GECC.ytc(length(inds1)+1) = str2double(ytc(inds1(n)+1:length(ytc)));
    GECC.ymag(length(inds1)+1) = str2double(ymag(inds2(n)+1:length(ymag)));     
end

%---------------------------------------------
% X
%---------------------------------------------
inds1 = strfind(ztc,',');
inds2 = strfind(zmag,',');
if length(inds1) ~= length(inds2)
    err.flag = 1;
    err.msg = '''ztc'' and ''zmag'' must be the same length';
    return
end
if isempty(inds1)
    GECC.ztc = str2double(ztc);
    GECC.zmag = str2double(zmag);
else
    GECC.ztc(1) = str2double(ztc(1:inds1(1)-1));
    GECC.zmag(1) = str2double(zmag(1:inds2(1)-1));    
    for n = 2:length(inds1)
        GECC.ztc(n) = str2double(ztc(inds1(n-1)+1:inds1(n)-1));
        GECC.zmag(n) = str2double(zmag(inds2(n-1)+1:inds1(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    GECC.ztc(length(inds1)+1) = str2double(ztc(inds1(n)+1:length(ztc)));
    GECC.zmag(length(inds1)+1) = str2double(zmag(inds2(n)+1:length(zmag)));     
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTGipt = SCRPTGBL.CurrentTree.('WrtGradfunc');
if isfield(SCRPTGBL,('WrtGradfunc_Data'))
    WRTGipt.WrtGradfunc_Data = SCRPTGBL.WrtGradfunc_Data;
end
WRTPipt = SCRPTGBL.CurrentTree.('WrtParamfunc');
if isfield(SCRPTGBL,('WrtParamfunc_Data'))
    WRTPipt.WrtParamfunc_Data = SCRPTGBL.WrtParamfunc_Data;
end

%------------------------------------------
% Get Write Gradient Function Info
%------------------------------------------
func = str2func(GECC.wrtgradfunc);           
[SCRPTipt,WRTG,err] = func(SCRPTipt,WRTGipt);
if err.flag
    return
end

%------------------------------------------
% Get Write Parameter Function Info
%------------------------------------------
func = str2func(GECC.wrtparamfunc);           
[SCRPTipt,WRTP,err] = func(SCRPTipt,WRTPipt);
if err.flag
    return
end

%---------------------------------------------
% Create Gradients
%---------------------------------------------
func = str2func([GECC.method,'_Func']);
INPUT.GECC = GECC;
INPUT.WRTG = WRTG;
INPUT.WRTP = WRTP;
INPUT.GRD = GRD;
[GECC,err] = func(GECC,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Gradient File:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('GradSet_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GECC};
SCRPTGBL.RWSUI.SaveVariableNames = {'GECC'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};
