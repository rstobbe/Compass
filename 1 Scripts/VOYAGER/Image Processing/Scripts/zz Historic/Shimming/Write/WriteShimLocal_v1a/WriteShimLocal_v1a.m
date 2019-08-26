%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = WriteShimLocal_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Write Shim');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Image
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Shim in Global Memory';
    return  
end
if strcmp(TOTALGBL{1,val},'AutoRecon')
    val = val-1;
end
if not(strfind(TOTALGBL{1,val},'SHIM'))
    err.flag = 1;
    err.msg = 'Not a Shim File';
    return
end
SHIM = TOTALGBL{2,val};

%---------------------------------------------
% Get Input
%---------------------------------------------
WRT.method = SCRPTGBL.CurrentTree.Func;
WRT.writefunc = SCRPTGBL.CurrentTree.('Writefunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTFipt = SCRPTGBL.CurrentTree.('Writefunc');
if isfield(SCRPTGBL,('Writefunc_Data'))
    WRTFipt.Writefunc_Data = SCRPTGBL.Writefunc_Data;
end

%------------------------------------------
% Get Write Function Info
%------------------------------------------
func = str2func(WRT.writefunc); 
RWSUI = SCRPTGBL.RWSUI;
[SCRPTipt,SCRPTGBL,WRTF,err] = func(SCRPTipt,SCRPTGBL,WRTFipt,RWSUI);
if err.flag
    return
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([WRT.method,'_Func']);
INPUT.SHIM = SHIM;
INPUT.WRTF = WRTF;
[WRT,err] = func(WRT,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
%WRT.ExpDisp = PanelStruct2Text(WRT.PanelOutput);
%set(findobj('tag','TestBox'),'string',WRT.ExpDisp);

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.KeepEdit = 'yes';

Status('done','');
Status2('done','',2);
Status2('done','',3);

