%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Save_Eddy_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get EDDY Currents
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No EDDY in Global Memory';
    return  
end
EDDY = TOTALGBL{2,val};

Time = EDDY.Time;
Geddy = EDDY.Geddy;
B0eddy = EDDY.B0eddy;
[file,path] = uiputfile('*.mat','Save File','D:\I NMR Centre\4.7T\Eddy Current Compensation\Data\2013\');
save([path,file],'Time','Geddy','B0eddy');