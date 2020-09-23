function CompassStatus2(state,string,N)

global FIGOBJS
global RWSUIGBL
global COMPASSINFO
Status = FIGOBJS.Status;
[M,~] = size(Status);

if not(exist('N','var'))
    N = 1;
end
if isempty(N)
    N = 1;
end
if isempty(string)
    state = 'done';
end

%----------------------------------------
% Change to clas
%----------------------------------------
tab = strcmp(FIGOBJS.TABGP.SelectedTab.Title,RWSUIGBL.AllTabs);
if strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis')
    arr = [0 1 2 0 0 0 0 0];
else
    arr = (1:10);
end
tab = arr(tab);

if strcmp(state,'busy')
    Status(tab,N).BackgroundColor = [0.12,0.35,0.23];    
    Status(tab,N).ForegroundColor = [1 1 1];  
    Status(tab,N).String = string;
    Status(tab,N).Visible = 'on';
elseif strcmp(state,'error')
    Status(tab,N).BackgroundColor = [0.82,0.35,0.23];    
    Status(tab,N).ForegroundColor = [1 1 1];  
    Status(tab,N).String = string;
    Status(tab,N).Visible = 'on';
elseif strcmp(state,'warn') || strcmp(state,'info')
    Status(tab,N).BackgroundColor = [0.52,0.35,0.23];    
    Status(tab,N).ForegroundColor = [1 1 1];  
    Status(tab,N).String = string;
    Status(tab,N).Visible = 'on';
elseif strcmp(state,'done')
    Status(tab,N).Visible = 'off';
elseif strcmp(state,'alt1')
    Status(tab,N).BackgroundColor = [0.48,0.425,0.345];    
    Status(tab,N).ForegroundColor = [0.12 0.35 0.23];  
    Status(tab,N).String = string;
    Status(tab,N).Visible = 'on';
else
    error;
end
drawnow;