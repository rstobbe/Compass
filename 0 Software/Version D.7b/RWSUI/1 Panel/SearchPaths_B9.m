%=========================================================
% 
%=========================================================

function [CellArray,pathschanged,err] = SearchPaths_B9(CellArray,SCRPTPATHS)

err.flag = 0;
err.msg = '';
pathschanged = 0;

for a = 1:length(CellArray(:,1))        
%-------------------------------------------
% Level 1
%-------------------------------------------
    path0 = CellArray{a,1}.path;
    script = CellArray{a,1}.entrystr;
    [pathschanged,path,err] = TestReplaceRoot(script,path0,SCRPTPATHS);
    if err.flag
        return
    end
    if pathschanged == 1
        CellArray{a,1}.path = path;
        CellArray{a,1}.searchpath = path;
    end
    
%-------------------------------------------
% Level 2
%-------------------------------------------
    for b = 1:length(CellArray{a,2}(:,1))
        if isempty(CellArray{a,2}{b,1})
            break
        end
        if strcmp(CellArray{a,2}{b,1}.entrytype,'ScrptFunc')
            path0 = CellArray{a,2}{b,1}.path;
            script = CellArray{a,2}{b,1}.entrystr;
            [pathschanged,path,err] = TestReplaceRoot(script,path0,SCRPTPATHS);
            if err.flag
                return
            end
            if pathschanged == 1
                CellArray{a,2}{b,1}.path = path;
                CellArray{a,2}{b,1}.searchpath = path;
            end
        end
        if strcmp(CellArray{a,2}{b,1}.entrytype,'RunExtFunc')
            path0 = CellArray{a,2}{b,1}.path;
            script = CellArray{a,2}{b,1}.runfunc1;
            [pathschanged,path,err] = TestReplaceRoot(script,path0,SCRPTPATHS);
            if err.flag
                return
            end
            if pathschanged == 1
                CellArray{a,2}{b,1}.path = path;
                CellArray{a,2}{b,1}.searchpath = path;
            end
        end
        
%-------------------------------------------
% Level 3
%-------------------------------------------
        for c = 1:length(CellArray{a,2}{b,2}(:,1))        
            if isempty(CellArray{a,2}{b,2}{c,1})
                break
            end           
            if strcmp(CellArray{a,2}{b,2}{c,1}.entrytype,'ScrptFunc')
                path0 = CellArray{a,2}{b,2}{c,1}.path;
                script = CellArray{a,2}{b,2}{c,1}.entrystr;
                [pathschanged,path,err] = TestReplaceRoot(script,path0,SCRPTPATHS);
                if err.flag
                    return
                end
                if pathschanged == 1
                    CellArray{a,2}{b,2}{c,1}.path = path;
                    CellArray{a,2}{b,2}{c,1}.searchpath = path;
                end 
            end
            if strcmp(CellArray{a,2}{b,2}{c,1}.entrytype,'RunExtFunc')
                path0 = CellArray{a,2}{b,2}{c,1}.path;
                script = CellArray{a,2}{b,2}{c,1}.runfunc1;
                [pathschanged,path,err] = TestReplaceRoot(script,path0,SCRPTPATHS);
                if err.flag
                    return
                end
                if pathschanged == 1
                    CellArray{a,2}{b,2}{c,1}.path = path;
                    CellArray{a,2}{b,2}{c,1}.searchpath = path;
                end 
            end
            for d = 1:length(CellArray{a,2}{b,2}{c,2}(:,1))        
                if isempty(CellArray{a,2}{b,2}{c,2}{d,1})
                    break
                end           
                if strcmp(CellArray{a,2}{b,2}{c,2}{d,1}.entrytype,'ScrptFunc')
                    path0 = CellArray{a,2}{b,2}{c,2}{d,1}.path;
                    script = CellArray{a,2}{b,2}{c,2}{d,1}.entrystr;
                    [pathschanged,path,err] = TestReplaceRoot(script,path0,SCRPTPATHS);
                    if err.flag
                        return
                    end
                    if pathschanged == 1
                        CellArray{a,2}{b,2}{c,2}{d,1}.path = path;
                        CellArray{a,2}{b,2}{c,2}{d,1}.searchpath = path;
                    end 
                end
                if strcmp(CellArray{a,2}{b,2}{c,2}{d,1}.entrytype,'RunExtFunc')
                    path0 = CellArray{a,2}{b,2}{c,2}{d,1}.path;
                    script = CellArray{a,2}{b,2}{c,2}{d,1}.runfunc1;
                    [pathschanged,path,err] = TestReplaceRoot(script,path0,SCRPTPATHS);
                    if err.flag
                        return
                    end
                    if pathschanged == 1
                        CellArray{a,2}{b,2}{c,2}{d,1}.path = path;
                        CellArray{a,2}{b,2}{c,2}{d,1}.searchpath = path;
                    end
                end     
            end            
        end
    end 
end


%=========================================================
% 
%=========================================================
function [pathschanged,path,err] = TestReplaceRoot(script,path0,SCRPTPATHS)

global COMPASSINFO

err.flag = 0;
err.msg = '';
pathschanged = 0;
path = '';

if isempty(script)
    return
end
if exist(path0,'file')
    return
end
path0 = [COMPASSINFO.USERGBL.softwaredrive path0(4:length(path0))];
test = exist(path0,'file');
if test ~=0 
    pathschanged = 1;
    path = path0;
    return
end

path2 = '';
ind = strfind(path0,'PIONEER');
if not(isempty(ind))
    path1 = path0(ind:length(path0));
    ind = strfind(path1,'\');
    path2 = [SCRPTPATHS.pioneerloc,path1(ind(2)+1:length(path1))];
end
ind = strfind(path0,'NEW HORIZONS');
if not(isempty(ind))
    path1 = path0(ind:length(path0));
    ind = strfind(path1,'\');
    path2 = [SCRPTPATHS.newhorizonsloc,path1(ind(2)+1:length(path1))];
end
ind = strfind(path0,'VOYAGER');
if not(isempty(ind))
    path1 = path0(ind:length(path0));
    ind = strfind(path1,'\');
    path2 = [SCRPTPATHS.voyagerloc,path1(ind(2)+1:length(path1))];
end
ind = strfind(path0,'zs Shared');
if not(isempty(ind))
    path1 = path0(ind:length(path0));
    ind = strfind(path1,'\');
    %path2 = [SCRPTPATHS.scrptshareloc,path1(ind(2)+1:length(path1))];
    path2 = [SCRPTPATHS.scrptshareloc,path1(ind(1)+1:length(path1))];       % change probably needed above
end

test = exist(path2,'file');
if test ~=0 
    pathschanged = 1;
    path = path2;
    return
end
if not(isempty(path2))
    inds = strfind(path2,'\');
    path2 = [path2(1:inds(length(inds))) 'zz Historic' path2(inds(length(inds)):length(path2))];
    test = exist(path2,'file');
    if test ~=0 
        pathschanged = 1;
        path = path2;
        return
    end
end

% display(path0);
% button = questdlg(['Saved path for ''',script,''' does not exist. Search for it?:']);
% if not(strcmp(button,'Yes'));
%     err.flag = 1;
%     err.msg = ['''',script,''' script will not run - it must be found'];
%     return
% end
% path = uigetdir(SCRPTPATHS.rootloc,['Find Script ''',script,'''']);
% if path == 0;
%     err.flag = 1;
%     err.msg = ['''',script,''' script will not run - it must be found'];
%     return
% else
%     pathschanged = 1;
% end


