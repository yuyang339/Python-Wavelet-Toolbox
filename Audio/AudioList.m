function [] = AudioList()
%AudioList gives information about audio files that come with the 
%DiscreteWavelets package.

global DWSOUNDSPATH;

str=sprintf('\n\nThe base directory for the images is \n\n %s \n\n',DWSOUNDSPATH);
disp(str);

header=sprintf('AUDIO FILES\n');
disp(header);
file=strcat(DWSOUNDSPATH,'Sounds.txt');
fid=fopen(file);
while 1
    p = fgetl(fid);
    if ~ischar(p),   break,   end
    [fname,p] = strtok(p, ';');
    [ftype,p]=strtok(p,';');
    [fdur,p]=strtok(p,';');
    [fchan,p]=strtok(p,';');
    [fsrate,p]=strtok(p,';');
    [fsamps,p]=strtok(p,';');
    str=sprintf('Name: %s\n\t\tType: %s,\tDuration: %ss,\tChannels: %s\n\t\tSample Rate: %s,\tSamples: %s\n',fname,ftype,fdur,fchan,fsrate,fsamps);
    disp(str);
end
fclose(fid);
