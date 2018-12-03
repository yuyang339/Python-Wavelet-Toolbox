function [] = startup()
%Run this function to load appropriate paths
global DAUBLENGTH;
global COIFLENGTH;
global DWIMAGESPATH;
global DWDATAPATH;
global DWSOUNDSPATH;
DAUBLENGTH=0;
COIFLENGTH=0;
disp('Initializing global variables for use with the DiscreteWavelets toolbox:');
str=sprintf('\tSetting the global variable DAUBLENGTH=0.');
disp(str);
str=sprintf('\tSetting the global variable COIFLENGTH=0.');
disp(str);
p=pathdef;
while true
   [str, p] = strtok(p, ';');
   if isempty(str),  break;  end
   if strfind(str,'DiscreteWavelets\Images\Color')
       DWIMAGESPATH=strrep(str,'Color','');
       str=sprintf('\tSetting the global variable DWIMAGESPATH=%s.',DWIMAGESPATH);
       disp(str);
   end
   if strfind(str,'DiscreteWavelets\Data')
       DWDATAPATH=strcat(str,filesep);
       str=sprintf('\tSetting the global variable DWDATAPATH=%s.',DWDATAPATH);
       disp(str);
   end
   if strfind(str,'DiscreteWavelets\Sounds')
       DWSOUNDSPATH=strcat(str,filesep);
       str=sprintf('\tSetting the global variable DWSOUNDSPATH=%s.',DWSOUNDSPATH);
       disp(str);
   end
end
disp('Initialization of global variables complete.');
