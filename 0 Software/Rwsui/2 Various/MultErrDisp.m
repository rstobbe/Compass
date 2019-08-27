%==================================================
% Error Display
%==================================================

function MultErrDisp(err,N)

if N == 1
    stat = findobj('type','uicontrol','tag','ind');
elseif N == 2
    stat = findobj('type','uicontrol','tag','ind2');
elseif N > 2
    stat = findobj('type','uicontrol','tag','ind3');
end

if err(N).flag == 1
    set(stat,'string',['problem: ',err(N).msg],'ForegroundColor',[0.75,0.27,0.13]);  % error - return
elseif err(N).flag == 2
    set(stat,'string',['problem: ',err(N).msg],'ForegroundColor',[0.75,0.27,0.13]);  % error - no return
elseif err(N).flag == 3
    set(stat,'string',['warning: ',err(N).msg],'ForegroundColor',[1,1,0.5]);  % warn - continue
elseif err(N).flag == 4
    set(stat,'String',err(N).msg,'ForegroundColor',[0.12 0.35 0.23]);   % no message - return
end
set(stat,'visible','on');
drawnow;