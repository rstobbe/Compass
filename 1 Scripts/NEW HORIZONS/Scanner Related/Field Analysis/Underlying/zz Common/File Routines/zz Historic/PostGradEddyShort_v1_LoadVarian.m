%=====================================================
% 
%=====================================================

function [Tpars,FID,ParamsDisp,StudyDisp,errorflag,error] = PostGradEddyShort_v1_LoadVarian(path)

[fid] = ImportExpArrayFIDmat([path,filesep,'fid']);

[Text,errorflag,error] = Load_Params([path,filesep,'params']);
if errorflag == 1
    Status('error',error);
    return
end

Tpars.dwell = str2double(Parse_Params(Text,'dwell'));
Tpars.np = str2double(Parse_Params(Text,'npro'));
Tpars.tr = str2double(Parse_Params(Text,'tr'));
Tpars.gval = str2double(Parse_Params(Text,'gval'));
Tpars.falltime = str2double(Parse_Params(Text,'falltime'));

ind = strfind(Text,'initdels:');
Text0 = Text(ind:ind+200);
ind = strfind(Text0,char(10));
Text0 = Text0(1:ind(1));
ind = strfind(Text0,char(32));

for n = 1:length(ind)-1
    initdel(n) = str2double(Text0(ind(n)+1:ind(n+1)-1));
    if initdel(n) == 0
        initdel(n) = 0.0001;
    end
    Tpars.gofftime(n) = initdel(n);
    FID(n,:) = fid(n,:);
end

ind1 = strfind(Text,'DECC File:');
ind2 = strfind(Text,'expdefault:');
ParamsDisp1 = Text(ind1:ind2-2);

ind1 = strfind(Text,'expdefault:');
ind2 = strfind(Text,'pw:');
ParamsDisp2 = Text(ind1:ind2-1);
ParamsDisp = [ParamsDisp1 ParamsDisp2];

ind1 = strfind(Text,'Date:');
ind2 = strfind(Text,'Protocol:');
StudyDisp = Text(ind1:ind2-1);

