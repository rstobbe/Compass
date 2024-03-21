%====================================================
%
%====================================================

function err = RunScrptFunc_B9(treepanipt,curpanipt,treecellarray,tab,panelnum)

Status('busy','Run Script');
Status2('busy',[],2);
Status2('busy',[],3);

global SCRPTPATHS
global SCRPTIPTGBL
global SCRPTGBL
gbldata = SCRPTGBL.(tab){panelnum,treecellarray(1)};

SCRPTipt = LabelGet(tab,panelnum);
RWSUI.treepanipt = treepanipt;
RWSUI.curpanipt = curpanipt;
RWSUI.tab = tab;
RWSUI.panelnum = panelnum;
RWSUI.scrptnum = treecellarray(1);

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
    err.msg = [RWSUI.runfunc,' function not on path'];
    ErrDisp(err);
    return
end   
runfunc = str2func(RWSUI.runfunc);
[SCRPTipt,gbldata,err] = runfunc(SCRPTipt,gbldata);

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
savefigures = [];
if isfield(RWSUI,'SaveScript')
    if strcmp(RWSUI.SaveScript,'yes')
        Status('busy','Save');
        saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
        saveData = cell2struct(RWSUI.SaveVariables,RWSUI.SaveVariableNames,2);          % up above remove cell arrays of one
        saveGlobalNames = RWSUI.SaveGlobalNames;
        save([RWSUI.SaveScriptPath,RWSUI.SaveScriptName],'saveSCRPTcellarray','saveData','saveGlobalNames');
        savescript = 1;
        saveloc = [RWSUI.SaveScriptPath,RWSUI.SaveScriptName];
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
                    [file,path] = uiputfile('*.mat','Save Script and Data',[searchloc,'\',RWSUI.SaveScriptName,'.mat']);
                    saveloc = [path,file];
                    RWSUI.SaveVariables.path = path;
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
                    if isprop(RWSUI.SaveVariables,'Figure')
                        savefigures = RWSUI.SaveVariables.Figure;           
                    end
                    RWSUI.SaveGlobalNames = strtok(file,'.');
                    saveGlobalNames = RWSUI.SaveGlobalNames;
                    if iscell(RWSUI.SaveVariableNames)
                        RWSUI.SaveVariableNames = RWSUI.SaveVariableNames{1};
                        RWSUI.SaveVariables = RWSUI.SaveVariables{1};
                    end
                    saveData.(RWSUI.SaveVariableNames) = RWSUI.SaveVariables;                   % up above remove cell arrays of one
                    saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
                    save([path,file],'saveSCRPTcellarray','saveData','saveGlobalNames');
                    SCRPTPATHS.(tab)(panelnum).outloc = path;
                    savescript = 1;
                end
            else
                error;                                                                           % up above remove cell arrays of one   (not suppporting multi anymore)
%                 for n = 1:length(RWSUI.SaveScriptName)
%                     if strcmp(RWSUI.SaveScriptOption,'yes')
%                         [file,path] = uiputfile('*.mat','Save Script and Data',[searchloc,'\',RWSUI.SaveScriptName{n}]);
%                         saveloc = [path,file];
%                     else
%                         file = RWSUI.SaveScriptName{n};
%                         path = [searchloc,'\'];
%                     end   
%                     if not(path == 0)
%                         Status('busy','Save');
%                         saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
%                         saveData = cell2struct(RWSUI.SaveVariables(n),RWSUI.SaveVariableNames(n),2);
%                         names = fieldnames(saveData);
%                         for m = 1:length(names)
%                             saveData.(names{m}).path = path;
%                         end
%                         RWSUI.SaveGlobalNames{n} = strtok(file,'.');
%                         saveGlobalNames = RWSUI.SaveGlobalNames{n};
%                         save([path,file],'saveSCRPTcellarray','saveData','saveGlobalNames');
%                         SCRPTPATHS.(tab)(panelnum).outloc = path;
%                         savescript = 1;
%                     end
%                 end
            end
        end
    end
end

%--------------------------------------------
% Save Figures
%--------------------------------------------
global COMPASSINFO
if savescript == 1 && not(isempty(savefigures))
    mkdir(path,RWSUI.SaveGlobalNames)
    for n = 1:length(savefigures)
        inds = strfind(savefigures(n).Name,'.');
        if not(isempty(inds))
            savefigures(n).Name(inds) = 'p';
        end
        pathfile = [path,RWSUI.SaveGlobalNames,'\',savefigures(n).Name];
        savefig(savefigures(n).hFig,pathfile,'compact')
        print(savefigures(n).hFig,pathfile,'-dpng','-r0');            % -r0 is screen resolution 
        if strcmp(savefigures(n).Type,'Graph')
            if strcmp(COMPASSINFO.USERGBL.epssave,'Yes')
                SaveGraphEps(savefigures(n),pathfile);
            end
        elseif strcmp(savefigures(n).Type,'NoEps')
            % NoExport
        else
            if strcmp(COMPASSINFO.USERGBL.epssave,'Yes')
                SaveGraphEps(savefigures(n),pathfile);
            end
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
            saveData = RWSUI.SaveVariables;
        elseif savescript == 1
            names = fieldnames(saveData);
            saveData = saveData.(names{1});
        end
        saveData.saveSCRPTcellarray = saveSCRPTcellarray;
        if isfield(saveData,'Im')
            saveData.ImRam = saveData.Im;
            saveData.Im = gpuArray(saveData.Im);
        end
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
% Save/Load ROIs
%--------------------------------------------
if isfield(RWSUI,'SaveRois')
    if strcmp(RWSUI.SaveRois,'Yes') 
        Status('busy','Save');
        for n = 1:length(RWSUI.ROIARR)
            saveGlobalNames = RWSUI.SaveGlobalNames{n};
            ROI = RWSUI.ROIARR(n);
            indnum = 2;                                                         % should always be..
            SCRPTipt(indnum).entrystr = ROI.roiname;
            DispScriptParam(SCRPTipt,setfunc,tab,panelnum);
            CellArray = PANlab2CellArray_B9(SCRPTipt,Options);
            RWSUI.SaveVariables.path = ROI.savepath;
            RWSUI.SaveVariables.name = ROI.roiname;
            saveData.(RWSUI.SaveVariableNames) = RWSUI.SaveVariables;                   % up above remove cell arrays of one
            saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
            save([ROI.savepath,ROI.roiname],'saveSCRPTcellarray','saveData','saveGlobalNames','ROI');
            SCRPTPATHS.(tab)(panelnum).outloc = ROI.savepath;
            if isfield(RWSUI,'LoadRois')
                if strcmp(RWSUI.LoadRois,'Yes') 
                    if strcmp(RWSUI.tab,'IM1') || strcmp(RWSUI.tab,'IM2') || strcmp(RWSUI.tab,'IM3') || strcmp(RWSUI.tab,'IM4')
                        currentax = gca;
                        axnum = str2double(currentax.Tag);
                        LoadROIExternal(RWSUI.tab,axnum,ROI);
                    end
                end
            end
        end
    end
end



Status('done','Script Finished');
    





