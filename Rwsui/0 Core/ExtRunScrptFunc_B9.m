%====================================================
%
%====================================================

function [ExtRunInfo,err] = ExtRunScrptFunc_B9(treepanipt,curpanipt,treecellarray,tab,panelnum,ExtRunInfo)

Status('busy','Run Script');
Status2('busy',[],2);
Status2('busy',[],3);

global SCRPTPATHS
global SCRPTIPTGBL
global SCRPTGBL
global FIGOBJS
gbldata = SCRPTGBL.(tab){panelnum,treecellarray(1)};

SCRPTipt = LabelGet(tab,panelnum);
RWSUI.treepanipt = treepanipt;
RWSUI.curpanipt = curpanipt;
RWSUI.tab = tab;
RWSUI.panelnum = panelnum;
RWSUI.scrptnum = treecellarray(1);
RWSUI.ExtRunInfo = ExtRunInfo;

if treepanipt(2) == 0
    RWSUI.funclabel = '';
    RWSUI.runfunc = (SCRPTipt(treepanipt(1)).entrystr);
    RWSUI.treecellarray = treecellarray(1);
    RWSUI.curcellarray = treecellarray(2);
elseif treepanipt(3) == 0
    RWSUI.funclabel = {SCRPTipt(treepanipt(2)).labelstr};
    RWSUI.runfunc = (SCRPTipt(treepanipt(2)).entrystr);
    RWSUI.treecellarray = treecellarray(1:2);
    RWSUI.curcellarray = treecellarray(3);
else
    RWSUI.funclabel = {SCRPTipt(treepanipt(2)).labelstr,SCRPTipt(treepanipt(3)).labelstr};
    RWSUI.runfunc = (SCRPTipt(treepanipt(3)).entrystr);
    RWSUI.treecellarray = treecellarray(1:3);
    RWSUI.curcellarray = treecellarray(4);    
end

%--------------------------------------------
% Run
%--------------------------------------------
[CurrentScript,CurrentTree,AllTrees] = BuildInputTrees_B9(SCRPTipt,RWSUI);
gbldata.CurrentScript = CurrentScript;
gbldata.CurrentTree = CurrentTree;
gbldata.AllTrees = AllTrees;
gbldata.RWSUI = RWSUI;
if not(exist(RWSUI.runfunc,'file'))
    err.flag = 1;
    err.msg = 'Reload Script';
    return
end   
runfunc = str2func(RWSUI.runfunc);
[SCRPTipt,gbldata,err] = runfunc(SCRPTipt,gbldata);

%--------------------------------------------
% Display Output
%--------------------------------------------
% if isfield(gbldata.RWSUI,'SaveVariables')
%     VAR = gbldata.RWSUI.SaveVariables{1};
%     if isfield(VAR,'ExpDisp')
%         if isfield(gbldata.RWSUI,'axnum')
%             FIGOBJS.(tab).Info(gbldata.RWSUI.axnum).String = VAR.ExpDisp;
%         else
%             FIGOBJS.(tab).Info.String = VAR.ExpDisp;
%         end
%     end
% end

%--------------------------------------------
% Test for New Run Method
%--------------------------------------------
if isfield(gbldata,'newrunmeth')
    FUNCDAT = gbldata.FUNCDAT;
    INPUT = gbldata.INPUT;
    gbldata = rmfield(gbldata,{'FUNCDAT','INPUT','newrunmeth'});
    func = str2func([FUNCDAT.method,'_Func']);
    [FUNCDAT,err] = func(INPUT,FUNCDAT);
    if err.flag ~= 0
        ErrDisp(err);
        return
    end
    func = str2func([FUNCDAT.method,'_Output']);
    [SCRPTipt,gbldata,err] = func(SCRPTipt,gbldata,FUNCDAT);
    if err.flag ~= 0
        ErrDisp(err);
        return
    end
end

%--------------------------------------------
% Leave 'As Is'
%--------------------------------------------
RWSUI = gbldata.RWSUI;
if isfield(RWSUI,'KeepEdit')
    if strcmp(RWSUI.KeepEdit,'yes')
        return
    end
end

%--------------------------------------------
% Display
%--------------------------------------------
Options.excludelocaloutput = 'yes';
if not(err.flag)
    Options.makelocalcurrent = 'yes';
end
Options.scrptnum = RWSUI.scrptnum;
[CellArray0] = PANlab2CellArray_B9(SCRPTipt,Options);
CellArray = CellArray0;
if isfield(RWSUI,'LocalOutput')
    temp = CellArray{RWSUI.scrptnum,2};
    L = length(temp);
    for n = 1:length(RWSUI.LocalOutput)
        L = L+1;
        temp{L,1}.entrytype = RWSUI.LocalOutput(n).type; 
        temp{L,1}.labelstr = RWSUI.LocalOutput(n).label; 
        temp{L,1}.entrystr = RWSUI.LocalOutput(n).value;
        temp{L,2} = cell(1);
    end
    CellArray{RWSUI.scrptnum,2} = temp;
end
[SCRPTipt] = PanelRoutine(CellArray,tab,panelnum);
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,tab,panelnum);

%--------------------------------------------
% Return Global
%--------------------------------------------
gbldata = rmfield(gbldata,'CurrentScript');
gbldata = rmfield(gbldata,'CurrentTree');
gbldata = rmfield(gbldata,'AllTrees');
gbldata = rmfield(gbldata,'RWSUI');
SCRPTGBL.(tab){panelnum,treecellarray(1)} = gbldata;

