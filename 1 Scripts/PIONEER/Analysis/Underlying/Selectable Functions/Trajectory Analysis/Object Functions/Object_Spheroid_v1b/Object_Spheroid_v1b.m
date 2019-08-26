%===========================================
% (v1b)
%    - follow 'UserOb_Sphere_v1b'
%===========================================

function [SCRPTipt,OB,err] = Object_Spheroid_v1b(SCRPTipt,OBipt)

Status2('done','Object Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
OB.method = OBipt.Func;
diam = OBipt.('Diam');
OB.elip = str2double(OBipt.('Elip'));

%---------------------------------------------
% Diameter Array
%---------------------------------------------
ind = strfind(diam,':');
if isempty(ind)
    OB.arr = str2double(diam);
else
    start = str2double(diam(1:ind(1)-1));
    step = str2double(diam(ind(1)+1:ind(2)-1));
    stop = str2double(diam(ind(2)+1:end));
    OB.arr = (start:step:stop);
end

Status2('done','',2);
Status2('done','',3);

