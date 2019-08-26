%====================================================
%
%====================================================

function [FID1,FID2,expT,Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v2(path1,path2,Test,Sys,Seq,ExpDisp)

FID1 = [];
FID2 = [];
expT = [];
Params = [];
errorflag = 0;
error = '';

if not(exist([path1,filesep,'fid'])) || not(exist([path2,filesep,'fid']))
    errorflag = 1;
    error = [path1,filesep,'fid  - Path Is No Longer Valid'];
    return
end

if strcmp(Sys,'Varian')
    [FID1] = ImportExpArrayFIDmat([path1,filesep,'fid']);
    [FID2] = ImportExpArrayFIDmat([path2,filesep,'fid']);
    if strcmp(Test,'PosLoc');
        [dwell1,np1,gval1,ParamsDisp,StudyDisp,errorflag,error] = PosLocParamsVarian_v1(path1);
        if errorflag == 1
            return
        end
        [dwell2,np2,gval2,ParamsDisp,StudyDisp,errorflag,error] = PosLocParamsVarian_v1(path2);
        if errorflag == 1
            return
        end
        if np1~=np2 || dwell1~=dwell2 || gval1~=gval2
            errorflag = 1;
            error = 'files do not match';
            return
        else
            Params.dwell = dwell1;
            Params.np = np1;
            Params.gval = gval1;
            ExpDisp = [StudyDisp char(13) char(10) ParamsDisp];
        end
    end
    if strcmp(Test,'BackGrad');
        [dwell1,np1,ParamsDisp,StudyDisp,errorflag,error] = BackGradParamsVarian_v1(path1);
        if errorflag == 1
            return
        end
        [dwell2,np2,ParamsDisp,StudyDisp,errorflag,error] = BackGradParamsVarian_v1(path2);
        if errorflag == 1
            return
        end
        if np1~=np2 || dwell1~=dwell2
            errorflag = 1;
            error = 'files do not match';
            return
        else
            Params.dwell = dwell1;
            Params.np = np1;
            ExpDisp = [ExpDisp ParamsDisp];
        end
    end
    if strcmp(Test,'Transient');
        func = str2func([Seq,'_LoadVarian']);
        [dwell1,np1,gval1,gofftime1,FID1,ParamsDisp,StudyDisp,errorflag,error] = func(path1);
        if errorflag == 1
            return
        end
        [dwell2,np2,gval2,gofftime2,FID2,ParamsDisp,StudyDisp,errorflag,error] = func(path2);
        if errorflag == 1
            return
        end
        if np1~=np2 || dwell1~=dwell2 || gval1~=gval2 || length(gofftime1)~=length(gofftime2)
            errorflag = 1;
            error = 'files do not match';
            return
        else
            Params.dwell = dwell1;
            Params.np = np1;
            Params.gofftime = gofftime1;
            Params.gval = gval1;
            ExpDisp = [ExpDisp ParamsDisp];
        end
    end
    if strcmp(Test,'During');
        func = str2func([Seq,'_LoadVarian']);
        [dwell1,np1,gval1,gofftime1,FID1,ParamsDisp,StudyDisp,errorflag,error] = func(path1);
        if errorflag == 1
            return
        end
        [dwell2,np2,gval2,gofftime2,FID2,ParamsDisp,StudyDisp,errorflag,error] = func(path2);
        if errorflag == 1
            return
        end
        if np1~=np2 || dwell1~=dwell2 || gval1~=gval2 || length(gofftime1)~=length(gofftime2)
            errorflag = 1;
            error = 'files do not match';
            return
        else
            Params.dwell = dwell1;
            Params.np = np1;
            Params.gofftime = gofftime1;
            Params.gval = gval1;
            ExpDisp = [ExpDisp ParamsDisp];
        end
    end      
elseif strcmp(Sys,'SMIS')
    if strcmp(Test,'PosLoc');
        [dwell1,np1,gval1,errorflag,error] = PosLocParamsSMIS_v1(path1);
        if errorflag == 1
            return
        end
        [dwell2,np2,gval2,errorflag,error] = PosLocParamsSMIS_v1(path2);
        if errorflag == 1
            return
        end
        if np1~=np2 || dwell1~=dwell2 || gval1~=gval2
            errorflag = 1;
            error = 'posloc files do not match';
            return
        else
            Params.dwell = dwell1;
            Params.np = np1;
            Params.gval = gval1;
            nSets = 1;
            DataSetOffset = 0;
            [FID1,Pars] = ReadSMIS_v1(path1,DataSetOffset,nSets);
            [FID2,Pars] = ReadSMIS_v1(path2,DataSetOffset,nSets);
            FID1 = permute(FID1,[2 1]);
            FID2 = permute(FID2,[2 1]);
            FID1 = conj(FID1);            % to make further into magnet positive, and out of magnet negative
            FID2 = conj(FID2);
        end
    end
    if strcmp(Test,'BackGrad');
        [dwell1,np1,errorflag,error] = BackGradParamsSMIS_v1(path1);
        if errorflag == 1
            return
        end
        [dwell2,np2,errorflag,error] = BackGradParamsSMIS_v1(path2);
        if errorflag == 1
            return
        end
        if np1~=np2 || dwell1~=dwell2
            errorflag = 1;
            error = 'backgrad files do not match';
            return
        else
            Params.dwell = dwell1;
            Params.np = np1;
            nSets = 1;
            DataSetOffset = 0;
            [FID1,Pars] = ReadSMIS_v1(path1,DataSetOffset,nSets);
            [FID2,Pars] = ReadSMIS_v1(path2,DataSetOffset,nSets);
            FID1 = permute(FID1,[2 1]);
            FID2 = permute(FID2,[2 1]);
            FID1 = conj(FID1);            % to make further into magnet positive, and out of magnet negative
            FID2 = conj(FID2);
        end
    end
    if strcmp(Test,'Transient');
        func = str2func([Seq,'_LoadSMIS']);
        [dwell1,np1,gval1,gofftime1,FID1,errorflag,error] = func(path1);
        if errorflag == 1
            return
        end
        [dwell2,np2,gval2,gofftime2,FID2,errorflag,error] = func(path2);
        if errorflag == 1
            return
        end
        if np1~=np2 || dwell1~=dwell2 || gval1~=gval2 || length(gofftime1)~=length(gofftime2)
            errorflag = 1;
            error = 'transient files do not match';
            return
        else
            Params.dwell = dwell1;
            Params.np = np1;
            Params.gofftime = gofftime1;
            Params.gval = gval1;
        end
    end
end

expT = Params.dwell*(0:1:Params.np-1);
%expT = expT-0.5*Params.dwell;                             % Difference value at centre of interval
