function B=MakeWaveletPlotChannel(A,its,v2,v3,v4,v5)
%Testing 1,2,3

[r c]=size(A);
B=A(1:r/2^(v2-1),1:c/2^(v2-1)); %Chop down the matrix based on 'Iteration' value
v5=v5(v2:end); %Reset the 'DivideLinesThickness' vector

its=its+1-v2;

wtlist=WaveletMatrixToList(B,its);
wtlist(1).lp=LinMap(wtlist(1).lp,0,255);
for j=1:its
    for k=1:3
        wtlist(j,k).hp=LinMap(abs(wtlist(j,k).hp),0,255);
    end
end
B=WaveletListToMatrix(wtlist,its);

if isequal(v3,'True') %divide lines requested
    p=255*v4(1);
    [r c]=size(B);
    for i=0:v5(1)-1
        B(:,1+i)=p*ones(1,r);
        B(:,c-i)=p*ones(1,r);
        B(1+i,:)=p*ones(c,1);
        B(r-i,:)=p*ones(c,1);
    end
    for k=1:its
        for i=0:v5(k)-1
            B(r/2^k+i,1:c/2^(k-1))=p.*ones(c/2^(k-1),1);
            B(1:r/2^(k-1),c/2^k+i)=p.*ones(1,r/2^(k-1));
        end
    end
end


