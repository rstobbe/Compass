%====================================================
%  
%====================================================

function [IC,err] = ImCon2DEPIwGrappa_v1a_Func(IC,INPUT)

Status2('busy','Create 2D EPI Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
par = FID.ExpPars;
k = FID.FIDmat;
opt = FID.opt;
clear INPUT;
clear FID;

%---------------------------------------------
% Perform operations specific to parallel imaging
%---------------------------------------------
if par.parallel == 1
    % NB: I've attempted to change my code to be able to specify the
    % parallel imaging acceleration, however, all work so far has been
    % PIrate of 2, and other values have not been tried/tested.
    par.PIrate = 2;
    
    % (par.repeatall > 1) && (opt.repeattype == 3) requires finding weights
    % to be skipped, because they're calculated above
    if ~((par.repeatall > 1) && (opt.repeattype == 3))
        if opt.verbose > 0
            disp('Reconstructing GRAPPA reference scans and calculating GRAPPA weights...') 
        end
        % Separate GRAPPA reference scans from image scans, if applicable
        [par_ref, k_ref, opt_ref, par, k, opt] = EPIgrappa_prepare(par,k,opt);

        % Perform Nyquist ghost correction on GRAPPA reference scans
        k_ref = EPIphasecorrect(k_ref,par_ref,opt_ref);

        % Remove leftover reference scan from phase correction
        % TODO: make sure this works for interleaved reference scan
        [par_ref,k_ref] = remove_ad(par_ref,k_ref,...
            find(or(or(par_ref.nt2a == 1,par_ref.nt2a == 3),par_ref.nt2a == 4)),3);

        % Gridding
        [k_ref par_ref] = EPIgrid(k_ref,par_ref,opt_ref,0);

%         % Perform image shifts
%         k_ref = EPIshiftIm(k_ref,par_ref);

        % Apply 2D iterative phase correction if applicable
        if (opt.phciter2D == 1) && (opt.PItype ~= 3)
            if opt.PItype == 2
                [par_tmp,k_tmp] = remove_ad(par_ref,k_ref,par_ref.nt2a~=2,4);
                k_tmp = EPI2Dphc_iter([],[],k_tmp,par_tmp,opt_ref);
                k_ref(:,:,:,par_ref.nt2a==2,:) = k_tmp;
                clear k_tmp par_tmp
            else
                [k_ref, par.avals_2Diter_PIref] = EPI2Dphc_iter([],[],k_ref,par_ref,opt_ref);
            end
        end 

        % Calculate GRAPPA weights
        if ~isfield(opt,'w')
            opt.w = EPIgrappa_findw(k_ref,opt);
        end

        % For readout segmented reference scan, combine the blinds (for
        % later 2D iterative ghost correction).
        if par_ref.PItype == 2
            k_ref = rspi_combblnd(k_ref,par_ref);
        end
    end
else
    k_ref = [];
    par_ref = [];
end

%---------------------------------------------
% Perform Nyquist ghost correction on undersampled data
%---------------------------------------------
if opt.verbose > 0
    disp('Nyquist ghost correction...')
end
k = EPIphasecorrect(k,par,opt);

%---------------------------------------------
% Remove leftover reference scan from phase correction
%---------------------------------------------
[par,k] = remove_ad(par,k,...
    find(or(or(par.nt2a == 1,par.nt2a == 3),par.nt2a == 4)),3);

%---------------------------------------------
% Gridding
%---------------------------------------------
if opt.verbose > 0
    disp('Gridding...')
end
[k par] = EPIgrid(k,par,opt,0);

% % Image shifts
% k = EPIshiftIm(k,par);

%---------------------------------------------
% Get k-space from parallel imaging reference size to be the same as the
% actual image data after recon.
%---------------------------------------------
if par.parallel == 1
    k_ref = EPImatchsize(k_ref,par_ref,par,size(k));
end

%---------------------------------------------
% 2D nyquist ghost correction (mitigate's the "worm" artefact in DTI)
%---------------------------------------------
if opt.phciter2D == 1
    if opt.verbose > 0
        disp('Iterative 2D Nyquist ghost correction...')
    end
    if (par.repeatall > 1) && (opt.repeattype == 3)
        opt2 = opt;
        opt2.w = opt.w{1,2};
        [k, par.avals_2Diter] = EPI2Dphc_iter(k_ref,par_ref,k,par,opt2);
    else
        [k, par.avals_2Diter] = EPI2Dphc_iter(k_ref,par_ref,k,par,opt);
    end
end 

%---------------------------------------------
% Fill in missing k-space lines for GRAPPA
%---------------------------------------------
if par.parallel == 1
    if (par.repeatall > 1) && (opt.repeattype == 3)
        [k,par] = EPIrepeated_fill(k,par,opt);
    else
        if opt.verbose > 0
            disp('Filling in missing lines with GRAPPA ...')
        end
        img_ref = findsignal(abs(fft2_m(k_ref)),50);
        k = permute(k,[1 2 5 3 4]);
        k = EPIgrappa_fill(k,opt,img_ref);
        k = permute(k, [1 2 4 5 3]);
    end

    % Update parameters from GRAPPA reconstruction
    par.nv_a = par.nv_a*2;
    par.nv_c = par.nv_c*2;
    par.lpe = par.lpe*2;
    clear img_ref k_ref par_ref
end

%---------------------------------------------
% Image shifts
k = EPIshiftIm(k,par);
%---------------------------------------------

%---------------------------------------------
% Zero-fill
%---------------------------------------------
k = EPIzerofill(par,k);

%---------------------------------------------
% Do POCS partial fourier recon
%---------------------------------------------
if (opt.POCSiter > 0) && (abs(par.nv_c) ~= par.nv_a)
    if opt.verbose > 0
        disp('Filling partial Fourier...')
    end
    sz_in = size(k);
    centreLine = [];
    idxSym = [];
    for n = 1:prod(sz_in(4:end))
        k_tmp = permute(k(:,:,:,n),[3 1 2]);
        [~, k_tmp, centreLine, idxSym] = EPIpocs(k_tmp, opt.POCSiter, [], [],centreLine, idxSym);
        k(:,:,:,n) = permute(k_tmp,[2 3 1]);
    end
    clear sz_in k_tmp
end

%---------------------------------------------
% Convert to image space and combine receivers
%---------------------------------------------
if opt.verbose > 0
    disp('Combining receivers...')
end
img = EPIrcvrcomb(k,par,opt);


%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
IC.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
IC.Im = img;
IC.ImSz_X = 1;
IC.ImSz_Y = 1;
IC.ImSz_Z = 1;
IC.maxval = 1;
IC.ExpPars = par;
IC.ReconPars = par;

Status2('done','',2);
Status2('done','',3);

