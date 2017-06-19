function [ power, Parsevalaki, powerbandHF, powerbandTotal ] = make_the_welch_fft( fs, single_trial)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Power spectrum estimation 
        mean_single_trial=mean(single_trial);
        buffer=(single_trial-mean_single_trial)/std(single_trial);
        % buffer is 3584 x 1
        Fs_buffer=fs;
        NN=length(single_trial);
        % calculate length of window
        
        
        % Power spectrum estimation by Welch
        % calculate length of window
        					
        
        p2=nextpow2(NN)-1; % calculate length of window
        
        NFFT=2^p2;
        x=buffer;
        F = fs/2*linspace(0,1,length(x)/2);
        %meanINTRR=mean(interpolation);
         %X  = fft(buffer);
         window=256;
         noverlap=window-1;
         h=spectrum.welch('Hann', window, 100*noverlap/window);
%          hopts=psdopts(h,buffer);
%          set(hopts, 'Fs', Fsnew, 'SpectrumType', 'twosided', 'centerdc', true)
%          msspectrum(h,buffer,hopts)
        %hpsd=psd(h,buffer, hopts);
        hpsd = psd(h,x,'NFFT',NFFT,'Fs',fs);
%         figure; plot(hpsd); 
%         xlim([0 fs/2]); 
%         title('Welch Spectrum')
        %saveas(gcf, 'WelchPsd', 'fig')
        power=avgpower(hpsd);
        Parsevalaki=(sum(buffer.^2))/length(buffer); %
  
        %% hIGH frequency hF 45 - 160 Hz
        freqHF=max(find(F<160));
        freqLF=max(find(F<45));
        %freqHF=findHF(end);
        NNHF=length(freqLF:freqHF);
        freqrange=[F(freqLF), F(freqHF)];
        powerbandHF=avgpower(hpsd, freqrange)/(fs);
        %powerbandHF=sum(P(freqLF:freqHF))/NNHF;
        %powerbandHF_psd=sum(psd(freqLF:freqHF));
%         figure; plot(F(freqLF:freqHF),P(freqLF:freqHF,1));%title([' EEG_channel ' s{i}]) %%% (1:469) (1:469)
%         set(gca, 'YLim', ylim);grid on; zoom on;title(['RR Frequency Spectrum' name ]); xlabel('Frequency (Hz)');
        %save powerbandHF powerbandHF

        %% total power HF LF 0 - 0.15 Hz
        freqVLF1=max(find(F<0.003));
        freqtHF=max(find(F<256));
        NNTF=length(freqVLF1:freqtHF);
        %powerbandTotal=sum(P(1:freqHF))/NNTF;
        freqrangeT=[F(freqVLF1) F(freqtHF)];
        powerbandTotal=avgpower(hpsd,freqrangeT)/(fs);
        %save powerbandTotal powerbandTotal
end

