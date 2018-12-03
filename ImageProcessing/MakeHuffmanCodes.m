function [uniq,freq,codes,origlen,newlen]=MakeHuffmanCodes(A)
%MakeHuffmanCodes takes either a vector or matrix of integers, a character
%string, or a cell array whose elements are characters and returns the
%following:
%
%uniq is either an array of integers or a cell array of characters (depending on the input A)
%that holds the unique elements of the input A
%
%freq holds the frequencies of uniq
%
%codes contains the Huffman codes for uniq
%
%origlen is the original length of the input bitstream A
%
%newlen is the length of the bitstream using Huffman codes.
%
%This function is based on the function huffman5 written by Sean Danaher,
%University of Northumbria, Newcastle UK, 
%http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=227&objectType=File
%

if isnumeric(A)
    [r c]=size(A);
    a=reshape(A,1,r*c);
    if max(a-round(a))~=0
        str=sprintf('MakeHuffmanTree - The elements of the input matrix or vector must be nonnegative integers.');
        disp(str);
        return;
    end
elseif iscellstr(A)
    a=zeros(1,length(A));
    for k=1:length(A)
        a(k)=uint8(A{k});
    end
elseif ischar(A)
    a=zeros(1,length(A));
    for k=1:length(A)
        a(k)=uint8(A(k));
    end
else
    str=sprintf('MakeHuffmanTree - Unable to identify the data type.  Please enter a vector or matrix of integers, a cell array of single characters, or a string.');
    disp(str);
    return;
end

vals=unique(a)';
N=length(vals);

freq=histc(a,vals)'/length(a);
origlen=8*length(a);

c=maketree(freq);       
dict=char(getcodes(c,N));

newlen=0;
codes=cell(N,1);
for k=1:N
    newlen=newlen+length(a).*freq(k).*length(deblank(dict(k,:)));
    codes{k}=str2mat(deblank(dict(k,:)));
end

if ~isnumeric(A) %convert unique values back to characters
    uniq=cell(N,1);
    for k=1:N
        %uniq{k}=sprintf('%i',vals(k));
        uniq{k}=char(vals(k));
    end
else
    uniq=vals;
end
    

function c=maketree(p)
% Create Huffman tree from frequency vector p.
c=cell(length(p),1);			
for i=1:length(p)				
   c{i}=i;						
end
while numel(c)>2					
	[p,i]=sort(p);					
	c=c(i);							
	c{2}={c{1},c{2}};c(1)=[];	
	p(2)=p(1)+p(2);p(1)=[];
end

function y=getcodes(a,n)
% get Huffman codes from tree c.

global y;
y=cell(n,1);
getcodesrec(a,[])

function getcodesrec(a,dum)
% called recursively by getcodes.

global y
if isa(a,'cell')
         getcodesrec(a{1},[dum 0]);
         getcodesrec(a{2},[dum 1]);
else   
   y{a}=char(48+dum);   
end

