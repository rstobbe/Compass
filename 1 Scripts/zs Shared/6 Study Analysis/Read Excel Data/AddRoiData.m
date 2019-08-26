%=============================================================
%    
%=============================================================

function [STUDY,err] = AddRoiData(file,STUDY)

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
test = strfind(DataTypes,'RoiName');
RoiColumn = 0;
for n = 1:length(DataTypes)
    if not(isempty(test{n}))
        RoiColumn = n;
        break
    end
end
if RoiColumn == 0
    err.flag = 1;
    err.msg = 'Excel file must have ''RoiName'' Column';
    return
end

%-------------------------------------------------        
% Add ROIs
%-------------------------------------------------  
n = 1;
while true
    
    %-------------------------------------------------        
    % Find Volunteer
    %------------------------------------------------- 
    if not(isempty(celldata{n,VolunteerColumn}))
        VolunteerName = celldata{n,VolunteerColumn};
        [~,err] = STUDY.FindVolunteer(VolunteerName);
        if err.flag
            return
        end
    end

    %-------------------------------------------------        
    % Add ROIs
    %-------------------------------------------------     
    if not(isempty(celldata{n,RoiColumn}))
        RoiName = celldata{n,RoiColumn};
        [~,err] = STUDY.FindVolunteer(VolunteerName).AddRoi(RoiName);
        if err.flag
            return
        end
        for m = RoiColumn+1:length(DataTypes)
            MeasName = DataTypes{m};
            if strcmp(MeasName,['Var',num2str(m)]) || strcmp(MeasName,'notes')
                continue
            end
            MeasValue = celldata{n,m};
            [~,err] = STUDY.FindVolunteer(VolunteerName).FindRoi(RoiName).AddMeas(MeasName,MeasValue);
            if err.flag
                return
            end
            [test,err] = STUDY.FindVolunteer(VolunteerName).FindRoi(RoiName).FindMeas(MeasName);
            if err.flag
                return
            end
        end
    end
    n = n+1;
    if n > length(celldata)
        break
    end
end


