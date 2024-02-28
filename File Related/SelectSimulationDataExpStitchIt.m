%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectSimulationDataExpStitchIt(SCRPTipt,SCRPTGBL,saveData)

global FIGOBJS
err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load
%---------------------------------------------    
Status('busy','Load Siemens Data');
Status2('done','',2);
Status2('done','',3);

DataObj = SimulationStitchItDataObject(saveData.loc);

FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = DataObj.DataInfo.ExpDisp;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = DataObj.DataInfo.ExpDisp;

saveData.DataObj = DataObj;
saveData.DataInfo = DataObj.DataInfo;
saveData.ExpPars = DataObj.DataInfo.ExpPars;
saveData.ExpDisp = DataObj.DataInfo.ExpDisp;
saveData.PanelOutput = DataObj.DataInfo.PanelOutput;
saveData.Seq = DataObj.DataInfo.Seq;
saveData.Protocol = DataObj.DataInfo.Protocol;
saveData.VolunteerID = DataObj.DataInfo.VolunteerID;
saveData.TrajName = DataObj.DataInfo.TrajName;

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

