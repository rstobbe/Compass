%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_mpflash3d_v2b_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DCCOR = FID.DCCOR;
clear INPUT;

%-------------------------------------------
% Read in parameters (Robarts)
%-------------------------------------------
ExpPars = readprocpar(FID.path);
ExpPars.rosamp = 1;

%-------------------------------------------
% Read additional params
%-------------------------------------------
%namesExpPars1 = fieldnames(ExpPars);
%cellExpPars1 = struct2cell(ExpPars);
%[Text,err] = Load_ProcparV_v1a([FID.path,'procpar']);
%if err.flag 
%    return
%end
%params = {''};
%out = Parse_ProcparV_v1a(Text,params);
%ExpPars2 = cell2struct([cellExpPars1;out.'],[namesExpPars1;params.'],1);

%-------------------------------------------
% Get relevant variables
%-------------------------------------------
np = ExpPars.np/2;
nv = ExpPars.nv;
nv2 = ExpPars.nv2;
ppe = ExpPars.ppe;
ppe2 = ExpPars.ppe2;
lpe = ExpPars.lpe;
lpe2 = ExpPars.lpe2;
nseg = ExpPars.nseg;
nrcvrs = ExpPars.nrcvrs;

%-------------------------------------------
% Read in data
%-------------------------------------------
%FIDmat = readfid(FID.path,ExpPars,true,false,true);
FIDmat = ImportFIDgenV_v1a([FID.path,'\fid'],nrcvrs);

%-------------------------------------------
% Test
%-------------------------------------------
sz = size(FIDmat);
if sz(1)~= np || sz(2)~= nv || sz(3)~= nv2 || sz(4)~= nrcvrs
    err.flag = 1;
    err.msg = 'FID file err. Probably Using Pre-Processed File.';
    return
end

%-------------------------------------------
% Sort Segmentation (coded on nv dimension)
%-------------------------------------------
steps = [(1:nseg:nv) (2:nseg:nv)];
[~,inds] = sort(steps);
FIDmat = FIDmat(:,inds,:,:);

%-------------------------------------------
% Apply ppe shift (phase encode position)
%-------------------------------------------
if ppe ~= 0
    pix = -0.5*ppe./(lpe./nv);
    ph_ramp = exp(1i*2*pi*pix*(-1:2/nv:1-1/nv));
    FIDmat = FIDmat .* repmat(ph_ramp,[np 1 nv2 nrcvrs]);
end

%-------------------------------------------
% Apply ppe2 shift (phase encode2 position)
%-------------------------------------------
if ppe2 ~= 0
    pix = 0.5*ppe2./(lpe2./nv2);
    ph_ramp0 = exp(1i*2*pi*pix*(-1:2/nv2:1-1/nv2));
    ph_ramp1 = repmat(ph_ramp0,[nv 1 nrcvrs np]);
    ph_ramp = permute(ph_ramp1,[4 1 2 3]);
    FIDmat = FIDmat .* ph_ramp;
end

%--------------------------------------------
% Max Value Test
%--------------------------------------------
for n = 1:nrcvrs
    k1 = FIDmat(:,:,:,n);
    maxvals(n) = max(k1(:));
end
rcvrmaxval = abs(maxvals);
DataInfo.maxvals = abs(maxvals);
DataInfo.maxchanvals = max(abs([real(maxvals) imag(maxvals)]));

%--------------------------------------------
% Test
%--------------------------------------------
if DataInfo.maxchanvals < 3000
    button = questdlg('Gain is <10dB of what it should be','Gain Error','continue','abort','continue');
    if strcmp(button,'abort')
        err.flag = 1;
        err.msg = 'Gain error';
        return
    end
end
for n = 1:nrcvrs
    if DataInfo.maxvals(n) < 0.5*median(DataInfo.maxvals)
        pctlow = DataInfo.maxvals(n)/median(DataInfo.maxvals);
        button = questdlg(['Gain on rcvr',num2str(n),' is ',num2str(pctlow),' of median'],'Receive Gain Error','continue','abort','continue');
        if strcmp(button,'abort')
            err.flag = 1;
            err.msg = 'Receiver Gain error';
            return
        end
    elseif DataInfo.maxvals(n) > 2*median(DataInfo.maxvals)
        button = questdlg(['Gain on rcvr',num2str(n),' is potentially high'],'Receive Gain Error','continue','abort','continue');
        if strcmp(button,'abort')
            err.flag = 1;
            err.msg = 'Receiver Gain error';
            return
        end
    end    
end

%--------------------------------------------
% Expand to 5 dims
%--------------------------------------------
nexp = 1;
[x,y,z,nrcvrs] = size(FIDmat);
FIDmat = reshape(FIDmat,[x,y,z,nexp,nrcvrs]);

%--------------------------------------------
% DC correction
%--------------------------------------------
func = str2func([FID.dccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = nrcvrs;
INPUT.imtype = '3D';
INPUT.meth3D = 'perline';
[DCCOR,err] = func(DCCOR,INPUT);
if err.flag
    return
end
clear INPUT;
FIDmat = DCCOR.FIDmat;

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.Imfovro = 10*ExpPars.lro;
ReconPars.Imfovpe1 = 10*ExpPars.lpe;
ReconPars.Imfovpe2 = 10*ExpPars.lpe2;
ReconPars.Imvoxro = 10*ExpPars.lro/(ExpPars.np/2);
ReconPars.Imvoxpe1 = 10*ExpPars.lpe/ExpPars.nv;
ReconPars.Imvoxpe2 = 10*ExpPars.lpe2/ExpPars.nv2;
ReconPars.orient = ExpPars.orient;

%--------------------------------------------
% Panel
%--------------------------------------------
n = 1;
Panel(n,:) = {'FID',FID.DatName,'Output'};
n = n+1;
Panel(n,:) = {'Date',ExpPars.date,'Output'};
n = n+1;
Panel(n,:) = {'','','Output'};
n = n+1;
Panel(n,:) = {'TR',ExpPars.tr,'Output'};
n = n+1;
Panel(n,:) = {'TE',ExpPars.te,'Output'};
if strcmp(ExpPars.ir,'y')
    n = n+1;
    Panel(n,:) = {'TI',ExpPars.ti,'Output'};
end
n = n+1;
Panel(n,:) = {'','','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FID.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
FID.FIDmat = FIDmat;
FID.ExpPars = ExpPars;
FID.ReconPars = ReconPars;
Status2('done','',2);
Status2('done','',3);


