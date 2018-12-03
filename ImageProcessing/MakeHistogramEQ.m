function n = MakeHistogramEQ(A)
%MakeHistogramEQ takes a grayscale image matrix a and returns a histogram that shows the distribution of 
%intensities in the image.

[r c]=size(A);
n=zeros(256,1);

 if max(max(abs(round(A)-A)))~=0
     str=sprintf('MakeHistogramEQ: The elements of the input matrix must be integers - returning zero vector.');
     disp(str);
     return;
 end
 
 if max(max(A<0))==1 || max(max(A>255))==1
     str=sprintf('MakeHistogramEQ: The elements of the input matrix must be nonnegative integers less than 256 - returning zero vector.');
     disp(str);
     return;
 end

A=reshape(A,1,r*c);
lvl=unique(A);
cnt=histc(A,lvl);

for k=1:length(lvl)
    n(lvl(k)+1)=cnt(k);
end