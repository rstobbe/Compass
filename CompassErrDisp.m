%==================================================
% Error Display
%==================================================

function CompassErrDisp(err)

global FIGOBJS
Status = FIGOBJS.Status;
[M,~] = size(Status);

if err.flag == 1
    for m = 1:M
        for n = 2:3
            Status(m,n).Visible = 'off';
        end
        Status(m,1).Visible = 'on';
        set(Status(m,1),'backgroundcolor',[0.82,0.25,0.23]);
        set(Status(m,1),'string',err.msg,'ForegroundColor',[1 1 1]);  % error - return    
    end
elseif err.flag == 2
    for m = 1:M
        for n = 2:3
            Status(m,n).Visible = 'off';
        end
        set(Status(m,1),'backgroundcolor',[0.12,0.35,0.23]);
        set(Status(m,1),'string',err.msg,'ForegroundColor',[0.75,0.27,0.13]);  % error - no return    
    end
elseif err.flag == 3
    for m = 1:M
        for n = 2:3
            Status(m,n).Visible = 'off';
        end
        set(Status(m,1),'backgroundcolor',[0.12,0.35,0.23]);
        set(Status(m,1),'string',err.msg,'ForegroundColor',[1,1,0.5]);  % warn - continue        
    end
elseif err.flag == 4
    for m = 1:M
        for n = 1:3
            Status(m,n).Visible = 'off';
        end
    end
elseif err.flag == 0
    for m = 1:M
        for n = 1:3
            Status(m,n).Visible = 'off';
        end
    end
end
drawnow;