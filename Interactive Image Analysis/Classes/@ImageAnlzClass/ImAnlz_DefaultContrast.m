%============================================
% 
%============================================
function ImAnlz_DefaultContrast(IMAGEANLZ)

global TOTALGBL

if not(isfield(TOTALGBL{2,IMAGEANLZ.totgblnum}.IMDISP,'DEFDISP'))
    DEFDISP.type = 'abs';
    DEFDISP.colour = 'No';
else
    DEFDISP = TOTALGBL{2,IMAGEANLZ.totgblnum}.IMDISP.DEFDISP;
end

IMAGEANLZ.FIGOBJS

% --- type ---
IMAGEANLZ.IMTYPE = DEFDISP.type;
ind = strfind(IMAGEANLZ.FIGOBJS.ImType.String,DEFDISP.type);
for n = 1:length(ind)
    if not(isempty(ind{n}))
        IMAGEANLZ.FIGOBJS.ImType.Value = n;
        break
    end
end
% --- colour ---
colour = 0;
if isfield(DEFDISP,'colour')
    if strcmp(DEFDISP.colour,'Yes')
        IMAGEANLZ.FIGOBJS.ImColour.Value = 2;
        colormap(IMAGEANLZ.FIGOBJS.ImAxes,IMAGEANLZ.FIGOBJS.Options.ColorMap);
        colour = 1;
    end
end
if colour == 0
    IMAGEANLZ.FIGOBJS.ImColour.Value = 1;
    colormap(IMAGEANLZ.FIGOBJS.ImAxes,IMAGEANLZ.FIGOBJS.Options.GrayMap);
end

    
ImAnlz_InitializeContrast(IMAGEANLZ);
    