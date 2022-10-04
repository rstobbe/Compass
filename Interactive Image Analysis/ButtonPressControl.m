%=================================================
% What to do when mouse button clicked
%=================================================
function ButtonPressControl(src,event)

global IMAGEANLZ
global FIGOBJS

%--------------------------------------------
% Input Data / Tests
%--------------------------------------------
currentob = gco;
if not(isempty(currentob))
    test = currentob.Type;
    if strcmp(test,'uitab')
        return
    end
end
currentax = gca;
tab = currentax.Parent.Parent.Tag;
if not(isfield(IMAGEANLZ,tab))
    tab = currentax.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(currentax.Tag);
% if not(IMAGEANLZ.(tab)(axnum).TestAxisActive)
%     for n = 1:IMAGEANLZ.(tab)(1).axeslen
%         if IMAGEANLZ.(tab)(n).TestAxisActive    
%             FIGOBJS.Compass.CurrentAxes = FIGOBJS.(tab).ImAxes(n);
%             FIGOBJS.Compass.CurrentObject = FIGOBJS.(tab).ImAxes(n);
%             return
%         end
%     end
% end

%--------------------------------------------
% Test if button press to highlight axis
%--------------------------------------------
prevaxnum = GetFocus(tab);
sethighlight = 0;
if IMAGEANLZ.(tab)(axnum).highlight == 0
    sethighlight = 1;
end

%--------------------------------------------
% Make sure current axis highlighted
%--------------------------------------------
if strcmp(tab,'IM')
    arr = 1:10;
elseif strcmp(tab,'IM2')
    arr = [1 2];
elseif strcmp(tab,'IM3')
    arr = [1 2 3];
elseif strcmp(tab,'IM4')  
    arr = [1 2 3 4];
end
IMAGEANLZ.(tab)(axnum).Highlight;
inds = find(arr~=axnum);
for n = 1:length(inds)
    IMAGEANLZ.(tab)(arr(inds(n))).UnHighlight;
end

%--------------------------------------------
% Highlight and Return
%--------------------------------------------
if sethighlight == 1
    IMAGEANLZ.(tab)(axnum).UpdateStatus; 
    if IMAGEANLZ.(tab)(axnum).GETROIS
        switch IMAGEANLZ.(tab)(axnum).presentation
            case 'Standard'
                %error;         % finish
            case 'Ortho'
                %works now
        end
    end
    return
end

%--------------------------------------------
% Perform action
%--------------------------------------------
switch IMAGEANLZ.(tab)(axnum).buttonfunction
    case 'CreateROI'
        switch IMAGEANLZ.(tab)(axnum).presentation
            case 'Standard'
                CreateROI(currentax,tab,axnum,event);
            case 'Ortho'
                CreateOrthoROI(currentax,tab,axnum,event);
        end
    case 'UpdateOrthoSlices'
        IMAGEANLZ.(tab)(axnum).movefunction = '';
        IMAGEANLZ.(tab)(axnum).buttonfunction = '';
        set(gcf,'pointer','arrow');
        IMAGEANLZ.(tab)(axnum).pointer = 'arrow';
    case 'CreateLine'
        switch IMAGEANLZ.(tab)(axnum).presentation
            case 'Standard'
                CreateLine(currentax,tab,axnum,event);
            case 'Ortho'
                CreateOrthoLine(currentax,tab,axnum,event);
        end
    case 'CreateBox'
        switch IMAGEANLZ.(tab)(axnum).presentation
            case 'Standard'
                CreateBox(currentax,tab,axnum,event);
            case 'Ortho'
                CreateOrthoBox(currentax,tab,axnum,event);
        end
end



