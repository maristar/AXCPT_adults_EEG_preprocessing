function [ powerHF_all, meanPowerHF, minPowerHF ] = define_threshold_muscle(data_channel, single_trial_numbers, fs, time3_index)
% Defines the power in the single trials with muscle artifacts
%   This function takes an array with single trial numbers that contain
%   information on which trials have muscle artifacts inside and gives as
%   an output the power of their fft, the mean of those signle trials and
%   their minimum value. It works for one channel
% Input arguments 
%    data_channel: one channel, double precision
%   fs: the sampling frequency
%   single_trial_numbers: the single trial indexes that contain muscle
%       activity
%   time3_index: indexes of timeVec in which to look for muscle artifacts
% Output arguments
%     powerHF_all: an array containing the power in HF for all the signle
%                   trial that were observed to have muscle artifacts
%     meanPowerHF: the average Power in the HF band for all those signle trials

%     minPowerHF: the minimum value of those powers in HF, it will be used
%     as a threshold. 
%     Maria L. Stavrinou 

    for jk=1:length(single_trial_numbers)
        single_trial_index=single_trial_numbers(jk);
        single_trial=data_channel(:,single_trial_index); % 3584 x 1
        [power, Parsevalaki, powerbandHF, powerbandTotal] = make_the_welch_fft(fs, single_trial);
        powerHF_all(jk, :)=powerbandHF;
        clear power Parsevalaki powerbandHF powerbandTotal
    end
    meanPowerHF=mean(powerHF_all, 1);
    minPowerHF=min(powerHF_all);
end

