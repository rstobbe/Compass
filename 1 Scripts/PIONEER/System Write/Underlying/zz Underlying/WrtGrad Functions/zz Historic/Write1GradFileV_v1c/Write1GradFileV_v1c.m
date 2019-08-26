%===================================================
% (v1c)
%       - Update for RWSUI_BA
%===================================================

function [SCRPTipt,WRTGout,err] = Write1GradFileV_v1c(SCRPTipt,WRTG)

Status('busy','Write 1 Gradient File to Varian');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

WRTGout = struct();
CallingLabel = WRTG.Struct.labelstr;

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(WRTG,[CallingLabel,'_Data']))
    if isfield(WRTG.('GradDefLoc').Struct,'selectedfile')
        file = WRTG.('GradDefLoc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GradDefLoc';
            ErrDisp(err);
            return
        else
            WRTG.([CallingLabel,'_Data']).('GradDefLoc_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradDefLoc';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
WRTGout.GradDefLoc = WRTG.([CallingLabel,'_Data']).('GradDefLoc_Data').path;
WRTGout.sysgmax = str2double(WRTG.('sysgmax'));
write = WRTG.('WriteGrads');

%---------------------------------------------
% Test
%---------------------------------------------
if strcmp(write,'No')
    err.flag = 4;
    err.msg = 'No Writing Selected';
    return
end

%---------------------------------------------
% Get Local Variables
%---------------------------------------------
G = WRTG.G;
rdur = WRTG.rdur;

%---------------------------------------------
% Test
%---------------------------------------------
if length(G) > 60000
    err.flag = 1;
    err.msg = 'Gradient File Too Long';
end

%-------------------------------------------------
% Select Output Directory
%-------------------------------------------------
[GradLoc] = uigetdir(WRTGout.GradDefLoc,'Select Directory to Write Gradients');
if GradLoc == 0
    err.flag = 4;
    err.msg = 'User Aborted';
    return
end
if exist([GradLoc,'\Gx1.GRD'],'file');
    err.flag = 1;
    err.msg = 'Gradient Files Already Exist in this Path';
    return
end
WRTGout.GradLoc = GradLoc;

%-------------------------------------------------
% Write Label
%-------------------------------------------------
label = GradLoc;
loc = label;
if length(label) > 62
    ind = strfind(loc,filesep);
    n = 1;
    while true
        label = ['...',loc(ind(n)+1:length(loc))];
        if length(label) < 62
            break
        end
        n = n+1;
    end
end
WRTGout.label = label;

%-------------------------------------------------
% Calculate Varian Gradient Value
%-------------------------------------------------
rel = (1/WRTGout.sysgmax) * 32767; 
G = round(rel*G);

%-------------------------------------------------
% Write Gradients to File
%-------------------------------------------------
L = length(G(:,1));

GxV = zeros(L,2);
GyV = zeros(L,2);
GzV = zeros(L,2);

GxV(:,1) = G(:,1);
GyV(:,1) = G(:,2);    
GzV(:,1) = G(:,3);
GxV(:,2) = rdur;
GyV(:,2) = rdur;    
GzV(:,2) = rdur;   
      
loc = [GradLoc,'\Gx1.GRD'];
dlmwrite(loc,GxV,'delimiter','\t','newline','unix','-append');
loc = [GradLoc,'\Gy1.GRD'];
dlmwrite(loc,GyV,'delimiter','\t','newline','unix','-append');
loc = [GradLoc,'\Gz1.GRD'];
dlmwrite(loc,GzV,'delimiter','\t','newline','unix','-append');


