function Status_Update(STATUS)

for n = 1:3
    if strcmp(STATUS.state{n},'busy')
        STATUS.Status(STATUS.tab,n).BackgroundColor = [0.12,0.35,0.23];    
        STATUS.Status(STATUS.tab,n).ForegroundColor = [1 1 1];  
        STATUS.Status(STATUS.tab,n).String = STATUS.string{n};
        STATUS.Status(STATUS.tab,n).Visible = 'on';
    elseif strcmp(STATUS.state{n},'error')
        STATUS.Status(STATUS.tab,n).BackgroundColor = [0.82,0.35,0.23];    
        STATUS.Status(STATUS.tab,n).ForegroundColor = [1 1 1];  
        STATUS.Status(STATUS.tab,n).String = STATUS.string{n};
        STATUS.Status(STATUS.tab,n).Visible = 'on';
    elseif strcmp(STATUS.state{n},'warn') || strcmp(STATUS.state{n},'info')
        STATUS.Status(STATUS.tab,n).BackgroundColor = [0.52,0.35,0.23];    
        STATUS.Status(STATUS.tab,n).ForegroundColor = [1 1 1];  
        STATUS.Status(STATUS.tab,n).String = STATUS.string{n};
        STATUS.Status(STATUS.tab,n).Visible = 'on';
    elseif strcmp(STATUS.state{n},'done') || strcmp(STATUS.state{n},'off')
        STATUS.Status(STATUS.tab,n).Visible = 'off';
    elseif strcmp(STATUS.state{n},'alt1')
        STATUS.Status(STATUS.tab,n).BackgroundColor = [0.48,0.425,0.345];    
        STATUS.Status(STATUS.tab,n).ForegroundColor = [0.12 0.35 0.23];  
        STATUS.Status(STATUS.tab,n).String = STATUS.string{n};
        STATUS.Status(STATUS.tab,n).Visible = 'on';
    end
end