function OptionsIM_TOTALGBL(Control,Action)

global IMAGEANLZ
global RWSUIGBL
global FIGOBJS

tab = Control.Parent.Parent.Parent.Tag;
%--------------------------------------------------
% Test if in the middle of doing somthing
%--------------------------------------------------
for n = 1:length(IMAGEANLZ.(tab)(1).axeslen)
    if not(isempty(IMAGEANLZ.(tab)(n).buttonfunction))
        return
    end
end

%--------------------------------------------------
% Input
%--------------------------------------------------
val = Control.Value;
for n = 1:length(val)
    if val ~= 0
        totgblnum(n) = Control.UserData(val(n)).totgblnum;
    end
end

%--------------------------------------------------
% Options
%--------------------------------------------------
if isempty(val)
    list = {'Import Images','Import Folder'};    
elseif length(Control.Value) > IMAGEANLZ.(tab)(1).axeslen 
    list = {'Delete Selected','Delete All','Import Images','Import Folder'};
elseif length(Control.Value) > 1 
    list = {'Display Selected','Delete Selected','Delete All','Import Images','Import Folder'};
elseif not(isempty(RWSUIGBL.Key))    
    if strcmp(tab,'IM3')
        if strcmp(RWSUIGBL.Key,'1')       
            Gbl2ImageOrtho(tab,totgblnum);
        elseif strcmp(RWSUIGBL.Key,'2')       
            Gbl2ImageOrthoOverlay(tab,totgblnum);
        end
    else
        for n = 1:IMAGEANLZ.(tab)(1).axeslen
            if strcmp(RWSUIGBL.Key,num2str(n))       
                Gbl2Image(tab,n,totgblnum);
            end
        end
    end
    RWSUIGBL.Character = '';
    RWSUIGBL.Key = '';
    return
elseif strcmp(tab,'IM')
    list = {'Display Current','Display New','Delete','Delete All','Import Images'};
elseif strcmp(tab,'IM2')
    %list = {'Display1','Display2','Display1Overlay','Display2Overlay','Delete','Delete All','Load Image'}; 
    list = {'Display1','Display2','Delete','Delete All','Import Images'}; 
elseif strcmp(tab,'IM3')
    %list = {'OrthoDisplay','OrthoDisplayOverlay','Delete','Delete All','Load Image'};
    list = {'OrthoDisplay','Delete','Delete All','Import Images'};
elseif strcmp(tab,'IM4')
    list = {'Display1','Display2','Display3','Display4','Delete','Delete All','Import Images'}; 
end
[s,v] = listdlg('PromptString','Action:','SelectionMode','single','ListString',list);   
if isempty(s)
    axnum = GetFocus(tab);
    IMAGEANLZ.(tab)(axnum).SetFocus;
    return
end

%--------------------------------------------------
% Axis will no longer be current object
%--------------------------------------------------
for n = 1:length(IMAGEANLZ.(tab)(1).axeslen)
    IMAGEANLZ.(tab)(n).UnHighlight;
end

%--------------------------------------------------
% Do Stuff
%--------------------------------------------------
if strcmp(list{s},'Import Images')
    Load_Image(tab);
elseif strcmp(list{s},'Import Folder')
    Load_ImageFolder(tab);
elseif strcmp(list{s},'Delete')
    Delete_TOTALGBL(totgblnum);
elseif strcmp(list{s},'Delete Selected')
    for n = 1:length(totgblnum)
        Delete_TOTALGBL(totgblnum(n));
    end
elseif strcmp(list{s},'Delete All')
    DeleteAll_TOTALGBL;
elseif strcmp(list{s},'Display1')
    Gbl2Image(tab,1,totgblnum);
elseif strcmp(list{s},'Display2')
    Gbl2Image(tab,2,totgblnum);
elseif strcmp(list{s},'Display1Overlay')
    Gbl2ImageOverlay(tab,1,totgblnum);
elseif strcmp(list{s},'Display2Overlay')
    Gbl2ImageOverlay(tab,2,totgblnum);    
elseif strcmp(list{s},'Display3')
    Gbl2Image(tab,3,totgblnum);
elseif strcmp(list{s},'Display4')
    Gbl2Image(tab,4,totgblnum);
elseif strcmp(list{s},'Display Current')
    CurTab = FIGOBJS.IM.CurrentImage;
    if CurTab == 0
        CurTab = 1;
        FIGOBJS.IM.CurrentImage = 1;
    end
    Gbl2Image(tab,CurTab,totgblnum);
elseif strcmp(list{s},'Display New')
    CurTab = FIGOBJS.IM.CurrentImage;
    CurTab = CurTab + 1;
    if CurTab > 10
        CurTab = 1;
    end
    FIGOBJS.IM.CurrentImage = CurTab;
    FIGOBJS.IM.TabGroup.SelectedTab = FIGOBJS.IM.ImTab(CurTab);
    Gbl2Image(tab,CurTab,totgblnum);
elseif strcmp(list{s},'OrthoDisplay')
    Gbl2ImageOrtho(tab,totgblnum);
elseif strcmp(list{s},'OrthoDisplayOverlay')
    Gbl2ImageOrthoOverlay(tab,totgblnum);
end

axnum = GetFocus(tab);
IMAGEANLZ.(tab)(axnum).SetFocus;
IMAGEANLZ.(tab)(axnum).Highlight;
