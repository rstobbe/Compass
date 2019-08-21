%=========================================================
% 
%=========================================================

function [SCRPTipt] = PanelRoutine(Current,tab,panelnum)
    
SCRPTipt.number = [];
SCRPTipt.entrystyle = [];
SCRPTipt.entrystr = [];
SCRPTipt.entryvalue = [];
SCRPTipt.labelstyle = [];
SCRPTipt.labelstr = [];
SCRPTipt.selstyle = [];
SCRPTipt.selstr = [];
SCRPTipt.selfunction1 = [];
SCRPTipt.selfunction2 = [];
SCRPTipt.entrystruct = [];

if isempty(Current)
    return
end

i = 0;
for a = 1:length(Current(:,1))        
    do = 1;
    if do == 1
        if i ~= 0
            i = i+1;
            SCRPTipt(i).number = i;
            SCRPTipt(i).labelstr = 'Space';
            SCRPTipt(i).entrystr = '';
            SCRPTipt(i).labelstyle = '0space';
            SCRPTipt(i).selstyle = '0off';
            SCRPTipt(i).entryvalue = 0;
            SCRPTipt(i).selstr = '';
            SCRPTipt(i).entrystyle = '0text';
            SCRPTipt(i).entrystruct.entrytype = 'Space';
            SCRPTipt(i).entrystruct.labelstr = 'Space';
            SCRPTipt(i).entrystruct.entrystr = '';
            SCRPTipt(i).entrystruct.callingfunc = '';
            SCRPTipt(i).entrystruct.funclevel = 2;
            SCRPTipt(i).entrystruct.entryvalue = 0;
        end 
    end
    i = i+1;
    SCRPTipt(i).number = i;
    SCRPTipt(i).labelstr = Current{a,1}.labelstr;
    SCRPTipt(i).entrystr = Current{a,1}.entrystr;        
    SCRPTipt(i).labelstyle = '0labellvl1';
    SCRPTipt(i).selstyle = '0pushbutton';
    SCRPTipt(i).entryvalue = 0;        
    SCRPTipt(i).selstr = 'Select';
    SCRPTipt(i).entrystyle = '0text';
    SCRPTipt(i).selfunction1 = ['SelectScrptDefault_B9(',num2str(panelnum),',''',tab,''',',num2str(a),')'];
    SCRPTipt(i).selfunction2 = ['ScriptOptions(',num2str(panelnum),',''',tab,''',',num2str(a),')'];
    SCRPTipt(i).entrystruct = Current{a,1};
    SCRPTipt(i).entrystruct.callingfunc = '';
    SCRPTipt(i).entrystruct.funclevel = 1;
    SCRPTipt(i).entrystruct.scrptnum = a;
    CallingFunc1 = Current{a,1}.entrystr;
    N = i;
    M = 0;
    P = 0;
    D = 0;
    
%-------------------------------------------
% Level 2
%-------------------------------------------
    for b = 1:length(Current{a,2}(:,1))
        if isempty(Current{a,2}{b,1})
            break
        end
        i = i+1; 
        lvl = 2;
        c = 0;
        d = 0;
        e = 0;
        Struct = Current{a,2}{b,1};
        [SCRPTipt] = Build_SCRPTipt(SCRPTipt,Struct,CallingFunc1,N,M,P,D,i,a,b,c,d,e,tab,panelnum,lvl);
        CallingFunc2 = Struct.entrystr;
        M = i;
        
%-------------------------------------------
% Level 3
%-------------------------------------------
        for c = 1:length(Current{a,2}{b,2}(:,1))        
            if isempty(Current{a,2}{b,2}{c,1})
                M = 0;
                break
            end
            i = i+1;
            lvl = 3;
            d = 0;
            e = 0;
            Struct = Current{a,2}{b,2}{c,1}; 
            [SCRPTipt] = Build_SCRPTipt(SCRPTipt,Struct,CallingFunc2,N,M,P,D,i,a,b,c,d,e,tab,panelnum,lvl);
            CallingFunc3 = Struct.entrystr;
            P = i;               

%-------------------------------------------
% Level 4
%-------------------------------------------
            for d = 1:length(Current{a,2}{b,2}{c,2}(:,1))        
                if isempty(Current{a,2}{b,2}{c,2}{d,1})
                    P = 0;
                    break
                end
                i = i+1;
                lvl = 4;
                e = 0;
                Struct = Current{a,2}{b,2}{c,2}{d,1}; 
                [SCRPTipt] = Build_SCRPTipt(SCRPTipt,Struct,CallingFunc3,N,M,P,D,i,a,b,c,d,e,tab,panelnum,lvl);
                CallingFunc4 = Struct.entrystr;
                D = i;
    
%-------------------------------------------
% Level 5
%-------------------------------------------
                for e = 1:length(Current{a,2}{b,2}{c,2}{d,2}(:,1))        
                    if isempty(Current{a,2}{b,2}{c,2}{d,2}{e,1})
                        D = 0;
                        break
                    end
                    i = i+1;
                    lvl = 5;
                    Struct = Current{a,2}{b,2}{c,2}{d,2}{e,1}; 
                    [SCRPTipt] = Build_SCRPTipt(SCRPTipt,Struct,CallingFunc4,N,M,P,D,i,a,b,c,d,e,tab,panelnum,lvl);          
                end
                D = 0;
            end
            P = 0;
        end
        M = 0;
    end
end
    
%=========================================================
% 
%=========================================================
function [SCRPTipt] = Build_SCRPTipt(SCRPTipt,Struct,CallingFunc,N,M,P,D,i,a,b,c,d,e,tab,panelnum,lvl)

SCRPTipt(i).number = i;
SCRPTipt(i).labelstr = Struct.labelstr;
SCRPTipt(i).entrystr = Struct.entrystr;
SCRPTipt(i).entrystruct = Struct;
SCRPTipt(i).entrystruct.callingfunc = CallingFunc;
SCRPTipt(i).entrystruct.funclevel = lvl;
%-------------------------------------------
% Input
%-------------------------------------------
if strcmp(Struct.entrytype,'Input');
    %SCRPTipt(i).labelstyle = ['0labellvl',num2str(lvl)];
    SCRPTipt(i).labelstyle = '0labellvl5';
    SCRPTipt(i).selstyle = '0pushbutton';
    SCRPTipt(i).entryvalue = 0;
    if Struct.altval == 0     
        SCRPTipt(i).selstr = 'Edit';
        SCRPTipt(i).entrystyle = '0text';
        SCRPTipt(i).selfunction1 = ['PanelEdit_B9([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),');'];
        SCRPTipt(i).selfunction2 = [];
    elseif Struct.altval == 1
        SCRPTipt(i).selstr = 'Return';
        SCRPTipt(i).entrystyle = '2edit';
        SCRPTipt(i).selfunction1 = ['PanelEditReturn_B9(',num2str(i),',''',tab,''',',num2str(panelnum),')'];
        SCRPTipt(i).selfunction2 = [];
    end
%-------------------------------------------
% Static Input
%-------------------------------------------
elseif strcmp(Struct.entrytype,'StatInput');
    %SCRPTipt(i).labelstyle = ['0labellvl',num2str(lvl)];
    SCRPTipt(i).labelstyle = '0labellvl5';
    SCRPTipt(i).selstyle = '0lockpushbutton';
    SCRPTipt(i).entryvalue = 0;
    SCRPTipt(i).selstr = 'Value';
    SCRPTipt(i).entrystyle = '0text';
%-------------------------------------------
% OutputName
%-------------------------------------------
elseif strcmp(Struct.entrytype,'OutputName');
    %SCRPTipt(i).labelstyle = ['0labellvl',num2str(lvl)];
    SCRPTipt(i).labelstyle = '0labellvl5';
    SCRPTipt(i).selstyle = '0lockpushbutton';
    SCRPTipt(i).entryvalue = 0;
    SCRPTipt(i).selstr = 'Name';
    SCRPTipt(i).entrystyle = '0name1text';     
%-------------------------------------------
% Error
%-------------------------------------------
elseif strcmp(Struct.entrytype,'Error');
    %SCRPTipt(i).labelstyle = ['0labellvl',num2str(lvl)];
    SCRPTipt(i).labelstyle = '0labellvl5';
    SCRPTipt(i).selstyle = '0lockpushbutton';
    SCRPTipt(i).entryvalue = 0;
    SCRPTipt(i).selstr = 'Name';
    SCRPTipt(i).entrystyle = '0errortext';   
%-------------------------------------------
% ScriptName
%-------------------------------------------
elseif strcmp(Struct.entrytype,'ScriptName');
    %SCRPTipt(i).labelstyle = ['0labellvl',num2str(lvl)];
    SCRPTipt(i).labelstyle = '0labellvl5';
    SCRPTipt(i).selstyle = '0lockpushbutton';
    SCRPTipt(i).entryvalue = 0;
    SCRPTipt(i).selstr = 'Name';
    SCRPTipt(i).entrystyle = '0name2text';  
%-------------------------------------------
% Comment
%-------------------------------------------        
elseif strcmp(Struct.entrytype,'Comment');
    %SCRPTipt(i).labelstyle = ['0labellvl',num2str(lvl)];
    SCRPTipt(i).labelstyle = '0labellvl5';
    SCRPTipt(i).selstyle = '0off';
    SCRPTipt(i).entrystyle = '0text';
    SCRPTipt(i).entryvalue = 0; 
%-------------------------------------------
% Choose
%-------------------------------------------    
elseif strcmp(Struct.entrytype,'Choose')
    %SCRPTipt(i).labelstyle = ['0labellvl',num2str(lvl)];
    SCRPTipt(i).labelstyle = '0labellvl5';
    SCRPTipt(i).selstyle = '0pushbutton';
    if Struct.altval == 0         
        SCRPTipt(i).selstr = 'Choose';
        SCRPTipt(i).entrystyle = '0text';
        SCRPTipt(i).selfunction1 = ['PanelEdit_B9([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),');'];
        SCRPTipt(i).selfunction2 = [];
    elseif Struct.altval == 1
        SCRPTipt(i).entrystr = Struct.options;
        SCRPTipt(i).selstr = 'Return';
        SCRPTipt(i).entrystyle = '2popupmenu';
        if Struct.entryvalue == 0
            SCRPTipt(i).entryvalue = 1;
        else
            SCRPTipt(i).entryvalue = Struct.entryvalue;
        end
        SCRPTipt(i).selfunction1 = ['PanelEditReturn_B9(',num2str(i),',''',tab,''',',num2str(panelnum),')'];
        SCRPTipt(i).selfunction2 = [];
    end
%-------------------------------------------
% ScrptFunc
%-------------------------------------------          
elseif strcmp(Struct.entrytype,'ScrptFunc');
    SCRPTipt(i).labelstyle = ['0labellvl',num2str(lvl)];
    %SCRPTipt(i).labelstyle = '0labellvl2';
    SCRPTipt(i).selstyle = '0pushbutton';
    SCRPTipt(i).entryvalue = 0;
    SCRPTipt(i).selstr = 'Select';
    if Struct.altval == 0         
        SCRPTipt(i).entrystyle = '0text';
        SCRPTipt(i).selfunction1 = ['PanelEdit_B9([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),');'];
        SCRPTipt(i).selfunction2 = ['ToggleOptions([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),');'];
    elseif Struct.altval == 1
        SCRPTipt(i).entrystyle = '2text';
        SCRPTipt(i).selfunction1 = ['PanelEdit_B9([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),');'];
        SCRPTipt(i).selfunction2 = ['ToggleOptions([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),');'];
    end
%-------------------------------------------
% RunExtFunc
%-------------------------------------------          
elseif strcmp(Struct.entrytype,'RunExtFunc');
    SCRPTipt(i).labelstyle = '0function';
    SCRPTipt(i).selstyle = '0pushbutton';
    if Struct.altval == 0  
        SCRPTipt(i).entrystyle = '0smalltext';
    elseif Struct.altval == 1 
        SCRPTipt(i).entrystyle = '2smalltext';
    end
    SCRPTipt(i).entryvalue = 0;
    SCRPTipt(i).selfunction1 = ['RunExtFunc1_B9([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),')'];
    SCRPTipt(i).selfunction2 = ['RunExtFunc2_B9([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),')'];
    SCRPTipt(i).selstr = Struct.buttonname;
%-------------------------------------------
% RunScrptFunc
%-------------------------------------------          
elseif strcmp(Struct.entrytype,'RunScrptFunc');
    SCRPTipt(i).labelstyle = '1function';
    SCRPTipt(i).selstyle = '0pushbutton';
    SCRPTipt(i).entrystyle = '0text';
    SCRPTipt(i).entryvalue = 0;
    SCRPTipt(i).selfunction1 = ['RunScrptFunc_B9([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),');'];
    SCRPTipt(i).runscrptfunc1 = {'RunScrptFunc_B9',[N M P D],i,[a b c d e],tab,panelnum};         
    SCRPTipt(i).selfunction2 = ['ActivateScrptFunc_B9([',num2str(N),' ',num2str(M),' ',num2str(P),' ',num2str(D),']',',',num2str(i),',[',num2str(a),' ',num2str(b),' ',num2str(c),' ',num2str(d),' ',num2str(e),']',',''',tab,''',',num2str(panelnum),');']; 
    SCRPTipt(i).selstr = Struct.buttonname;
    SCRPTipt(N).entrystruct.scrpttype = Struct.scrpttype;
%-------------------------------------------
% Output
%-------------------------------------------   
elseif strcmp(Struct.entrytype,'Output');
    SCRPTipt(i).labelstyle = '0output';
    SCRPTipt(i).selstyle = '0off';
    SCRPTipt(i).entrystyle = '0text';
    SCRPTipt(i).entryvalue = 0;
    SCRPTipt(i).selstr = '';
%-------------------------------------------
% OutputWarn
%-------------------------------------------   
elseif strcmp(Struct.entrytype,'OutputWarn');
    SCRPTipt(i).labelstyle = '0output';
    SCRPTipt(i).selstyle = '0off';
    SCRPTipt(i).entrystyle = '0warn';
    SCRPTipt(i).entryvalue = 0;
    SCRPTipt(i).selstr = '';
end

    