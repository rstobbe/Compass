%=========================================================
% - Matrix Output:  (x,y,slices,values)
%=========================================================

function [ImAT,err] = LoadASLImNifti_v1a_Func(ImAT,INPUT)

Status2('busy','Load ASL Nifti Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
loc = ImAT.loc;

%---------------------------------------------
% Load Nifti Image
%---------------------------------------------
%out = load_nii(loc);
out = load_untouch_nii(loc);
Im = out.img;

%---------------------------------------------
% Return
%---------------------------------------------
ImAT.Im = Im;

Status2('done','',2);
Status2('done','',3);
