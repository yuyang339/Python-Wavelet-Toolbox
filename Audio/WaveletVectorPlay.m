function []=WaveletVectorPlay(v,its,varargin)
%WaveletVectorPlay takes a vector v (presumably the wavelet transformation of an audio clip) 
%and a number of iterations its and plays selected portions of the clip.
%There are three variable arguments that allow the user some flexibility
%with the sound output:
%
%'Region' can be set to 'All' (default), 'LowPass', or 'HighPass'.  In this case,
%the routine looks for the value of Iteration (see below) and then plays
%the selected portion of v.
%
%'Iteration' can be set to All (default) or any positive integer 1,2,...,its.
%This value is used if Region has been set to HighPass and ignored
%otherwise.
%
%'SampleRate' is a positive integer that indicates the number of samples per
%second of the audio clip from which wt was obtained.  The default is
%11025.  The lowpass portion of the transform is played at sample rate
%SampleRate/2^its while high pass portion, iteration k, is played at
%SampleRate/2^k.
%
%Sample Calls:
%
%WaveletVectorPlay(wt,3) - plays all iterations of wt, one at a time, assuming that wt 
%was obtained from an audio clip whose sample rate is 11025.
%
%WaveletVectorPlay(wt,3,'SampleRate',7418) - plays all iterations of wt,
%one at a time, assuming that wt was obtained from an audio clip whose 
%sample rate is 7418.
%
%WaveletVectorPlay(wt,3,'Region','HighPass','Iteration',2,'SampleRate',7418) -
%plays the second highpass portion of wt,assuming that wt was obtained 
%from an audio clip whose sample rate is 7418. 
%

if ~isvector(v)
    str=sprintf('WaveletVectorPlay: The first input must be a vector.');
    disp(str);
    return;
end

if its<=0 || round(its)-its~=0
    str=sprintf('WaveletVectorPlay: The number of iterations must be a nonnegative integer.');
    disp(str);
    return;
end

N=length(v);
maxits=MaxIterations(N);

if its>maxits
    str=sprintf('WaveletVectorPlay: The number of iterations cannot exceed %i.',maxits);
    disp(str);
    return;
end

opts={'Region','Iteration','SampleRate'};
vals={'All','All',11025};

len=length(varargin);
if mod(len,2)~=0
    len=len-1;
end

nms=cell(len);

for k=1:len/2
    nms{k}=varargin{2*k-1};
end

for k=1:len/2
    t=ismember(opts,nms{k});
    [dum,idx]=max(t);
    if dum~=0
        vals{idx}=varargin{2*k};
    end
end

if max(ismember({'LowPass','HighPass'},vals{1}))==0
    vals{1}='All';
end

if isnumeric(vals{2})~=1
    vals{2}=1;
end

if vals{2}<=0 || vals{2}>its
    vals{2}=1;
end

if vals{3}<=0
    str=sprintf('WaveletVectorPlay: The SampleRate must be a positive number.');
    disp(str);
    return;
end

srlist=fliplr(round(vals{3}*2.^-linspace(its,1,its)));
wtlist=WaveletVectorToList(v,its);
if max(ismember({'HighPass','LowPass'},vals{1}))%If asked for a particular region, play it.
    switch vals{1}
        case 'LowPass'
            y=wtlist(1).lp;
            srate=srlist(its);
            str=sprintf('\nPlaying the low pass portion of the clip.\n');
        case 'HighPass'
            y=wtlist(vals{2}+1).hp;
            srate=srlist(vals{2});
            str=sprintf('\nPlaying the high pass portion, iteration %i, of the clip.\n',vals{2});
    end
    disp(str);
    soundsc(y,srate);
else %play all iterations
    str=sprintf('\nPlaying the low pass portion of the clip.\n');
    disp(str);
    srate=srlist(its);
    soundsc(wtlist(1).lp,srate);
    cont=sprintf('\nHit any key to continue...');
    disp(cont);
    pause;
    for k=1:its
        str=sprintf('\nPlaying the high pass portion, iteration %i, of the clip.\n',k);
        disp(str);
        srate=srlist(vals{2})+1;
        soundsc(wtlist(k).hp,srate);
        if k~=its
            disp(cont);
            pause;
        end
    end
end
