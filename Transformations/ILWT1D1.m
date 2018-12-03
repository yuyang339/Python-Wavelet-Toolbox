function y = ILWT1D1(v,varargin)
%ILWT1D1 takes as input a vector of even length and returns one iteration of
%the discrete inverse LeGall wavelet transformation.  Arguments can also be added
%to instruct ILWT1D1 to return integers.  In this case, the call is
%LWT1D1(v,'IntegerMap','True').

N=length(v);
if mod(N,2)==1
    str=sprintf('LWT1D1: The length of the input vector must be even. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

if size(v)==[N,1]
        v=v';
end

if length(varargin)==2 && isequal(varargin{1},'IntegerMap')
    integerTF=varargin{2};
else
    integerTF='False';
end



%Partition v into s and d:
s=v(1:N/2);
d=v(N/2+1:end);

%Repeat the first value of d:
d=[d(1) d];

%Build o:

if isequal(integerTF,'True')
    for k=1:N/2
        o(k) = s(k)-floor((d(k+1)+d(k))/4+1/2);
    end
else
    for k=1:N/2
        o(k) = s(k)-(d(k+1)+d(k))/4;
    end
end

%Append the last element of o to o:
o=[o o(end)];

%Drop the first element of d:
d=d(2:end);

%Now compute e:
if isequal(integerTF,'True')
    for k=1:N/2
        e(k)=d(k)+floor((o(k)+o(k+1))/2);
    end
else
    for k=1:N/2
        e(k)=d(k)+(o(k)+o(k+1))/2;
    end
end

%Dump the extra o(N/2):
o=o(1:N/2);

y=reshape([o; e],1,N)';
return;