function [] = DataList()
%DataList gives information about data files that come with the 
%DiscreteWavelets package.

global DWDATAPATH;

str=sprintf('\n\nThe base directory for the images is \n\n %s \n\n',DWDATAPATH);
disp(str);

header=sprintf('DATA FILES\n');
disp(header);
file=strcat(DWDATAPATH,'Data.txt');
fid=fopen(file);
while 1
    p = fgetl(fid);
    if ~ischar(p),   break,   end
    [fname,p] = strtok(p, ';');
    [fsamps,p]=strtok(p,';');
    [fcomment,p]=strtok(p,';');
    str=sprintf('Name: %s\n\t\tSize: %s\n\t\tDescription: %s\n',fname,fsamps,fcomment);
    disp(str);
end
fclose(fid);