%--------------------------------------------
% Return if Error
%--------------------------------------------
if err.flag ~= 0
    ErrDisp(err);
    return
end

%--------------------------------------------
% Assign New Default Parameters
%--------------------------------------------
SCRPTIPTGBL.(tab)(panelnum).default(RWSUI.scrptnum,:) = CellArray0(RWSUI.scrptnum,:);

%--------------------------------------------
% Save
%--------------------------------------------
savescript = 0;
if isfield(RWSUI,'SaveScript')
    if strcmp(RWSUI.SaveScript,'yes')
        Status('busy','Save');
        saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
        saveData = cell2struct(RWSUI.SaveVariables,RWSUI.SaveVariableNames,2);
        saveGlobalNames = RWSUI.SaveGlobalNames;
        save([RWSUI.SaveScriptPath,RWSUI.SaveScriptName],'saveSCRPTcellarray','saveData','saveGlobalNames');
        savescript = 1;
    end
end
if isfield(RWSUI,'SaveScriptOption') && savescript == 0
    if strcmp(RWSUI.SaveScriptOption,'yes') || strcmp(RWSUI.SaveScriptOption,'auto')
        Status2('busy','Save Script and Data',1);        
        if strcmp(RWSUI.SaveScriptOption,'yes')
            button = questdlg('Save Script and Data?');
        else
            button = 'Yes';
        end
        if strcmp(button,'Yes')
            if strcmp(RWSUI.SaveScriptPath,'outloc')
                searchloc = SCRPTPATHS.(tab)(panelnum).outloc;
            else
                searchloc = RWSUI.SaveScriptPath;
            end
            if not(iscell(RWSUI.SaveScriptName));
                if strcmp(RWSUI.SaveScriptOption,'yes')
                    [file,path] = uiputfile('*.mat','Save Script and Data',[searchloc,'\',RWSUI.SaveScriptName]);
                else
                    file = RWSUI.SaveScriptName;
                    path = [searchloc,'\'];
                end    
                if not(path == 0)
                    Status('busy','Save');
                    saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
                    saveData = cell2struct(RWSUI.SaveVariables,RWSUI.SaveVariableNames,2);
                    names = fieldnames(saveData);
                    for m = 1:length(names)
                        saveData.(names{m}).path = path;
                    end
                    saveGlobalNames = RWSUI.SaveGlobalNames;
                    save([path,file],'saveSCRPTcellarray','saveData','saveGlobalNames');
                    SCRPTPATHS.(tab)(panelnum).outloc = path;
                    savescript = 1;
                end
            else
                for n = 1:length(RWSUI.SaveScriptName)
                    if strcmp(RWSUI.SaveScriptOption,'yes')
                        [file,path] = uiputfile('*.mat','Save Script and Data',[searchloc,'\',RWSUI.SaveScriptName{n}]);
                    else
                        file = RWSUI.SaveScriptName{n};
                        path = [searchloc,'\'];
                    end   
                    if not(path == 0)
                        Status('busy','Save');
                        saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
                        saveData = cell2struct(RWSUI.SaveVariables(n),RWSUI.SaveVariableNames(n),2);
                        names = fieldnames(saveData);
                        for m = 1:length(names)
                            saveData.(names{m}).path = path;
                        end
                        saveGlobalNames = RWSUI.SaveGlobalNames{n};
                        save([path,file],'saveSCRPTcellarray','saveData','saveGlobalNames');
                        SCRPTPATHS.(tab)(panelnum).outloc = path;
                        savescript = 1;
                    end
                end
            end
        end
    end
end

%--------------------------------------------
% Assign TOTALGBL
%--------------------------------------------     
if isfield(RWSUI,'SaveGlobal')
    if strcmp(RWSUI.SaveGlobal,'yes')
        if savescript == 0
            saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
            saveGlobalNames = RWSUI.SaveGlobalNames;
            saveData = RWSUI.SaveVariables{1};
        elseif savescript == 1
            names = fieldnames(saveData);
            saveData = saveData.(names{1});
        end
        saveData.saveSCRPTcellarray = saveSCRPTcellarray;
        totalgbl = [saveGlobalNames;{saveData}];
        from = 'Script';
        totgblnum = Load_TOTALGBL(totalgbl,tab,from);
    end

    %--------------------------------------------
    % Plot
    %--------------------------------------------     
    if isfield(RWSUI,'CompassDisplay')
        if strcmp(RWSUI.CompassDisplay.do,'Yes')
            CurTab = FIGOBJS.IM.CurrentImage;
            CurTab = CurTab + 1;
            if CurTab > 10
                CurTab = 1;
            end
            FIGOBJS.IM.CurrentImage = CurTab;
            FIGOBJS.IM.TabGroup.SelectedTab = FIGOBJS.IM.ImTab(CurTab);
            Gbl2Image('IM',CurTab,totgblnum);
        end
    end
end

%--------------------------------------------
% Save For Composite 
%-------------------------------------------- 
saveData = cell2struct(RWSUI.SaveVariables(1),RWSUI.SaveVariableNames(1),2);
saveData.(RWSUI.SaveVariableNames{1}).saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
ExtRunInfo.saveData = saveData;
ExtRunInfo.saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);

Status('done','Script Finished');
    





