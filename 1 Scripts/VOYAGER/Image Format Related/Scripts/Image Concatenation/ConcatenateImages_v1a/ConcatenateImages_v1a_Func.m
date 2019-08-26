%===========================================
% 
%===========================================

function [CONCAT,err] = ConcatenateImages_v1a_Func(CONCAT,INPUT)

Status('busy','Concatenate Images');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
sz0 = size(IMG{1}.Im);
imdim0 = length(sz0);
for n = 1:length(IMG)
    sz = size(IMG{n}.Im);
    imdim = length(sz);
    if imdim0 ~= imdim
        err.flag = 1;
        err.msg = 'Images Different Sizes';
        return
    end
    for m = 1:length(imdim)
        if sz(m) ~= sz0(m)
	        err.flag = 1;
            err.msg = 'Images Different Sizes';
            return 
        end
    end
    if length(imdim) > 3
        if sz(4) > 1
	        err.flag = 1;
            err.msg = 'Non-Arrayed Images Only';
            return 
        end
    end
end

%---------------------------------------------
% Concatenate
%---------------------------------------------
szC = sz0;
szC(4) = length(IMG);
ImConcat = zeros(szC);
for n = 1:length(IMG)
    ImConcat(:,:,:,n,:,:) = IMG{n}.Im;
end

%---------------------------------------------
% Return (use IMG{1})
%---------------------------------------------
CONCAT.Im = ImConcat;
CONCAT.ReconPars = IMG{1}.ReconPars;
CONCAT.PanelOutput = IMG{1}.PanelOutput;
CONCAT.ImageType = 'Image';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

