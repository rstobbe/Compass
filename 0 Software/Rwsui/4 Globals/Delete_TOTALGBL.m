function Delete_TOTALGBL(totgblnum)

global TOTALGBL
global FIGOBJS
global IMAGEANLZ
global COMPASSINFO

tTOTALGBL = TOTALGBL;
tTOTALGBL(:,totgblnum) = cell(1);      
if not(strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis'))
    tablabs = {'ACC','ACC2','ACC3','ACC4'};
    for n = 1:length(tablabs)
        FIGOBJS.(tablabs{n}).GblList.String = '';
        FIGOBJS.(tablabs{n}).GblList.UserData = [];    
        FIGOBJS.(tablabs{n}).GblList.Value = 1;
        ind1 = 1;
        for p = 1:length(tTOTALGBL(1,:))
            if not(isempty(tTOTALGBL{1,p}))
                FIGOBJS.(tablabs{n}).GblList.String{ind1} = tTOTALGBL{1,p};
                FIGOBJS.(tablabs{n}).GblList.UserData(ind1).totgblnum = p;    
                FIGOBJS.(tablabs{n}).GblList.UserData(ind1).function1 = '';  
                ind1 = ind1+1;
            end
        end
        FIGOBJS.(tablabs{n}).Info.String = '';
    end
end
if strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis')
    tablabs = {'IM2','IM3'};
else
    tablabs = {'IM','IM2','IM3','IM4'};
end
for n = 1:length(tablabs)
    FIGOBJS.(tablabs{n}).GblList.String = '';
    FIGOBJS.(tablabs{n}).GblList.UserData = [];    
    FIGOBJS.(tablabs{n}).GblList.Value = 1;
    ind1 = 1;
    for p = 1:length(tTOTALGBL(1,:))
        if not(isempty(tTOTALGBL{1,p}))
            if isfield(tTOTALGBL{2,p},'type')
                type = tTOTALGBL{2,p}.type;
            else
                if isfield(tTOTALGBL{2,p},'Im')
                    type = 'Image';
                else 
                    type = 'Generic';
                end
            end
            if strcmp(type,'Image') || strcmp(type,'Plot')
                FIGOBJS.(tablabs{n}).GblList.String{ind1} = tTOTALGBL{1,p};
                FIGOBJS.(tablabs{n}).GblList.UserData(ind1).totgblnum = p;    
                FIGOBJS.(tablabs{n}).GblList.UserData(ind1).function1 = 'Gbl2Image';
                ind1 = ind1+1;
            end
        end
    end
    for r = 1:IMAGEANLZ.(tablabs{n})(1).axeslen
        if IMAGEANLZ.(tablabs{n})(r).TestAxisActive
            axtotgblnum = IMAGEANLZ.(tablabs{n})(r).totgblnum;
            if axtotgblnum == totgblnum
                AxisReset(tablabs{n},r);
            end
            overaxtotgblnum = IMAGEANLZ.(tablabs{n})(r).overtotgblnum;
            if overaxtotgblnum == totgblnum           
                IMAGEANLZ.(tablabs{n})(r).DeleteOverlay;
            end
        end
    end
end
TOTALGBL = tTOTALGBL;


