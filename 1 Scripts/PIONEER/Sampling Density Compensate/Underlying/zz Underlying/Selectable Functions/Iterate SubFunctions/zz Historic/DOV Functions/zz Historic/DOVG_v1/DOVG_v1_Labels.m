%=========================================================
% 
%=========================================================

function  [FUNClabs,error,errorflag] = Labels(method,func,SDCipt,defaults,N)

error = '';
errorflag = 0;
FUNClabs = '';

%--------------------------------
% Tests
%--------------------------------
validfor = {'mG02a_v1'};

good = 0;
for n = 1:length(validfor)
    if (strcmp(method,validfor{n}))
        good = 1;
        break
    end
end
if good == 0
    errorflag = 1;
    error = [func,' Function Not Appropriate for ',method];
    Status('error',error);
    return
end

%--------------------------------
% Defaults
%--------------------------------
if not(isempty(SDCipt)) 
    RadSclFunc = SDCipt(strcmp('ItNum',{SDCipt.labelstr})).entrystr;
elseif not(isempty(defaults))
    RadSclFunc = defaults.RadSclFunc;
else
    RadSclFunc = 'KmaxDesign';
end

%--------------------------------
% Labels
%--------------------------------
n = 1;
FUNClabs(n).number = N;
FUNClabs(n).labelstyle = '0label'; 
FUNClabs(n).labelstr = 'RadSclFunc';
FUNClabs(n).entrystyle = '0text';
FUNClabs(n).entrystr = RadSclFunc;
FUNClabs(n).entryvalue = 0;
FUNClabs(n).unitstyle = '0pushbutton';
FUNClabs(n).unitfunction = ['SelectRadSclFunc(',num2str(N),')'];
FUNClabs(n).unitstr = 'Select';

