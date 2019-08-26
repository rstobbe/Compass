%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,KSEL,err] = KernSlct_SS1p28W5_v1a(SCRPTipt,KSELipt)

Status2('busy','Get Scale Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSEL.method = KSELipt.Func;

%-------------------------------------------------------------------------------------
% Gridding with 'Singles' relults in error that are amplified in the
% corners of the image.  
% - a larger Beta value will reduce this error at the expense of increased error
%     at the edges of the 'stretched' FoV dimesions (for the head - the nose area)
% - higher kernel resolution more accurate image, but (gridding) time and memory cost
% - note: there is randomness in this error process.
%-------------------------------------------------------------------------------------

%KSEL.kern = 'KBCw5b11p5ss1p28';   
KSEL.kern = 'KBCw5b12ss1p28';               % create new function with selector is change needed
%KSEL.kern = 'KBCw5b12ss1p28H';   
%KSEL.kern = 'KBCw5b12p5ss1p28';   

Status2('done','',2);
Status2('done','',3);









