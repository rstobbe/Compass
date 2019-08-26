%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectFidDataCur_v4b(SCRPTipt,SCRPTGBL)

global SCRPTPATHS
global RWSUIGBL

tab = SCRPTGBL.RWSUI.tab;

err.flag = 0;
err.msg = '';

Func = SCRPTGBL.CurrentScript.Func;
Struct = SCRPTGBL.CurrentScript.Struct;
if isempty(RWSUIGBL.Key)
    curloc = Struct.(Func).curloc;
elseif strcmp(RWSUIGBL.Key,'shift')
    curloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc;
else
    curloc = Struct.(Func).curloc;
end
RWSUIGBL.Key = '';


[file,path] = uigetfile('*.*','Select FID Data File',curloc);
if path == 0
    err.flag = 4;
    err.msg = 'FID Data File Not Selected';
    return
end
if strcmp(file,'fid')
    loc = path;
    label = [path,file];
    if length(label) > RWSUIGBL.fullwid
        ind = strfind(loc,filesep);
        n = 1;
        while true
            label = ['...',loc(ind(n):length(loc))];
            if length(label) <= RWSUIGBL.fullwid
                break
            end
            n = n+1;
        end
    end
    if exist([loc,filesep,'params'],'file')
    	DisplayParamsVarian_v1([loc,filesep,'params'],tab);
    end
else    
    loc = [path,file];
    label = loc;
    if length(label) > RWSUIGBL.fullwid
        ind = strfind(loc,filesep);
        n = 1;
        while true
            label = ['...',loc(ind(n)+1:length(loc))];
            if length(label) <= RWSUIGBL.fullwid
                break
            end
            n = n+1;
            if n > length(ind)
                break
            end
        end
    end
    DisplayParamsSMIS_v1(loc);
end
    
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = loc;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('SelectFidDataCur_v4b').curloc = loc;
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

saveData.path = path;
saveData.file = file;

funclabel = SCRPTGBL.RWSUI.funclabel;
callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
if isempty(callingfuncs)
    SCRPTGBL.([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 1
    SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 2
    SCRPTGBL.([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
end

Status('done','FID Data File Selected');


