function GLDataLoad()
% GLDataLoad()
% use FileFinder to find all the files within the
% GainLossDataRelease/RawData folder
% finds both .txt and .mat output files, and saves as structures


    %find learning data
    learningMats = FileFinder('../GainLossDataRelease/RawData','Gain Loss','Learn','*.mat');
    learningTxts = FileFinder('../GainLossDataRelease/RawData','Gain Loss','Learn','*.txt');

    %0 min test
    test0Mats = FileFinder('../GainLossDataRelease/RawData','Gain Loss','Immediate','*.mat');
    test0Txts = FileFinder('../GainLossDataRelease/RawData','Gain Loss','Immediate','*.txt');
    
    %30 min test
    test30Mats = FileFinder('../GainLossDataRelease/RawData','Gain Loss','30 minutes','*.mat');
    test30Txts = FileFinder('../GainLossDataRelease/RawData','Gain Loss','30 minutes','*.txt');
    
    %24 hr test
    test24Mats = FileFinder('../GainLossDataRelease/RawData','Gain Loss','24hrs','*.mat');
    test24Txts = FileFinder('../GainLossDataRelease/RawData','Gain Loss','24hrs','*.txt');
    
    %save all
    save('GLDataLoad.mat')
end