%====================================================
%
%====================================================

function [ExtRunInfo,err] = ExtRunScrptFunc2(Recon,ExtRunInfo)

Status('busy','Run Script');
Status2('busy',[],2);
Status2('busy',[],3);

global SCRPTPATHS

tab = 'Ext';
panelnum = 0;
ScrptCellArray = Recon.ScrptCellArray;
TopScript = ScrptCellArray{1};
[SCRPTipt] = PanelRoutine(ScrptCellArray,tab,panelnum); 
RunButtonInfo = SCRPTipt(end);
runscrptfunc = RunButtonInfo.runscrptfunc1;

RWSUI.treepanipt = runscrptfunc{2};
RWSUI.curpanipt = runscrptfunc{3};
RWSUI.treecellarray = runscrptfunc{4}(1);
RWSUI.curcellarray = runscrptfunc{4}(2);
RWSUI.tab = tab;
RWSUI.panelnum = panelnum;
RWSUI.scrptnum = runscrptfunc{4}(1);
RWSUI.funclabel = '';
RWSUI.runfunc = TopScript.entrystr;
RWSUI.ExtRunInfo = ExtRunInfo;

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

%--------------------------------------------
% Return if Error
%--------------------------------------------
if err.flag ~= 0
    ErrDisp(err);
    return
end

%--------------------------------------------
% Save
%--------------------------------------------
savescript = 0;
savefigures = [];
if isfield(RWSUI,'SaveScript')
    if strcmp(RWSUI.SaveScript,'yes')
        Status('busy','Save');
        if isfield(RWSUI.SaveVariables,'Figure')
            savefigures = RWSUI.SaveVariables.Figure;
            RWSUI.SaveVariables = rmfield(RWSUI.SaveVariables,'Figure');              
        end
        saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
        saveData.(RWSUI.SaveVariableNames) = RWSUI.SaveVariables;
        saveGlobalNames = RWSUI.SaveGlobalNames;
        save([RWSUI.SaveScriptPath,RWSUI.SaveScriptName],'saveSCRPTcellarray','saveData','saveGlobalNames');
        path = RWSUI.SaveScriptPath;
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
            if not(iscell(RWSUI.SaveScriptName))
                if strcmp(RWSUI.SaveScriptOption,'yes')
                    [file,path] = uiputfile('*.mat','Save Script and Data',[searchloc,'\',RWSUI.SaveScriptName]);
                else
                    file = RWSUI.SaveScriptName;
                    path = [searchloc,'\'];
                end    
                if not(path == 0)
                    Status('busy','Save');
                    if isfield(RWSUI.SaveVariables,'Figure')
                        savefigures = RWSUI.SaveVariables.Figure;
                        RWSUI.SaveVariables = rmfield(RWSUI.SaveVariables,'Figure');              
                    end
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
% Save Figures
%--------------------------------------------
if savescript == 1 && not(isempty(savefigures))
    mkdir(path,RWSUI.SaveGlobalNames)
    for n = 1:length(savefigures)
        pathfile = [path,RWSUI.SaveGlobalNames,'\',savefigures(n).Name];
        savefig(savefigures(n).hFig,pathfile,'compact')
        print(savefigures(n).hFig,pathfile,'-dpng','-r0');            % -r0 is screen resolution 
        if strcmp(savefigures(n).Type,'Graph')
            SaveGraphEps(savefigures(n),pathfile);
        elseif strcmp(savefigures(n).Type,'NoEps')
            % NoExport
        else
            SaveGraphEps(savefigures(n),pathfile);                      % seems to work
            %print(savefigures(n).hFig,pathfile,'-depsc');
        end
    end
end

global FIGOBJS
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
saveData = struct();
saveData.(RWSUI.SaveVariableNames) = RWSUI.SaveVariables;
saveData.saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
saveData.(RWSUI.SaveVariableNames).saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
ExtRunInfo.saveData = saveData;

Status('done','Script Finished');
    





