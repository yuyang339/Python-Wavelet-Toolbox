function y=NoiseEstimate(v,h)
%NoiseEstimate takes a vector or matrix and an orthogonal filter and 
%returns an estimate of the noise present.

if ~isvector(h)
    str='NoiseEstimate: The input filter must be a row vector or a column vector - returning 0';
    disp(str);
    y=0;
    return;
end

if mod(length(h),2)~=0
    str='NoiseEstimate: The input filter length must be an even integer - returning 0.';
    disp(str);
    y=0;
    return;
end


if isvector(v)
    wt=WT1D1(v,h);
    wtlist=WaveletVectorToList(wt,1);
    hp=wtlist(1).hp;
else
    [r c]=size(v);
    n=r*c/4;
    wt=WT2D1(v,h);
    wtlist=WaveletMatrixToList(wt,1);
    hpv=reshape(wtlist(1,1).hp,1,n);
    hph=reshape(wtlist(1,2).hp,1,n);
    hpd=reshape(wtlist(1,3).hp,1,n);
    hp=[hpv hph hpd];
end
y=MAD(hp)/.6745;