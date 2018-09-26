function GLDataAnalysis()
% GLDataAnalysis()
% Loads GLDataProcess.mat, uses the files found there to load in the actual
% data, process and analyse that data

    load('GLDataProcess.mat')%get matfiles info

    halfPath = 'C:\Users\pyjpg\Local Documents\Work\DARet1\GainLossDataRelease\RawData';%start of path to data

    lNSess = length(dataMats.learning);%number of learning sessions with data
    nPps = lNSess/2;%number of participants

    %% learning trials
%     loop and pass to GLBehDataLoad to load up and extract and calc variables

    %preallocate for looping
    lWinnings = nan(1,lNSess);%amount of money won
    lNTrials = lWinnings;%number of trials completed
    lNumEach = nan(4,lNSess);%number of each feedback received
    lCardChosen = nan(180,lNSess);%card chosen
    lCardNotChosen = lCardChosen;%card not chosen
    lOptimal = lCardChosen;%whether the choice was optimal
    lFeedback = lCardChosen;%feedback received
    lRT = lCardChosen;%reaction time

    drug = false(1,lNSess);%for drug/placebo
    placebo = drug;
    ppid = nan(1,lNSess);%participant ID

    for iSess = 1:lNSess%extract data for each pp/session
        fullPath = strcat(halfPath,dataMats.learning(iSess).path,'\',dataMats.learning(iSess).file);%path to learning file
        dataMats.learning(iSess).data = load(fullPath);%load up file

        dataMats.learning(iSess).data = GLBehLearnLoad(dataMats.learning(iSess).data);%process learning data

        %now extract things into matrices - 1 col per session
        lCardChosen(:,iSess) = dataMats.learning(iSess).data.cardChosen;
        lCardNotChosen(:,iSess) = dataMats.learning(iSess).data.cardNotChosen;
        lOptimal(:,iSess) = dataMats.learning(iSess).data.optimal;
        lFeedback(:,iSess) = dataMats.learning(iSess).data.feedback;
        lRT(:,iSess) = dataMats.learning(iSess).data.LearnRT;

        lWinnings(1,iSess) = dataMats.learning(iSess).data.winnings;
        lNumEach(1,iSess) = dataMats.learning(iSess).data.numWon;
        lNumEach(2,iSess) = dataMats.learning(iSess).data.numLost;
        lNumEach(3,iSess) = dataMats.learning(iSess).data.numLook;
        lNumEach(4,iSess) = dataMats.learning(iSess).data.numNothing;
        lNTrials(1,iSess) = dataMats.learning(iSess).data.nTrials;
        drug(1,iSess) = dataMats.learning(iSess).drug;
        placebo(1,iSess) = 1 - drug(iSess);
        ppid(1,iSess) = dataMats.learning(iSess).ppid;
    end

    lAcc = sum(lOptimal)./120 * 100;%mean acc for gain & loss pairs. look pair not considered optimal during learning

    lPairInds = false(180,lNSess,3);
    lPairChoices = nan(60,lNSess,3);
    for iPair = 1:3%for each pair
        for iSess = 1:lNSess%for each pp
            lPairInds(:,iSess,iPair) = (lCardChosen(:,iSess) == (iPair*2-1)) | (lCardChosen(:,iSess) == (iPair*2));%get indices of each pair
            lPairChoices(1:sum(lPairInds(:,iSess,iPair)),iSess,iPair) = lCardChosen(lPairInds(:,iSess,iPair),iSess);%get choice on those pairs
        end
    end

    %get whether each choice was correct
    lOptimalPair = lPairChoices == 1 | lPairChoices == 3 | lPairChoices ==6;
    lCumulChoice = cumsum(lOptimalPair);%cumulative optimal choices
    
    lEachChoice = squeeze(mean(lOptimalPair));%get mean for each pp
    lEachChoice = lEachChoice.*100;%turn into percentage

    %% novel pairs task
    %call GLBehTestLoad on each file

    t0NSess = length(dataMats.test0);%number of sessions
    t0CardChosen = nan(90,t0NSess);%card chosen on each trial
    t0CardNotChosen = t0CardChosen;%card not chosen on each trial
    t0Optimal = t0CardChosen;%whether it was optimal choice
    t0RT = t0CardChosen;%reaction time
    t0NTrials = nan(1,t0NSess);%number of trials
    t0Choose = nan(6,t0NSess);%percentage of choices of each card
    t0Avoid = t0Choose;%percentage avoids

    for iSess = 1:t0NSess%for each session

        fullPath = strcat(halfPath,dataMats.test0(iSess).path,'\',dataMats.test0(iSess).file);%path to learning file
        dataMats.test0(iSess).data = load(fullPath);%load up file

        dataMats.test0(iSess).data = GLBehTestLoad(dataMats.test0(iSess).data);%process data

        t0NTrials(iSess) = dataMats.test0(iSess).data.nTrials;
        if t0NTrials(iSess)%if the test was completed, store data in matrices
            t0CardChosen(1:t0NTrials(iSess),iSess) = dataMats.test0(iSess).data.cardChosenTest;
            t0CardNotChosen(1:t0NTrials(iSess),iSess) = dataMats.test0(iSess).data.cardNotChosenTest;
            t0Optimal(1:t0NTrials(iSess),iSess) = dataMats.test0(iSess).data.optimal;
            t0Choose(:,iSess) = dataMats.test0(iSess).data.choose;
            t0Avoid(:,iSess) = dataMats.test0(iSess).data.avoid;
            t0RT(1:t0NTrials(iSess),iSess) = dataMats.test0(iSess).data.testRT;
        end

    end
    t0Acc = nanmean(t0Optimal).*100;%make percentage
    t0ChA = t0Choose(1,:);%separate out choices
    t0ChB = t0Choose(2,:);
    t0ChC = t0Choose(3,:);
    t0ChD = t0Choose(4,:);
    t0ChE = t0Choose(5,:);
    t0ChF = t0Choose(6,:);
    t0AvA = t0Avoid(1,:);
    t0AvB = t0Avoid(2,:);
    t0AvC = t0Avoid(3,:);
    t0AvD = t0Avoid(4,:);
    t0AvE = t0Avoid(5,:);
    t0AvF = t0Avoid(6,:);

    t0PairsAcc = NaN(3,nSess);%accuracy on each learning pair
    for iPair = 1:3
        t0PairsAcc(iPair,:) = sum(t0CardChosen==iPair & t0CardNotChosen==iPair+1) ./6 * 100;
    end
    t0PairsAcc(3,:) = 100 - t0PairsAcc(3,:);%invert EF to get choose least punished
    %% t30 test - same as above
    t30NSess = length(dataMats.test30);%num sessions
    t30CardChosen = nan(90,t30NSess);
    t30CardNotChosen = t30CardChosen;
    t30Optimal = t30CardChosen;
    t30RT = t30CardChosen;
    t30NTrials = nan(1,t30NSess);
    t30Choose = nan(6,t30NSess);
    t30Avoid = t30Choose;

    for iSess = 1:t30NSess

        fullPath = strcat(halfPath,dataMats.test30(iSess).path,'\',dataMats.test30(iSess).file);%path to learning file
        dataMats.test30(iSess).data = load(fullPath);%load up file

        dataMats.test30(iSess).data = GLBehTestLoad(dataMats.test30(iSess).data);%process data

        t30NTrials(iSess) = dataMats.test30(iSess).data.nTrials;
        if t30NTrials(iSess)
            t30CardChosen(1:t30NTrials(iSess),iSess) = dataMats.test30(iSess).data.cardChosenTest;
            t30CardNotChosen(1:t30NTrials(iSess),iSess) = dataMats.test30(iSess).data.cardNotChosenTest;
            t30Optimal(1:t30NTrials(iSess),iSess) = dataMats.test30(iSess).data.optimal;
            t30Choose(:,iSess) = dataMats.test30(iSess).data.choose;
            t30Avoid(:,iSess) = dataMats.test30(iSess).data.avoid;
            t30RT(1:t30NTrials(iSess),iSess) = dataMats.test30(iSess).data.testRT;
        end
    end
    t30Acc = nanmean(t30Optimal).*100;
    t30ChA = t30Choose(1,:);
    t30ChB = t30Choose(2,:);
    t30ChC = t30Choose(3,:);
    t30ChD = t30Choose(4,:);
    t30ChE = t30Choose(5,:);
    t30ChF = t30Choose(6,:);
    t30AvA = t30Avoid(1,:);
    t30AvB = t30Avoid(2,:);
    t30AvC = t30Avoid(3,:);
    t30AvD = t30Avoid(4,:);
    t30AvE = t30Avoid(5,:);
    t30AvF = t30Avoid(6,:);


    t30PairsAcc = NaN(3,nSess);%accuracy on each learning pair
    for iPair = 1:3
        t30PairsAcc(iPair,:) = sum(t30CardChosen==iPair & t30CardNotChosen==iPair+1) ./6 * 100;
    end
    t30PairsAcc(3,:) = 100 - t30PairsAcc(3,:);%invert EF to get choose least punished
    
    %% t24 test - same as above
    t24Sess = length(dataMats.test24);
    t24CardChosen = nan(90,t24Sess);
    t24CardNotChosen = t24CardChosen;
    t24Optimal = t24CardChosen;
    t24RT = t24CardChosen;
    t24NTrials = nan(1,t24Sess);
    t24Choose = nan(6,t24Sess);
    t24Avoid = t24Choose;

    for iSess = 1:t24Sess

        fullPath = strcat(halfPath,dataMats.test24(iSess).path,'\',dataMats.test24(iSess).file);%path to learning file
        dataMats.test24(iSess).data = load(fullPath);%load up file

        dataMats.test24(iSess).data = GLBehTestLoad(dataMats.test24(iSess).data);%process data

        t24NTrials(iSess) = dataMats.test24(iSess).data.nTrials;

        if t24NTrials(iSess)
            t24CardChosen(1:t24NTrials(iSess),iSess) = dataMats.test24(iSess).data.cardChosenTest;
            t24CardNotChosen(1:t24NTrials(iSess),iSess) = dataMats.test24(iSess).data.cardNotChosenTest;
            t24Optimal(1:t24NTrials(iSess),iSess) = dataMats.test24(iSess).data.optimal;
            t24Choose(:,iSess) = dataMats.test24(iSess).data.choose;
            t24Avoid(:,iSess) = dataMats.test24(iSess).data.avoid;
            t24RT(1:t24NTrials(iSess),iSess) = dataMats.test24(iSess).data.testRT;
        end
    end
    t24Acc = nanmean(t24Optimal).*100;
    t24ChA = t24Choose(1,:);
    t24ChB = t24Choose(2,:);
    t24ChC = t24Choose(3,:);
    t24ChD = t24Choose(4,:);
    t24ChE = t24Choose(5,:);
    t24ChF = t24Choose(6,:);
    t24AvA = t24Avoid(1,:);
    t24AvB = t24Avoid(2,:);
    t24AvC = t24Avoid(3,:);
    t24AvD = t24Avoid(4,:);
    t24AvE = t24Avoid(5,:);
    t24AvF = t24Avoid(6,:);


    t24PairsAcc = NaN(3,nSess);%accuracy on each learning pair
    for iPair = 1:3
        t24PairsAcc(iPair,:) = sum(t24CardChosen==iPair & t24CardNotChosen==iPair+1) ./6 * 100;
    end
    t24PairsAcc(3,:) = 100 - t24PairsAcc(3,:);%invert EF to get choose least punished

    %% difference scores - difference between trials or conditions

    t24_30Acc = t24Acc - t30Acc;
    t24_0Choose = t24Choose - t0Choose;
    t24_0ChA = t24_0Choose(1,:);
    t24_0ChB = t24_0Choose(2,:);
    t24_0ChC = t24_0Choose(3,:);
    t24_0ChD = t24_0Choose(4,:);
    t24_0ChE = t24_0Choose(5,:);
    t24_0ChF = t24_0Choose(6,:);

    t24_0Acc = t24Acc - t0Acc;
    t24_30Choose = t24Choose - t30Choose;
    t24_30ChA = t24_30Choose(1,:);
    t24_30ChB = t24_30Choose(2,:);
    t24_30ChC = t24_30Choose(3,:);
    t24_30ChD = t24_30Choose(4,:);
    t24_30ChE = t24_30Choose(5,:);
    t24_30ChF = t24_30Choose(6,:);

    t30_0Acc = t30Acc - t0Acc;
    t30_0Choose = t30Choose - t0Choose;
    t30_0ChA = t24_30Choose(1,:);
    t30_0ChB = t24_30Choose(2,:);
    t30_0ChC = t24_30Choose(3,:);
    t30_0ChD = t24_30Choose(4,:);
    t30_0ChE = t24_30Choose(5,:);
    t30_0ChF = t24_30Choose(6,:);

    t24ChooseDiff = t24Choose(:,drug) - t24Choose(:,placebo);
    t24AccDiff = t24Acc(drug)-t24Acc(placebo);
    lAccDiff = lAcc(drug)-lAcc(placebo);
    t0AccDiff = t0Acc(drug)-t0Acc(placebo);
    t30AccDiff = t30Acc(drug)-t30Acc(placebo);
    %% save
    save('GLDataAnalysis.mat')
    
end