function totgblnum = Load_TOTALGBL(totalgbl,tab,from)

global TOTALGBL
global FIGOBJS
global COMPASSINFO

%----------------------------------------------------
% Update TOTALGBL
%----------------------------------------------------
N = length(TOTALGBL(1,:));
TOTALGBL(:,N+1) = totalgbl;
totgblnum = N+1;

%----------------------------------------------------
% Test Load Origination
%----------------------------------------------------
loadACCtabs = 0;
loadIMtabs = 0;
if strcmp(from,'Script')
    loadACCtabs = 1;
elseif strcmp(from,'ImageLoad') || strcmp(from,'CompassLoad')
    loadIMtabs = 1;
    writeAcctab = 1;
else
    loadIMtabs = 1;
end

%----------------------------------------------------
% Write ACC tabls
%----------------------------------------------------
if loadACCtabs == 1
    if not(strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis'))
        tablabs = {'ACC','ACC2','ACC3','ACC4'};
        for n = 1:length(tablabs)
            len = length(FIGOBJS.(tablabs{n}).GblList.String);
            FIGOBJS.(tablabs{n}).GblList.String{len+1} = totalgbl{1};
            FIGOBJS.(tablabs{n}).GblList.UserData(len+1).totgblnum = N+1;    
            FIGOBJS.(tablabs{n}).GblList.UserData(len+1).function1 = '';  
            FIGOBJS.(tablabs{n}).GblList.Value = len+1;
        end
    end
    if strcmp(tab(1:2),'IM')
        UpdateInfoLBox(tab,N+1);
    else
        UpdateInfoBox(tab,N+1);
    end
        
    %----------------------------------------------------
    % Test for File Type
    %----------------------------------------------------
    if isfield(totalgbl{2},'type')
        type = totalgbl{2}.type;
    else
        if isfield(totalgbl{2},'Im')
            type = 'Image';
        else 
            type = 'Generic';
        end
    end    
    
    %----------------------------------------------------
    % Determine What to Do with Images
    %----------------------------------------------------
    writeImtab = 0;
    if strcmp(type,'Image') || strcmp(type,'Plot')
        Image = totalgbl{2}.Im;
        if not(isfield(totalgbl{2},'IMDISP'))
            MSTRCT.type = 'abs';
            MSTRCT.dispwid = [0 max(abs(totalgbl{2}.Im(:)))];
            MSTRCT.ImInfo.pixdim = [totalgbl{2}.ReconPars.ImvoxTB,totalgbl{2}.ReconPars.ImvoxLR,totalgbl{2}.ReconPars.ImvoxIO];
            MSTRCT.ImInfo.vox = totalgbl{2}.ReconPars.ImvoxTB*totalgbl{2}.ReconPars.ImvoxLR*totalgbl{2}.ReconPars.ImvoxIO;
            if isfield(totalgbl{2},'ExpDisp')
                MSTRCT.ImInfo.info = totalgbl{2}.ExpDisp;
            else
                MSTRCT.ImInfo.info = '';
            end
            MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
            INPUT.Image = Image;
            INPUT.MSTRCT = MSTRCT;
            IMDISP = ImagingPlotSetup(INPUT);
            totalgbl{2}.IMDISP = IMDISP;
        end
        TOTALGBL(:,N+1) = totalgbl;
        writeImtab = 1;
        writeAcctab = 0;
    end
end

if loadIMtabs == 1
    writeImtab = 1;
end

%----------------------------------------------------
% Write All Imaging Tabs
%----------------------------------------------------
if writeImtab == 1
    if strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis')
        tablabs = {'IM2' 'IM3'};
    else
        tablabs = {'IM' 'IM2' 'IM3' 'IM4'};        
    end
    for n = 1:length(tablabs)
        len = length(FIGOBJS.(tablabs{n}).GblList.String);
        FIGOBJS.(tablabs{n}).GblList.String{len+1} = totalgbl{1};
        FIGOBJS.(tablabs{n}).GblList.UserData(len+1).totgblnum = N+1;    
        FIGOBJS.(tablabs{n}).GblList.UserData(len+1).function1 = 'Gbl2Image';  
        FIGOBJS.(tablabs{n}).GblList.Value = len+1;
        UpdateImageInfoBox(tablabs{n},N+1);
    end
    
    if not(strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis'))
        if writeAcctab == 1
            tablabs = {'ACC','ACC2','ACC3','ACC4'};
            for n = 1:length(tablabs)
                len = length(FIGOBJS.(tablabs{n}).GblList.String);
                FIGOBJS.(tablabs{n}).GblList.String{len+1} = totalgbl{1};
                FIGOBJS.(tablabs{n}).GblList.UserData(len+1).totgblnum = N+1;    
                FIGOBJS.(tablabs{n}).GblList.UserData(len+1).function1 = '';  
                FIGOBJS.(tablabs{n}).GblList.Value = len+1;
            end  
        end
    end
    
end

