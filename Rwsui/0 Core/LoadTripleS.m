%====================================================
%
%====================================================

function LoadTripleS(SavedModelTripleS,SavedSeqTripleS)

Status2('busy','Load TripleS',1);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% TripleS GblAPP
%---------------------------------------------
global GblAPP
if not(isvalid(GblAPP))
    GblAPP = TripleS_2018_App;
end

LoadFromCompass(GblAPP,SavedModelTripleS,SavedSeqTripleS);
    
Status2('done','',1);


