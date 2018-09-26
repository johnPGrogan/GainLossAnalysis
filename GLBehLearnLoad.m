function dataStruct = GLBehLearnLoad(dataStruct)
% GLBehDataLoad - runs data processing on learning data
% gets optimal choice for each trial, and the feedback value
% calcs total winnings, number of wins, losses, looks, nothings
% saves all of these in the dataStruct and returns this
% NOTE: card 5 = 80% loss, and card 6 = 20% loss. 
    
    dataStruct.nTrials = length(dataStruct.cardChosen);%number of trials
    
    dataStruct.optimal = zeros(dataStruct.nTrials,1);%optimal choice
    dataStruct.optimal(dataStruct.cardChosen == 1 | dataStruct.cardChosen == 6,1) = 1;%if A or F chosen, optimal
%     look pair are not considered during the learning as there is no clear
%     right/wrong answer between the two

    dataStruct.feedback = ones(dataStruct.nTrials,1)*9;%set to nine initially (so obvious if error)
    dataStruct.feedback(dataStruct.outcomes == 1) = 1;%gain
    dataStruct.feedback(dataStruct.outcomes == 2) = 0;%nothing
    dataStruct.feedback(dataStruct.outcomes == 3) = NaN;%look
    dataStruct.feedback(dataStruct.outcomes == 4) = -1;%loss
        
    dataStruct.numWon = sum(dataStruct.outcomes==1);%count number of wins
    dataStruct.numLost = sum(dataStruct.outcomes==4);%num losses
    dataStruct.numLook = sum(dataStruct.outcomes==3);%num looks
    dataStruct.numNothing = sum(dataStruct.outcomes==2);%num nothings
    dataStruct.winnings = (dataStruct.numWon-dataStruct.numLost)*0.2;%get winnings in £s (20p per win or lose)

end

