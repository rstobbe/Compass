%====================================================
%
%====================================================

function ActivateScrptFunc_B9(treepanipt,curpanipt,treecellarray,tab,panelnum)

Status('done','');
Status2('done','',2);
Status2('done','',3);

global RWSUIGBL

if  sum(RWSUIGBL.ActiveScript.treepanipt == treepanipt) && ...
    RWSUIGBL.ActiveScript.curpanipt == curpanipt && ...
    sum(RWSUIGBL.ActiveScript.treecellarray == treecellarray) && ...    
    strcmp(RWSUIGBL.ActiveScript.tab,tab) && ... 
    RWSUIGBL.ActiveScript.panelnum == panelnum
        RWSUIGBL.ActiveScript.treepanipt = [0 0 0 0];
        RWSUIGBL.ActiveScript.curpanipt = 0;
        RWSUIGBL.ActiveScript.treecellarray = [0 0 0 0 0];
        RWSUIGBL.ActiveScript.tab = '';
        RWSUIGBL.ActiveScript.panelnum = 0; 
        SCRPTipt = LabelGet(tab,panelnum);
        SCRPTipt(curpanipt).selstyle = '0pushbutton';
        setfunc = 1;
        DispScriptParam(SCRPTipt,setfunc,tab,panelnum);
else
    if RWSUIGBL.ActiveScript.panelnum ~= 0
        SCRPTipt = LabelGet(RWSUIGBL.ActiveScript.tab,RWSUIGBL.ActiveScript.panelnum);
        SCRPTipt(RWSUIGBL.ActiveScript.curpanipt).selstyle = '0pushbutton';
        setfunc = 1;
        DispScriptParam(SCRPTipt,setfunc,RWSUIGBL.ActiveScript.tab,RWSUIGBL.ActiveScript.panelnum);
    end    
    RWSUIGBL.ActiveScript.treepanipt = treepanipt;
    RWSUIGBL.ActiveScript.curpanipt = curpanipt;
    RWSUIGBL.ActiveScript.treecellarray = treecellarray;
    RWSUIGBL.ActiveScript.tab = tab;
    RWSUIGBL.ActiveScript.panelnum = panelnum;
    SCRPTipt = LabelGet(tab,panelnum);
    SCRPTipt(curpanipt).selstyle = 'activated';
    setfunc = 1;
    DispScriptParam(SCRPTipt,setfunc,tab,panelnum);
end


Status('done','');
    





