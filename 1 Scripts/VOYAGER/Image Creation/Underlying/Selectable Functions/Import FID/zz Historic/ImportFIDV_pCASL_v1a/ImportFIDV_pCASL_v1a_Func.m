%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_pCASL_v1a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%----------------------------------------------
% Read Options
%----------------------------------------------
inds = strfind(FID.opt,'\');
path = FID.opt(1:inds(end));
addpath(genpath(path));
file = FID.opt(inds(end)+1:length(FID.opt)-2);
func = str2func(file);  
opt = func();

%-------------------------------------------
% Read Parameters
%-------------------------------------------
par = readprocpar_CB(FID.path);

%-------------------------------------------
% Check option compatibility, etc...
%-------------------------------------------
[par,opt] = EPIcheckpar_ASL_v1a(par,opt);

%-------------------------------------------
% Read Extra Parameters
%-------------------------------------------
[Text,err] = Load_ProcparV_v1a([FID.path,'procpar']);
if err.flag 
    return
end
params = {'pCASLwidth'};            % add rest...
out = Parse_ProcparV_v1a(Text,params);
par = cell2struct([struct2cell(par);out],[fieldnames(par);params]);

%-------------------------------------------
% Read Shim Values
%-------------------------------------------
params = {'z1c','z2c','z3c','z4c','x1','y1',...
          'xz','yz','xy','x2y2','x3','y3','xz2','yz2','zxy','zx2y2',...
          'tof'};
out = Parse_ProcparV_v1a(Text,params);
Shim = cell2struct(out.',params.',1);

%-------------------------------------------
% Read data and DC correct
%-------------------------------------------
if opt.verbose > 0
    disp('Reading Data...');
end
[k,par.hdr,par.blchdr] = readfid_CB(FID.path,par,0,0,1);
for i = 1:size(k,2)
    k(:,i) = k(:,i) - complex(median(real(k(:,i))),median(imag(k(:,i))));
end
clear i

%-------------------------------------------
% Reshape and permute k
%-------------------------------------------
rvec = [par.np/2 par.ns par.nrcvrs par.ad];
pvec = [1 2 4 3];
k = permute(reshape(k,rvec),pvec);
clear rvec pvec

%-------------------------------------------
% Correct for b0 eddy currents.
%-------------------------------------------
if isfield(opt,'eddy_file') && ~isempty(opt.eddy_file)
    k = EPI_B0eddy(k,par,opt);
end

%-------------------------------------------
% Permute slabs together properly if slabs acquired
%-------------------------------------------
[k,par] = EPIslabpermute(k,par);

%-------------------------------------------
% Remove dummy scan used to reach steady state
%-------------------------------------------
[par,k] = remove_ad(par,k,1,3);                     % the first scan in the array is a dummy...

%-------------------------------------------
% If only first volume is to be reconned, get rid of all the extra volumes
%-------------------------------------------
if opt.only_first
    [par,k] = remove_ad(par,k,(find(par.nt2a == 2,1,'first')+1):size(k,3),3);
end

%-------------------------------------------
% Handle repeated reference scans and images (will not be encountered in
% typical use of the pulse sequence)
%-------------------------------------------
k_ref = [];
par_ref = [];
if par.repeatall > 1  
    [k,par,opt,k_ref,par_ref] = EPIrepeated(k,par,opt);
end

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.fovx = 1;
ReconPars.fovy = 1;
ReconPars.fovz = 1;
ReconPars.voxx = 1;
ReconPars.voxy = 1;
ReconPars.voxz = 1;

%--------------------------------------------
% Panel
%--------------------------------------------
n = 1;
Panel(n,:) = {'FID',FID.DatName,'Output'};
n = n+1;
Panel(n,:) = {'Date',par.date,'Output'};
n = n+1;
Panel(n,:) = {'','','Output'};

PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FID.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
FID.FIDmat = k;
FID.ExpPars = par;
FID.opt = opt;
FID.k_ref = k_ref;
FID.par_ref = par_ref;
FID.Shim = Shim;
FID.ReconPars = ReconPars;

Status2('done','',2);
Status2('done','',3);


