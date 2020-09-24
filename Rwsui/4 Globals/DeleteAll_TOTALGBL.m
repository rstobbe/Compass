function DeleteAll_TOTALGBL

global TOTALGBL
global FIGOBJS
global IMAGEANLZ
global COMPASSINFO

TOTALGBL = cell(2,0);
if not(strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis'))
    tablabs = {'ACC','ACC2','ACC3','ACC4'};
    for n = 1:length(tablabs)
        FIGOBJS.(tablabs{n}).GblList.String = cell(0);
        FIGOBJS.(tablabs{n}).GblList.UserData = [];
        FIGOBJS.(tablabs{n}).GblList.Value = [];
        FIGOBJS.(tablabs{n}).Info.String = '';
    end
end
if strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis')
    tablabs = {'IM2','IM3'};
elseif strcmp(COMPASSINFO.USERGBL.setup,'Scripts')
    tablabs = {};
else
    tablabs = {'IM','IM2','IM3','IM4'};
end
for n = 1:length(tablabs)
    FIGOBJS.(tablabs{n}).GblList.String = cell(0);
    FIGOBJS.(tablabs{n}).GblList.UserData = [];
    FIGOBJS.(tablabs{n}).GblList.Value = [];
    for r = 1:IMAGEANLZ.(tablabs{n})(1).axeslen
        if IMAGEANLZ.(tablabs{n})(r).TestAxisActive
            AxisReset(tablabs{n},r);
        end
    end
end