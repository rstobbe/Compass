%=========================================================
% 
%=========================================================

function  [FUNClabs,error,errorflag] = Labels(method,func,SDCipt,defaults,N)

error = '';
errorflag = 0;
FUNClabs = '';

funcpurp = 'show error';

%--------------------------------
% Tests
%--------------------------------
validfor = {'mN04a_v1','mN05a_v1','mN06a_v1'};

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
    Status2('error',error,1);
    Status2('busy',funcpurp,2);
    return
end

%--------------------------------
% Defaults
%--------------------------------

%--------------------------------
% Labels
%--------------------------------

