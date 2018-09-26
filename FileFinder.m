function [dataStruct, fileList] = FileFinder(searchDir,taskFolder,timeFolder,fileString)
% [dataStruct, fileList] = FileFinder(searchDir,taskFolder,timeFolder,fileString)
% finds all the files matching 'fileString' within folders matching
% startDir, taskFolder and timeFolder
% outputs: dataStruct - a structure containing ppid,task,time,path and
% fileName
% fileList - the lits of files returned from the search

    originalDir = cd;
    % move to data folder
    cd(searchDir)% move to directory to start search in
        
    systemString = sprintf('dir /S %s',fileString);%put the file name into format for system command
    
    [~,fileList] = system(systemString);%search for the files
    
    %% now extract the paths and file names from this text
    
    %create a string to search for PPID folders, split by taskName and
    %timeName
    pathStartString = sprintf('\\\\PPID\\d\\d\\\\Days \\d&\\d\\\\%s\\\\%s',taskFolder,timeFolder);
    textStarts = regexpi(fileList,pathStartString);% get the beginning of section of text per file
    
    blank = NaN;%set this up to preallocate dataStruct
    dataStruct = struct('ppid',blank,'sesNo',blank,'versNo',blank,'letter',blank,...
        'task',blank,'time',blank,'path',blank,'file',blank);%preallocate
    
    for i=1:length(textStarts)%for each file found        
       
        fileText = fileList(textStarts(i):textStarts(i)+120);%take a chunk that will have the path in
        
        %get indices of separators in text
        slashIndices = regexp(fileText,'\\');%find all slashes
        whitespaceIndices = regexp(fileText,'\s');%find all white spaces
        
        ppidInd = regexp(fileText,'PPID','end')+1;
        ppid = fileText(ppidInd(1):ppidInd(1)+1);
        dataStruct(i).ppid = str2num(ppid);
%         dataStruct(i).ppid = fileText(slashIndices(1)+1:slashIndices(2)-1);%extract the ppid and store
        dataStruct(i).task = fileText(slashIndices(3)+1:slashIndices(4)-1);%extract the taskName and store
        
        %find the first space after the taskName, which marks the end of
        %the path
        fslashIndices = regexp(fileText,'/');%find all forward slashes
        pathEnd = fslashIndices(1)-5;%5 places before 1st fslash
%         pathEnd = whitespaceIndices(find(whitespaceIndices>slashIndices(4),1)) - 1;
        
        dataStruct(i).time = fileText(slashIndices(4)+1:pathEnd);%extract time and store
        
        %get relative pathName
        dataStruct(i).path = fileText(1:pathEnd);%put path into files col 2

        colonIndex = regexp(fileText,':');%get the index of the colon
        
        fileNameStart = regexp(fileText(colonIndex:end),'\d \w','end');%find number-space-letter pattern after colon, first is start of file name
        
        fileStart = fileNameStart(1) + colonIndex - 1;% add the colonIndex and minus one to get first letter of fileName
        
        
        dotIndex = regexp(fileString,'\.');%find where the dot is in the fileName
        fileNameExtension = fileString(dotIndex+1:end);%extract the extension (after the dot)     
        
        fileEnd = regexpi(fileText,fileNameExtension,'end');%find end of file in fileText
        
        file = fileText(fileStart:fileEnd);%extract fileName and store
        dataStruct(i).file = file;
        
        % get session number
        sesNoIndex = regexpi(file,'sesNo|Sess','end') + 1;
        dataStruct(i).sesNo = str2num(file(sesNoIndex));
        
        %get version number
        versNoIndex = regexpi(file,'versNo|Vers','end') + 1;
        dataStruct(i).versNo = str2num(file(versNoIndex));
        
        %if there is a letter version after Test or Learn store it
        letterIndex = regexpi(file,'Test|Learn','end')+1;
        letter = file(letterIndex);
        if regexp(letter,'[ABCD]')
            dataStruct(i).letter = letter;
        end
            
        
    end
    
    %move back to original directory
    cd(originalDir)
end