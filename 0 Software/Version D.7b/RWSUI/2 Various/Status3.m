function Status3(state,string,gui,N)

if strcmp(gui,'FRNT')
    stat = findobj('type','uicontrol','tag',['ind',num2str(N)]);
elseif strcmp(gui,'SSS')
    stat = findobj('type','uicontrol','tag',['comment',num2str(N)]);
end

if strcmp(state,'busy')
    set(stat,'backgroundcolor',[0.12,0.35,0.23]);    
    set(stat,'string',string,'ForegroundColor',[1 1 1]);
elseif strcmp(state,'error')
    set(stat,'backgroundcolor',[0.12,0.35,0.23]);   
    set(stat,'string',string,'ForegroundColor',[0.75,0.27,0.13]);
elseif strcmp(state,'warn')
    set(stat,'backgroundcolor',[0.12,0.35,0.23]);   
    set(stat,'string',string,'ForegroundColor',[1,1,0.5]);
elseif strcmp(state,'done')
    set(stat,'backgroundcolor',[0.12,0.35,0.23]);   
    set(stat,'String',string,'ForegroundColor',[0.12 0.35 0.23]);
elseif strcmp(state,'alt1')
    set(stat,'backgroundcolor',[0.18,0.525,0.345]);   
    set(stat,'String',string,'ForegroundColor',[0.12 0.35 0.23]);
else
    set(stat,'String','not a status','BackgroundColor',[1 1 1],'ForegroundColor',[0 0.4 0.4]);
end
set(stat,'visible','on');
drawnow;