%=========================================================
% 
%=========================================================

function [GRD,err] = Grid_SDC_v1c_Func(INPUT,GRD)

Status('busy','Grid Data with SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
TORD = IMP.TORD;
GRDU0 = INPUT.GRDU;
clear INPUT;

%---------------------------------------------
% Check for Array
%---------------------------------------------
sz = size(IMP.Kmat);
if length(sz) == 3
    ArrayNum = 1;
else
    ArrayNum = 2;                   % code in a selector here...
end

for n = 1:ArrayNum
    
    %---------------------------------------------
    % Grid
    %---------------------------------------------
    GRDU = GRDU0;
    func = str2func([GRD.gridfunc,'_Func']);  
    INPUT.IMP = IMP;
    INPUT.IMP.Kmat = IMP.Kmat(:,:,:,ArrayNum); 
    sz = size(IMP.Kmat);
    INPUT.DAT = zeros(sz(1),sz(2));
    INPUT.DAT(TORD.projsampscnr,:) = IMP.SDC(TORD.projsampscnr,:,ArrayNum);  
    GRDU.type = 'real';
    [GRDU,err] = func(GRDU,INPUT);
    if err.flag
        return
    end
    clear INPUT;

    %---------------------------------------------
    % Save
    %---------------------------------------------
    if n == 1
        sz = size(GRDU.GrdDat);
        GrdDat = zeros([sz ArrayNum]);
    end
    GrdDat(:,:,:,n) = GRDU.GrdDat;
    
end

%--------------------------------------------
% Return
%--------------------------------------------
GRD.GrdDat = GrdDat;
GRD.Ksz = GRDU.Ksz;


