% GLDataFormatting

%get list of all learning files
load('GLDataLoad.mat')

startDir = cd;
% for each text file, run GLLearnTextToMat
halfPath = 'C:\Users\pyjpg\Local Documents\Work\DARet1\Data';

% for i = 1:length(learningTxts)
%     fullPath = strcat(halfPath,learningTxts(i).path);
%     GLLearnTextToMat(fullPath,learningTxts(i).ppid,learningTxts(i).sesNo,learningTxts(i).versNo)
% end

cd(startDir)

for i = 1:length(test0Mats)
    i
    fullPath = strcat(halfPath,test0Mats(i).path);
%     GLTestTextToMat(fullPath,test0Txts(i).ppid,test0Txts(i).sesNo,test0Txts(i).versNo,test0Txts(i).file);
    
    file = strcat(fullPath,'\',test0Mats(i).file);
    GLRenameTestMatVariables(file);
end
    
for i = 1:length(test30Mats)
    i
    fullPath = strcat(halfPath,test30Mats(i).path);
%     GLTestTextToMat(fullPath,test0Txts(i).ppid,test0Txts(i).sesNo,test0Txts(i).versNo,test0Txts(i).file);
    
    file = strcat(fullPath,'\',test30Mats(i).file);
    GLRenameTestMatVariables(file);
end

for i = 1:length(test24Mats)
    i
    fullPath = strcat(halfPath,test24Mats(i).path);
%     GLTestTextToMat(fullPath,test0Txts(i).ppid,test0Txts(i).sesNo,test0Txts(i).versNo,test0Txts(i).file);
    
    file = strcat(fullPath,'\',test24Mats(i).file);
    GLRenameTestMatVariables(file);
end

cd(startDir)

