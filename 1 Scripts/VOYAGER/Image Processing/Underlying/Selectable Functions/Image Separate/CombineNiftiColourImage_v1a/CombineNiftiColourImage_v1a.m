%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,MASKTOP,err] = CombineNiftiColourImage_v1a(SCRPTipt,MASKTOPipt)

Status2('busy','Combine Nifti Colour Image',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MASKTOP.method = MASKTOPipt.Func;

%------------------------------------------
% Return
%------------------------------------------
Status2('done','',2);
Status2('done','',3);







