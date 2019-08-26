%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_fsemsuf_v2d_Func(FID,INPUT)

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
namesExpPars1 = fieldnames(ExpPars);
cellExpPars1 = struct2cell(ExpPars);
[Text,err] = Load_ProcparV_v1a([FID.path,'procpar']);
if err.flag 
    return
end
params = {'operator_'};
out = Parse_ProcparV_v1a(Text,params);
ExpPars = cell2struct([cellExpPars1;out.'],[namesExpPars1;params.'],1);

%-------------------------------------------
% Get relevant variables
%-------------------------------------------
eff_echo = ExpPars.eff_echo;
np = ExpPars.np/2;
nv = ExpPars.nv;
ns = ExpPars.ns;
etl = ExpPars.etl;
nrcvrs = ExpPars.nrcvrs;
arraydim = ExpPars.arraydim;
sloop = ExpPars.sloop;
if strcmp(ExpPars.sloop,'s')
    error();        
else
    nvol = arraydim/nrcvrs;
end
haste = ExpPars.haste;
R = ExpPars.senseR;
pks = ExpPars.pks;
t2map = ExpPars.t2map;
fcorr = ExpPars.fcorr;
ssc = ExpPars.ssc;
pss = ExpPars.pss;

%-------------------------------------------
% Tests (marc's...)
%-------------------------------------------
if strcmp(fcorr,'y')
    error();            % (flip angle correction - don't use)  look at Marc's fse2fid2E function to add 
elseif strcmp(pks,'y')
    error();            % look at Marc's fse2fid2E function to add
elseif R ~= 1
    error();            % look at Marc's fse2fid2E function to add
elseif t2map ~= 0
    error();            % look at Marc's fse2fid2E function to add
elseif strcmp(sloop,'s')
    error();            % look at Marc's fse2fid2E function to add
end

%-------------------------------------------
% Read in data
%-------------------------------------------
FIDmat = ImportFIDgenV_v2a([FID.path,'\fid'],nrcvrs).';

%-------------------------------------------
% Data Fix-up (HASTE)
%-------------------------------------------   
if strcmp(haste,'y')
    
    %-------------------------------------------
    % Reorder data
    rvec = [np etl ns nrcvrs nvol];
    pvec = [1 2 3 5 4];
    FIDmat = reshape(FIDmat,rvec);
    FIDmat = permute(FIDmat,pvec);

    %--------------------------------------------
    % DC correction
    func = str2func([FID.dccorfunc,'_Func']);  
    INPUT.FIDmat = FIDmat;
    INPUT.nrcvrs = nrcvrs;
    INPUT.imtype = '2D';
    [DCCOR,err] = func(DCCOR,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    FIDmat = DCCOR.FIDmat;
    if isfield(DCCOR,'dcvals');
        DataInfo.dcvals = DCCOR.dcvals;
        DataInfo.meandcvals = DCCOR.meandcvals;
    end
    
    %--------------------------------------------
    % Fill Partial k-Space
    Status2('busy','Filling Partial k-Space',2);
    if strcmp(ExpPars.pocs,'p')
        FIDmat = pifft2(FIDmat(:,:,:),nv,0,1);            % pocs
    elseif strcmp(ExpPars.pocs,'z')
        FIDmat = pifft2(FIDmat(:,:,:),nv,0,2);            % zerofill
    else
        FIDmat = pifft2(FIDmat(:,:,:),nv,0,0);            % homodyne
    end
    FIDmat = reshape(FIDmat,[np nv ns nvol nrcvrs]);
    FIDmat = flipdim(FIDmat,2);   

    %--------------------------------------------
    % DC correction
    func = str2func([FID.dccorfunc,'_Func']);  
    INPUT.FIDmat = FIDmat;
    INPUT.nrcvrs = nrcvrs;
    INPUT.imtype = '2D';
    [DCCOR,err] = func(DCCOR,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    FIDmat = DCCOR.FIDmat;    

%-------------------------------------------
% Data Fix-up (OTHER)
%-------------------------------------------      
else
    shots= nv/etl;
    if ssc
        shots = shots+1;                            % strip dummy pulse
    end
    rvec = [np etl ns nvol shots nrcvrs];
    pvec = [1 2 5 3 4 6];
    FIDmat = reshape(FIDmat,rvec);
    FIDmat = permute(FIDmat,pvec);    

    if ssc
        FIDmat = FIDmat(:,:,2:shots,:,:,:);
    end    

    rvec = [np nv ns nvol nrcvrs];
    FIDmat = reshape(FIDmat,rvec);    
    
    if etl == 1
        ind = floor(nv/2):-1:-floor(nv/2);
    else
        ind = genpe(nv,etl,eff_echo,0,1,0,t2map);
    end
    [~,ind] = sort(ind);
    FIDmat(:,:,:,:,:) = FIDmat(:,ind,:,:,:);   

    %--------------------------------------------
    % DC correction
    func = str2func([FID.dccorfunc,'_Func']);  
    INPUT.FIDmat = FIDmat;
    INPUT.nrcvrs = nrcvrs;
    INPUT.imtype = '2D';
    [DCCOR,err] = func(DCCOR,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    FIDmat = DCCOR.FIDmat;    
    if isfield(DCCOR,'dcvals');
        DataInfo.dcvals = DCCOR.dcvals;
        DataInfo.meandcvals = DCCOR.meandcvals;
    end
    
end
%test = size(FIDmat)

%-------------------------------------------
% Sort the pss array and reorder slice data for interleaved slices
%------------------------------------------- 
[~,ind] = sort(pss);
FIDmat = FIDmat(:,:,ind,:,:);

%--------------------------------------------
% Data Test
%--------------------------------------------
[DataInfo,err] = DataTestVarian_v1a(DataInfo,FIDmat);
if err.flag == 1
    return
end

%-------------------------------------------
% Get Array Info
%-------------------------------------------
[ProcPar,err] = Load_ProcparV_v1a([FID.path,'procpar']);
if err.flag == 1
    return
end
[ArrayParams,err] = ArrayAssessVarian_v1b(ProcPar);
if not(isempty(ArrayParams))
    if length(ArrayParams) > 2
        err.flag = 1;
        err.msg = 'ImportFIDfunc does not handle multidim arrays';
        return
    end
    if length(ArrayParams)==2
        if strcmp(ArrayParams{1}.ArrayName,'Array')
            if strcmp(ArrayParams{1}.VarNames{1},'grof') && strcmp(ArrayParams{2}.VarNames{1},'tpwr1a')
                ArrayParams{1} = ArrayParams{2};
                ArrayParams{1}.ArrayName = 'B1Map';
                fliplist = ExpPars.fliplist;
                %test2 = ArrayParams{2};
                ArrayParams{1}.('fa') = [fliplist(1) fliplist(1)/2];        % can verify with tpwr
            end
        end
    else
        if strcmp(ArrayParams{1}.ArrayName,'Array')
            if length(ArrayParams{1}.VarNames) == 2
                if strcmp(ArrayParams{1}.VarNames{1},'tpwr1a') && strcmp(ArrayParams{1}.VarNames{2},'tpwrf1a')
                    ArrayParams{1}.ArrayName = 'B1Map';
                    fliplist = ExpPars.fliplist;
                    ArrayParams{1}.('fa') = [fliplist(1) fliplist(2)];
                end
            end
        end
    end
    Array.ArrayParams = ArrayParams{1};
    Array.ArrLen = ArrayParams{1}.ArrayLength;
    Array.ArrayName = ArrayParams{1}.ArrayName;
    ExpPars.Array = Array;
end

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.Imfovro = 10*ExpPars.lro;
ReconPars.Imfovpe1 = 10*ExpPars.lpe;
ReconPars.Imfovslc = ExpPars.ns*(ExpPars.thk+ExpPars.gap);
ReconPars.Imvoxro = 10*ExpPars.lro/(ExpPars.np/2);
ReconPars.Imvoxpe1 = 10*ExpPars.lpe/ExpPars.nv;
ReconPars.Imvoxslc = ExpPars.thk;
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
Panel(n,:) = {'ESP',ExpPars.esp,'Output'};
n = n+1;
Panel(n,:) = {'','','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FID.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
FID.DataInfo = DataInfo;
FID.FIDmat = FIDmat;
FID.ExpPars = ExpPars;
FID.ReconPars = ReconPars;

Status2('done','',2);
Status2('done','',3);


