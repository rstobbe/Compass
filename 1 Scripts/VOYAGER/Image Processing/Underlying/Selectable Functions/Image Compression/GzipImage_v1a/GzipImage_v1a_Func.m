%===========================================
% 
%===========================================

function [ZIP,err] = GzipImage_v1a_Func(ZIP,INPUT)

Status2('busy','Dummy Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

Images = length(INPUT.IMG);

for n = 1:Images
    file = [INPUT.IMG{n}.path,INPUT.IMG{n}.name];
    gzip(file);
end

Panel(1,:) = {'','','Output'};
ZIP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ZIP.IMG = INPUT.IMG{1};