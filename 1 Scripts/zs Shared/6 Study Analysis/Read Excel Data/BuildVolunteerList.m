%=============================================================
%    
%=============================================================

function [STUDY,err] = BuildVolunteerList(file,STUDY)

err.flag = 0;
err.msg = '';

tabledata = readtable(file);
DataTypes = tabledata.Properties.VariableNames;
celldata = table2cell(tabledata);

%-------------------------------------------------        
% Test 
%-------------------------------------------------  
test = strfind(DataTypes,'Volunteers');
VolunteerColumn = 0;
for n = 1:length(DataTypes)
    if not(isempty(test{n}))
        VolunteerColumn = n;
        break
    end
end
if VolunteerColumn == 0
    err.flag = 1;
    err.msg = 'Excel file must have ''Volunteers'' Column';
    return
end

%-------------------------------------------------        
% Add Volunteers
%-------------------------------------------------  
n = 1;
while true
    if not(isempty(celldata{n,VolunteerColumn}))
        name = celldata{n,VolunteerColumn};
        [~,err] = STUDY.AddVolunteer(name);
        if err.flag
            return
        end
    end
    n = n+1;
    if n > length(celldata)
        break
    end
end

