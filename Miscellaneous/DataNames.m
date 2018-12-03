function f = DataNames()
%DataNames gives the absolute path name for each data file in the 
%DiscreteWavelets package.

global DWDATAPATH;

file=strcat(DWDATAPATH,'Data.txt');
fid=fopen(file);
k=1;
while 1
    p = fgetl(fid);
    if ~ischar(p),   break,   end
    [name,p] = strtok(p, ';');
    f{k}=strcat(DWDATAPATH,name);
    k=k+1;
end
fclose(fid);

