%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectVarianDirDef_v4(SCRPTipt,SCRPTGBL)

global COMPASSINFO
global RWSUIGBL
global SCRPTPATHS

tab = SCRPTGBL.RWSUI.tab;

err.flag = 0;
err.msg = '';

if isempty(RWSUIGBL.Key)
    defaultfunc = 'Load From';
    defloc = [COMPASSINFO.USERGBL.varianloc,'\vnmrsys\data\studies'];    
elseif strcmp(RWSUIGBL.Key,'shift')
    defaultfunc = 'Load From';
    defloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc;
else
    defaultfunc = 'Load From';
    defloc = [COMPASSINFO.USERGBL.varianloc,'\vnmrsys\data\studies'];  
end
RWSUIGBL.Key = '';

switch defaultfunc
                
     case 'Load From' 
        path = uigetdir(defloc,'Select Directory');
        if path == 0
            err.flag = 4;
            err.msg = 'Directory Not Selected';
            return
        end
        loc = path;
        label = loc;
        if length(label) > RWSUIGBL.fullwid
            ind = strfind(loc,filesep);
            n = 1;
            while true
                label = ['...',loc(ind(n)+1:length(loc))];
                if length(label) < RWSUIGBL.fullwid
                    break
                end
                n = n+1;
                if n > length(ind)
                    break
                end
            end
        end

        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = loc;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('SelectVarianDirCur_v4').curloc = loc;
        SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

        saveData.path = path;

        funclabel = SCRPTGBL.RWSUI.funclabel;
        callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
        if isempty(callingfuncs)
            SCRPTGBL.([funclabel,'_Data']) = saveData;
        elseif length(callingfuncs) == 1
            SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
        elseif length(callingfuncs) == 2
            SCRPTGBL.([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
        end
end


Status('done','Directory Selected');


