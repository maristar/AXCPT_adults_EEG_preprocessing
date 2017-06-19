function [ power ] = make_the_fft( fs, single_trial)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Power spectrum estimation 
        mean_single_trial=mean(single_trial);
        buffer=(single_trial-mean_single_trial)/std(single_trial);
        % buffer is 3584 x 1
        Fs_buffer=fs;
        NN=length(single_trial);
        % calculate length of window
               
        p2=nextpow2(NN); % calculate length of window
        
        NFFT=2^p2;
        % We need to inverse the buffer to work this concatenation
        xnew=[buffer' zeros(1,NFFT-length(buffer))];
        buffer=xnew; 
        clear xnew;
        F = fs/2*linspace(0,1,NFFT/2);%rv(2*j),i); dati(1:131073,i);
        NN=[];
        NN =length(buffer);
        X=fft(buffer, NFFT);
        figure;plot(F,2*abs(X(1:NFFT/2))) 
        saveas(gcf, 'FFT','fig')
        
        P=(2*abs(X(1:NFFT/2)))*(NFFT/2);
        hpsd=dspdata.psd(P, 'Fs', fs);
        
        Fw = hpsd.Frequencies;                 
        power=avgpower(hpsd)/(fs); 
        figure(23); plot(hpsd); title([' Total Power ' name]) 
        saveas(gcf, 'PSD','fig'); 
        Parsevalaki=(sum(buffer.^2))/(length(buffer)*fs); % From Parseval 
  

end

