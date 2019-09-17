%============================================
% 
%============================================
function ControlChangeControl1(src,event)

global FIGOBJS

TabTitle = event.NewValue.Title;

tab = src.Parent.Tag;
if strcmp(tab,'IM2')
    for n = 1:2
        switch TabTitle
            case 'Contrast'
                FIGOBJS.(tab).ControlTab(n).SelectedTab = FIGOBJS.(tab).ContrastTab(n);
            case 'General'
                FIGOBJS.(tab).ControlTab(n).SelectedTab = FIGOBJS.(tab).PointerTab(n);
            case 'Dimensions'
                FIGOBJS.(tab).ControlTab(n).SelectedTab = FIGOBJS.(tab).DimsTab(n);
            case 'ROI Creation'
                FIGOBJS.(tab).ControlTab(n).SelectedTab = FIGOBJS.(tab).ROITab(n);
            case 'ROI Options'
                FIGOBJS.(tab).ControlTab(n).SelectedTab = FIGOBJS.(tab).ROIOptTab(n);
        end
    end
end
