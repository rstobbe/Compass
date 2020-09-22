%====================================================
%
%====================================================

function RunExtFunc1_B9(treepanipt,curpanipt,treecellarray,tab,panelnum)

global SCRPTGBL
gbldata = SCRPTGBL.(tab){panelnum,treecellarray(1)};

SCRPTipt = LabelGet(tab,panelnum);
RWSUI.treepanipt = treepanipt;
RWSUI.curpanipt = curpanipt;
RWSUI.tab = tab;
RWSUI.panelnum = panelnum;
RWSUI.scrptnum = treecellarray(1);

if not(isfield(SCRPTipt(curpanipt).entrystruct,'runfunc1'))
    RWSUI.runfunc = SCRPTipt(curpanipt).entrystruct.runfunc; 
else
    RWSUI.runfunc = SCRPTipt(curpanipt).entrystruct.runfunc1;
end
RWSUI.funclabel = SCRPTipt(curpanipt).labelstr;

if treepanipt(2) == 0
    RWSUI.callpanipt = '';
    RWSUI.callingfuncs = '';
    RWSUI.treecellarray = treecellarray(1);
    RWSUI.curcellarray = treecellarray(2);
elseif treepanipt(3) == 0
    RWSUI.callpanipt = treepanipt(2);
    RWSUI.callingfuncs = {SCRPTipt(treepanipt(2)).labelstr};
    RWSUI.treecellarray = treecellarray(1:2);
    RWSUI.curcellarray = treecellarray(3);
elseif treepanipt(4) == 0
    RWSUI.callpanipt = treepanipt(3);
    RWSUI.callingfuncs = {SCRPTipt(treepanipt(2)).labelstr,SCRPTipt(treepanipt(3)).labelstr};
    RWSUI.treecellarray = treecellarray(1:3);
    RWSUI.curcellarray = treecellarray(4);
else
    RWSUI.callpanipt = treepanipt(4);
    RWSUI.callingfuncs = {SCRPTipt(treepanipt(2)).labelstr,SCRPTipt(treepanipt(3)).labelstr,SCRPTipt(treepanipt(4)).labelstr};
    RWSUI.treecellarray = treecellarray(1:4);
    RWSUI.curcellarray = treecellarray(5);    
end

%--------------------------------------------
% Run
%--------------------------------------------
[~,CurrentTree,AllTrees] = BuildInputTrees_B9(SCRPTipt,RWSUI);
CurrentScript.Func = RWSUI.runfunc;
CurrentScript.Struct = SCRPTipt(curpanipt).entrystruct;

if not(exist(RWSUI.runfunc,'file'))
    if isfield(SCRPTipt(curpanipt).entrystruct,'searchpath')
        [file,path] = uigetfile('*.m',['Find ''',RWSUI.runfunc,''' Function'],SCRPTipt(curpanipt).entrystruct.searchpath);
    else
        [file,path] = uigetfile('*.m',['Find ''',RWSUI.runfunc,''' Function'],'');
    end
    if path == 0
        err.flag = 1;
        err.msg = 'function must be found';
        ErrDisp(err);
        return
    end
    addpath(path);
    SCRPTipt(curpanipt).entrystruct.path = path;
    SCRPTipt(curpanipt).entrystruct.searchpath = path;
end
if not(isfield(SCRPTipt(curpanipt).entrystruct,'path'))
    path = '';
    SCRPTipt(curpanipt).entrystruct.path = path;
end
    
gbldata.CurrentScript = CurrentScript;
gbldata.CurrentTree = CurrentTree;
gbldata.AllTrees = AllTrees;
gbldata.RWSUI = RWSUI;
runfunc = str2func(RWSUI.runfunc);
[SCRPTipt,gbldata,err] = runfunc(SCRPTipt,gbldata);

%--------------------------------------------
% Display
%--------------------------------------------
RWSUI = gbldata.RWSUI;
Options.excludelocaloutput = 'no';
Options.scrptnum = RWSUI.scrptnum;
[CellArray0] = PANlab2CellArray_B9(SCRPTipt,Options);
CellArray = CellArray0;
if isfield(RWSUI,'LocalOutput')
    temp = CellArray{RWSUI.scrptnum,2};
    L = length(temp);
    for n = 1:length(RWSUI.LocalOutput)
        temp{L+1,1}.entrytype = 'Output'; 
        temp{L+1,1}.labelstr = RWSUI.LocalOutput(n).label; 
        temp{L+1,1}.entrystr = RWSUI.LocalOutput(n).value; 
        temp{L+1,2} = cell(1);
    end
    CellArray{RWSUI.scrptnum,2} = temp;
end
[SCRPTipt] = PanelRoutine(CellArray,tab,panelnum);
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,tab,panelnum);

%--------------------------------------------
% Return if Error
%--------------------------------------------
if err.flag ~= 0
    ErrDisp(err);
    return
end

gbldata = rmfield(gbldata,'CurrentScript');
gbldata = rmfield(gbldata,'CurrentTree');
gbldata = rmfield(gbldata,'AllTrees');
gbldata = rmfield(gbldata,'RWSUI');
SCRPTGBL.(tab){panelnum,treecellarray(1)} = gbldata;


