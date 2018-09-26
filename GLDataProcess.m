function GLDataProcess()
% GLDataProcess()
% loads info about GL files found, excludes withdrawn/excluded 
% participants, adds in conditions, saves

    %get list of all files
    load('GLDataLoad.mat')

    %% exclude some pps

    ppsToExclude = [3,4,15,33];%did not complete both sessions

    learningMats = ExcludePps(learningMats,ppsToExclude);
    test0Mats = ExcludePps(test0Mats,ppsToExclude);
    test30Mats = ExcludePps(test30Mats,ppsToExclude);
    test24Mats = ExcludePps(test24Mats,ppsToExclude);


    %% combine into one structure 

    dataMats = struct('learning',learningMats,'test0',test0Mats,'test30',test30Mats,'test24',test24Mats);
    dataMatFields = fieldnames(dataMats);%get field names

    %% get conditions for each pp
    conditionsMat = load('../GainLossDataRelease/RawData/Unblinded conditions.txt');

    for j = 1:4%for each test type i.e. learning, 0min...
        nSess = length(dataMats.(dataMatFields{j}));%get number of sessions
        for i = 1:nSess%get condition order, and condition for that session
            condition = conditionsMat(dataMats.(dataMatFields{j})(i).ppid,2);%get which session drug was given
            dataMats.(dataMatFields{j})(i).condition = condition;%store
            dataMats.(dataMatFields{j})(i).drug = dataMats.(dataMatFields{j})(i).sesNo == condition;%get whether drug was given in this condition
        end
    end

    %% save
    save('GLDataProcess.mat')
end

function dataStruct = ExcludePps(dataStruct,ppsToExclude)
% dataStruct = ExcludePps(dataStruct,ppsToExclude)
% removes pps who match ppsToExclude from dataStruct

    nPps = length(dataStruct);%number of participants
    
    nPpsToExclude = length(ppsToExclude);%how many to exclude
    excludeIndices = zeros(nPps,nPpsToExclude);%preallocate

    for i = 1:nPpsToExclude%get the ones that match exclusions
        excludeIndices(:,i) = [dataStruct.ppid]==ppsToExclude(i);
    end
    excludeIndices = logical(sum(excludeIndices,2));%make into one vector

    dataStruct(excludeIndices) = [];%exclude
end