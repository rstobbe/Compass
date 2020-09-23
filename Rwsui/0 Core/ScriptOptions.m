%=========================================================
% Script Options
%=========================================================

function ScriptOptions(panelnum,tab,scrptnum)

global SCRPTGBL
global DEFFILEGBL
global SCRPTPATHS

[SCRPTipt] = LabelGet(tab,panelnum);
if length(SCRPTipt) == 1
    if panelnum == 1
        [s,v] = listdlg('PromptString','Script Action:','SelectionMode','single','ListString',{'Load From File','Load From Panel','Build Script','','','Load Composite'});
    else
        [s,v] = listdlg('PromptString','Script Action:','SelectionMode','single','ListString',{'Load From File','Load From Panel','Build Script','','',''});
    end
else 
    if panelnum == 1
        [s,v] = listdlg('PromptString','Script Action:','SelectionMode','single','ListString',{'Load From File','Load From Panel','Build Script','Save Script','Remove','Load Composite','Save Composite'});
    else
        [s,v] = listdlg('PromptString','Script Action:','SelectionMode','single','ListString',{'Load From File','Load From Panel','Build Script','Save Script','Remove'});
    end
end
    
if isempty(s)
    return
end

switch s    
case 1
    LoadFromFile_B9(panelnum,tab,scrptnum);
case 2
    LoadInternal_B9(panelnum,tab,scrptnum);
case 3
    SelectScript_B9(panelnum,tab,scrptnum);
case 4  
    MakeScrptDefault_B9(panelnum,tab,scrptnum);
case 5      
    if scrptnum > 1
        error
    end
    Current{1,1}.entrytype = 'Scrpt';
    Current{1,1}.labelstr = 'Script';
    Current{1,1}.entrystr = '';
    Current{1,1}.path = '';
    Current{1,1}.searchpath = SCRPTPATHS.(tab).rootloc;
    Current{1,2}{1,1} = [];
    [SCRPTipt] = PanelRoutine(Current,tab,panelnum);
    setfunc = 1;
    DispScriptParam(SCRPTipt,setfunc,tab,panelnum);
    SCRPTGBL.(tab){panelnum,scrptnum} = [];
    DEFFILEGBL.(tab)(panelnum,scrptnum).file = '';
    DEFFILEGBL.(tab)(panelnum,scrptnum).runfunc = '';     
case 6  
    SelectComposite(panelnum,tab,scrptnum);
case 7  
    MakeComposite_B9(panelnum,tab,scrptnum);
end

