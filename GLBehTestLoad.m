function dataStruct = GLBehTestLoad(dataStruct)
% GLBehTestLoad - runs data processing on learning data
% gets optimal choices, number of times each card is chosen, avoided
% saves these to the dataStruct and returns that
% NOTE: card 5 = 80% loss and card 6 = 20% loss. need to swap them to make
% it into an order of decreasing value

    dataStruct.nTrials = length(dataStruct.cardChosenTest);%number of trials
    
    if dataStruct.nTrials < 90%this will NaN any incomplete data
        dataStruct.stimOrderTest = nan(90,1);
        dataStruct.testResp = nan(90,1);
        dataStruct.testRT= nan(90,1);
        dataStruct.cardChosenTest = nan(90,1);
        dataStruct.cardNotChosenTest = nan(90,1);
        dataStruct.nTrials = 0;
        dataStruct.optimal = nan(90,1);
        dataStruct.choose = nan(6,1);
        dataStruct.avoid = nan(6,1);
    else
        
    optimal = zeros(dataStruct.nTrials,1);%preallocate
    %
    for i = 1:dataStruct.nTrials%loop through trials, get optimal
        switch dataStruct.cardChosenTest(i)%use chosen card
            case 1%if card A, optimal
                optimal(i) = 1;
            case 2%if B and unchosen wasn't A, optimal
                if dataStruct.cardNotChosenTest(i) == 1
                    optimal(i) = 0;
                else
                    optimal(i) = 1;
                end
            case 3%if chose C, and was against A or B, not optimal
                if dataStruct.cardNotChosenTest(i) < 3
                    optimal(i) = 0;
                else%otherwise optimal
                    optimal(i) = 1;%opt if not again gain cards
                end
            case 4%if chose D and was against A-C, not optimal
                if dataStruct.cardNotChosenTest(i) < 3
                    optimal(i) = 0;
                else
                    optimal(i) = 1;%opt if not again gain cards
                end
            case 6%if chose 20% loss
                if dataStruct.cardNotChosenTest(i) == 5%only if alternative was 5
                    optimal(i) = 1;
                else
                    optimal(i) = 0;
                end
            case 5
                optimal(i) = 0;%always bad
        end
    end
    
    dataStruct.choose = zeros(6,1);%preallocate
    realCardInds = [1,2,3,4,6,5];%swap cols 5 and 6 (E&F) so that 6th col is the 80%loss card
    for i = 1:6%percentage of choices for each card
        dataStruct.choose(i,1) = sum(dataStruct.cardChosenTest == realCardInds(i))/30*100;
    end
    dataStruct.avoid = 100 - dataStruct.choose;%opposite of choose

    dataStruct.optimal = optimal;%store in struct
    
    end
end

