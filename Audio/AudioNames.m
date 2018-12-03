function f = AudioNames()
%AudioNames gives the absolute path name for each audio file in the 
%DiscreteWavelets package.

global DWSOUNDSPATH;

file=strcat(DWSOUNDSPATH,'Sounds.txt');
fid=fopen(file);
k=1;
while 1
    p = fgetl(fid);
    if ~ischar(p),   break,   end
    [name,p] = strtok(p, ';');
    f{k}=strcat(DWSOUNDSPATH,name);
    k=k+1;
end
fclose(fid);

