%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,MASKTOP,err] = SeparateNiftiColourImage_v1a(SCRPTipt,MASKTOPipt)

Status2('busy','Separate Nifti Colour Image',2);
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







