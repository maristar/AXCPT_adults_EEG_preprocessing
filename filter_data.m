function data=filter_data(data,from,to,fs)
% Lauras implementation of the eeglab filter
% eg from=5; to=45
%fs=1000;
[xr,xc]=size(data);
nrchan=min(xr,xc);
t=1:length(data(1,:))';
% figure;subplot(1,2,1);
% plot(data);axis tight;
% [p,f]=pwelch(data(1,:),[],[],[],fs);
% subplot(1,2,2);hold on;plot(f,10*log10(p))
% axis tight


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% band pass filtering data in 5 -45
for k=1:nrchan
    data(k,:) = eegfiltfft(data(k,:), fs, from, to);
end

end

