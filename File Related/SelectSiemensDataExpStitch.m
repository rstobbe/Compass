%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectSiemensDataExpStitch(SCRPTipt,SCRPTGBL,saveData)

global FIGOBJS
err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load
%---------------------------------------------    
Status('busy','Load Siemens Data');
Status2('done','',2);
Status2('done','',3);

Handler = ReadSiemens();
Handler.SetSiemensDataFile(saveData.loc);
Handler.ReadSiemensHeader;
MrProt = Handler.DataHdr;

FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = Handler.DataInfo.ExpDisp;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = Handler.DataInfo.ExpDisp;

saveData.DataInfo = Handler.DataInfo;
saveData.MrProt = MrProt;
saveData.ExpPars = Handler.DataInfo.ExpPars;
saveData.ExpDisp = Handler.DataInfo.ExpDisp;
saveData.PanelOutput = Handler.DataInfo.PanelOutput;
saveData.Seq = Handler.DataInfo.Seq;
saveData.Protocol = Handler.DataInfo.Protocol;
saveData.VolunteerID = Handler.DataInfo.VolunteerID;
saveData.TrajName = Handler.DataInfo.TrajName;

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

