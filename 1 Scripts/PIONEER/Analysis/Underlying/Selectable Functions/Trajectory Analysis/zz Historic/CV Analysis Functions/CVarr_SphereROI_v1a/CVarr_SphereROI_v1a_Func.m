%==============================================
% 
%==============================================

function [CVARR,err] = CVarr_SphereROI_v1a_Func(CVARR,INPUT)

Status2('busy','Arrayed Spherical ROIs',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CVCALC = CVARR.CVCALC;
PSD = INPUT.PSD;
zf = CVARR.zerofill;
PROJdgn = PSD.PROJdgn;
clear INPUT

%---------------------------------------------
% Diameter Array
%---------------------------------------------
ind = strfind(CVARR.diam,':');
start = str2double(CVARR.diam(1:ind(1)-1));
step = str2double(CVARR.diam(ind(1)+1:ind(2)-1));
stop = str2double(CVARR.diam(ind(2)+1:end));
DiamArr = (start:step:stop);

%---------------------------------------------
% ZeroFill PSD
%---------------------------------------------
psdmatwid = length(PSD.psd);
psdzf = zeros(zf,zf,zf);
b = (zf/2)+1-(psdmatwid-1)/2;
t = (zf/2)+1+(psdmatwid-1)/2;
psdzf(b:t,b:t,b:t) = PSD.psd;

%---------------------------------------------
% CV Calculation Setup
%---------------------------------------------   
func = str2func([CVARR.cvcalcfunc,'_Func']);
INPUT.psd = psdzf;
INPUT.kmatvol = PSD.kmatvol;      

for n = 1:length(DiamArr)
    ROI.zerofill = zf;
    ROI.fov = PROJdgn.fov;  
    ROI.diam = DiamArr(n);
    [ROI,err] = SphereROI_ParForBuild_v1a(ROI);
    roi = ROI.roi;
    volarr(n) = ROI.volume;
    mroi(n) = ROI.tot;
    
    INPUT.roi = roi;
    [CVCALC,err] = func(CVCALC,INPUT);
    if err.flag
        return
    end
    cv(n) = CVCALC.cv;
end

%---------------------------------------------
% Save
%---------------------------------------------
CVARR.cv = cv;
CVARR.vinvox = zf^3/PSD.kmatvol;
CVARR.mroi = mroi;
CVARR.nroi = CVARR.mroi/CVARR.vinvox;
CVARR.volarr = CVARR.nroi*(PROJdgn.vox/10)^3/PROJdgn.elip;          % in cm^3
CVARR.siv = CVARR.nroi./CVARR.cv; 

%---------------------------------------------
% Plot
%---------------------------------------------  
figure(100); hold on;
plot(CVARR.nroi,CVARR.cv);
h = gca;
h.XScale = 'log';
h.YScale = 'log';
h.XTick = [1 4 16 64 256];
h.YTick = [0.7 1 1.4 2 2.8 4 5.7 8 11.3 16];
h.XLabel.String = 'Voxels'; h.YLabel.String = 'Voxels'; 
h.Title.String = 'CV(Voxels)';
h.YLim = [0.7 max(CVARR.cv)*1.05]; 
h.XLim = [1 max(CVARR.nroi)];

%---------------------------------------------
% Return
%---------------------------------------------  
CVARR.ExpDisp = '';

Status2('done','',2);
Status2('done','',3);
