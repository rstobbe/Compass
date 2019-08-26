%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectFidDataDef_v4b(SCRPTipt,SCRPTGBL)

global RWSUIGBL
global SCRPTPATHS

tab = SCRPTGBL.RWSUI.tab;

err.flag = 0;
err.msg = '';

if isempty(RWSUIGBL.Key)
    defaultfunc = 'Load From';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;    
elseif strcmp(RWSUIGBL.Key,'shift')
    defaultfunc = 'Load From';
    defloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc;
elseif strcmp(RWSUIGBL.Key,'control')
    defaultfunc = 'Make';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;
else
    defaultfunc = 'Load From';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;
end
RWSUIGBL.Key = '';

switch defaultfunc
    case 'Make'
        Status('busy','Select Folder to Make Default');
        path = uigetdir(defloc,'Select Folder to Make Default');
        if path == 0
            err.flag = 4;
            err.msg = 'Default Folder Not Selected';
            return
        end
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).defloc = path;
        Status('done','Default Directory Selected');
        
    case 'Load From'          

        [file,path] = uigetfile('*.*','Select FID Data File',defloc);
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
                    label = ['...',loc(ind(n)+1:length(loc))];
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
        
        saveData.path = loc;

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
end


