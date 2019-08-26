%======================================================
% 
%======================================================

function [ANLZ,err] = OB_NEI_instepVOI_relationship_v1b_Func(ANLZ,INPUT)

Status('busy','NEI - VOI relationship');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSD = INPUT.PSD;
OB = INPUT.OB;
ROI = OB;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
zf = ANLZ.zf;
fov = PSD.PROJdgn.fov;
vox = PSD.PROJdgn.vox;
elip = PSD.PROJdgn.elip;
vinvox = ((vox/(fov/zf))^3)/elip;

%---------------------------------------------
% ZeroFill PSD
%---------------------------------------------
psdmatwid = length(PSD.psd);
psdzf = zeros(ANLZ.zf,ANLZ.zf,ANLZ.zf);
b = (ANLZ.zf/2)+1-(psdmatwid-1)/2;
t = (ANLZ.zf/2)+1+(psdmatwid-1)/2;
psdzf(b:t,b:t,b:t) = PSD.psd;
vox = PSD.PROJdgn.vox;

for n = 1:length(OB.arr);

    %---------------------------------------------
    % Build Object
    %---------------------------------------------  
    Status2('busy','Build Object',2);
    obfunc = str2func([ANLZ.objectfunc,'_Func']);
    INPUT.zf = ANLZ.zf;
    INPUT.fov = PSD.PROJdgn.fov;
    INPUT.arrval = OB.arr(n);
    INPUT.pcntmaxerr = 5;
    [OB,err] = obfunc(OB,INPUT);
    if err.flag
        return
    end
    vinob = sum(OB.Ob(:));
    nob(n) = vinob/vinvox;
    OBprof = squeeze(OB.Ob(:,zf/2+1,zf/2+1));
    OBprof2 = squeeze(OB.Ob(zf/2+1,zf/2+1,:));
    figure(10); hold on; 
    plot((OB.voxdim:OB.voxdim:fov),OBprof,'k'); 
    plot((OB.voxdim:OB.voxdim:fov),OBprof2,'k:'); 
    
    for m = 1:length(ANLZ.instep)
    
        %---------------------------------------------
        % Build Object
        %---------------------------------------------  
        Status2('busy','Build Object',2);
        obfunc = str2func([ANLZ.objectfunc,'_Func']);
        INPUT.zf = ANLZ.zf;
        INPUT.fov = PSD.PROJdgn.fov;
        INPUT.arrval = OB.arr(n) - vox*ANLZ.instep(m);
        if INPUT.arrval < 1
            mroi(n,m) = NaN;
            cv(n,m) = NaN;
            continue
        end
        INPUT.pcntmaxerr = 40;
        [ROI,err] = obfunc(ROI,INPUT);
        if err.flag
            return
        end
        mroi(n,m) = sum(ROI.Ob(:));
        %ROIprof = squeeze(ROI.Ob(ANLZ.zf/2+1,ANLZ.zf/2+1,:));
        %figure(10); hold on; 
        %plot((ROI.voxdim:ROI.voxdim:PSD.PROJdgn.fov),ROIprof,'b'); 
        %title('Object Profile');
        %xlabel('Dimensions');
        %xlim([0 PSD.PROJdgn.fov]);

        %---------------------------------------------
        % Calculate CV
        %---------------------------------------------    
        Status2('busy','Noise Analysis',2);
        INPUT.roi = ROI.Ob;
        INPUT.psd = psdzf;
        INPUT.kmatvol = PSD.kmatvol;
        CV = [];
        [CV,err] = CorVolCalc_v1a(CV,INPUT);
        if err.flag
            return
        end
        cv(n,m) = CV.cv;
    end
end

%---------------------------------------------
% Save
%---------------------------------------------
ANLZ.cv = cv;
ANLZ.vinvox = ANLZ.zf^3/PSD.kmatvol;
ANLZ.mroi = mroi;
ANLZ.nroi = ANLZ.mroi/ANLZ.vinvox;
ANLZ.volarr = ANLZ.nroi*(PSD.PROJdgn.vox/10)^3/PSD.PROJdgn.elip;          % in cm^3
ANLZ.siv = ANLZ.nroi./ANLZ.cv; 
ANLZ.rnei = 1.96*sqrt(1./ANLZ.siv)./ANLZ.snr;
ANLZ.PROJdgn = PSD.PROJdgn;
ANLZ.nob = nob;

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1000); hold on;
plot(ANLZ.nob,ANLZ.rnei);
%box on;
ylim([0 0.11]); 
%xlim([0 25]); 
%set(gca,'XScale','log'); set(gca,'YScale','log');

%---------------------------------------------
% Return
%---------------------------------------------  
ANLZ.ExpDisp = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);