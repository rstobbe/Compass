%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadVarianDataExp(SCRPTipt,SCRPTGBL,saveData)

global FIGOBJS
err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load
%---------------------------------------------    
Status('busy','Load Varian Data');
Status2('done','',2);
Status2('done','',3);

%---------------------------------------------
% Get Parameters
%---------------------------------------------
[Text,err] = Load_ParamsV_v1a([saveData.path,'params']);
if err.flag == 1
    return
end

%---------------------------------------------
% Create Parameter Structure ('layout' based
%---------------------------------------------
func = str2func('CreateParamStructV_NaGeneral_v1b');
[ExpPars,err] = func(Text);
if err.flag
    return
end

%--------------------------------------------
% Panel
%--------------------------------------------
saveData.DatName = ExpPars.Sequence.protocol;
saveData.TrajName = ['TPI_',ExpPars.Acq.projection_set];

Panel(1,:) = {'FID',saveData.DatName,'Output'};
Panel(2,:) = {'',Text,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ExpDisp = PanelStruct2Text(PanelOutput);
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = ExpDisp;

%--------------------------------------------
% Save
%--------------------------------------------
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = ExpDisp; 
saveData.ExpDisp = ExpDisp;
saveData.PanelOutput = PanelOutput;

funclabel = SCRPTGBL.RWSUI.funclabel;
callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
if isempty(callingfuncs)
    SCRPTGBL.([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 1
    SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 2
    SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
end

Status('done','');
Status2('done','',2);       

