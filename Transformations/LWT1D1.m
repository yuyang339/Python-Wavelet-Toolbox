function y = LWT1D1(v,varargin)
%LWT1D1 takes as input a vector of even length and returns one iteration of
%the discrete LeGall wavelet transformation.  Arguments can also be added
%to instruct LWT1D1 to return integers.  In this case, the call is
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



%Partition v into even and odd vectors:
e=v(2:2:end);
o=v(1:2:end);

%Repeat the last value of o:
o=[o o(end)];

%Build d

if isequal(integerTF,'True')
    for k=1:N/2
        d(k) = e(k)-floor((o(k)+o(k+1))/2);
    end
else
    for k=1:N/2
        d(k) = e(k)-(o(k)+o(k+1))/2;
    end
end

%Prepend the first element of d to d:
d=[d(1) d];

%Now lift s from d:
if isequal(integerTF,'True')
    for k=1:N/2
        s(k)=o(k)+floor((d(k+1)+d(k))/4+1/2);
    end
else
    for k=1:N/2
        s(k)=o(k)+(d(k+1)+d(k))/4;
    end
end

%Dump the extra d(1):
y=[s d(2:end)]';
return;