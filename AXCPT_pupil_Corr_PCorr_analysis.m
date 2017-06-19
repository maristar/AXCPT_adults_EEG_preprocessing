%% Writen by Maria Stavrinou, 29.3.2016 for analysis of EEG_pupil data. 
% Data will be an array containing one channel of pupillometry and one
% channel of EEG - or more
%
% p=model_order_maria(data, 1, 20); % function model order -- to see what order is good. 
% Steps as for today 4.5.2016
% Step 1: loading the data from pupil 
% Step 2: loading the data from EEG for the same subject
% Step 3: unifying As=Ax+Ay and Bs=Bx+By
% Step4: resampling the pupil data 
% Step 5: Cutting the first 200 ms from pupil data
     %    close (2:28);
mSubj03=mean(Subj03,3);

        num_epochs=size(data,3);
        result1=zeros(nchan, nchan, num_epochs);
        result2=zeros(nchan, nchan, num_epochs);
        for k=1:num_epochs
            tempiii=data(1:nchan,:,k)'; %% it wants first the data points, then the number of channels
            result1(:,:,k)=corrcoef(tempiii);
            result2(:,:,k)= partialcorr(tempiii);% partialcorr corrcoef  corrcoef
            %a=squeeze(result1(:,:,k));
%       2-d PLOTS     
%     figure; imagesc(a); set(gca,'Ytick', 1:8); set(gca, 'XTick', 1:8); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
%     axis xy; axis tight; colorbar('location','EastOutside')
    clear tempiii a 
        end
    clear k  tempii

% set diagonal elements to zero
    for k=1:num_epochs;
        for jj=1:nchan;
            result1(jj,jj)=0;
            result2(jj,jj)=0;
        end
    end
    clear jj k a 
    thismoment=resultscor.now;
    textmeasure1='Correlation'; %% NEW
    textmeasure2='Partial Correlation';
    direct_temp1=[thismoment '-' textmeasure1];
    direct_temp2=[thismoment '-' textmeasure2];
    mkdir(direct_temp1);
    mkdir(direct_temp2);
%% partial correlation
    cd(direct_temp2)
    pcor_average=mean(result2(:,:,1:end),3);
% matrix plot
    figure;imagesc(pcor_average);
    set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
    set(gca, 'YTickLabel', N); set(gca, 'XTickLabel', N);
    axis xy; axis tight; colorbar('location','EastOutside')
    title([name(1:end-4) '-' textmeasure2 ': ' 'average']);
    figure_temp=[textmeasure2 '- ' 'average' name(1:end-4)]; saveas(gcf, figure_temp, 'fig')
% lines plot
    plot2dhead_frontal(pcor_average, XYZ, N); title([name(1:end-4) '-' textmeasure2 ': average' ]);
    figure_temp=['Lines-' textmeasure2 '- ' 'average' name(1:end-4)]; 
    saveas(gcf, figure_temp, 'fig')
%list of most strong couples
    [pcor_list]=majorlist(pcor_average, textmeasure2, now, name, nchan, N, crank)
% list of 26 channels with connectivity strength and appearance
    [chan_strength_norm, chan_appearance_norm]=strength_appearance(pcor_list.couple_conn, pcor_list.couple_conn_values,N, crank);
% input start
br_areas=brainar(chan_strength_norm, chan_appearance_norm);
% Send the results to excel file 
    stempp=['MostCouples-' textmeasure2 '-stats']; % do not delete this!!!!
    xlswrite(stempp, {name}, 'Sheet1', 'A1:A1');
    titles={name};
    xlswrite(stempp, (titles), 'Sheet1', 'A2:A2');
    xlswrite(stempp,N, 'Sheet1', 'B2');
    xlswrite(stempp, {'strength'}, 'Sheet1', 'A3:A3');
    xlswrite(stempp,chan_strength_norm, 'Sheet1', 'B3');
    xlswrite(stempp, {'appearance'}, 'Sheet1', 'A4:A4');
    xlswrite(stempp,chan_appearance_norm, 'Sheet1', 'B4');
    % brain areas
%     xlswrite(stempp, {'brain areas results'}, 'Sheet1', 'A5:A5');
%     xlswrite(stempp,br_areas, 'Sheet1', 'B5');
    %
   
    
    textmeasure='pcor';
% save to results.. \ 
    resultscor.data=data;
    resultscor.(textmeasure).chan_strength_norm=chan_strength_norm;
    resultscor.(textmeasure).chan_appearance=chan_appearance_norm;
    resultscor.(textmeasure).result2=result2;
    resultscor.(textmeasure).couples=pcor_list;
    resultscor.(textmeasure).br_areas=br_areas;
   
    clear chan_appearance_norm chan_strength_norm
    clear br_areas figure_temp direct_temp2 textmeasure2 pcor_average title                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    cd ..
%% correlation
    cd(direct_temp1)
    cor_average=mean(result1(:,:,1:end),3);
    % matrix plot
    figure;imagesc(cor_average);
    set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
    set(gca, 'YTickLabel', N); set(gca, 'XTickLabel', N);
    axis xy; axis tight; colorbar('location','EastOutside')
    title([name(1:end-4) '-' textmeasure1 ': ' 'average']);
    figure_temp=[textmeasure1 '- ' 'average' name(1:end-4)]; saveas(gcf, figure_temp, 'fig')
    clear figure_temp
    % lines plot
    plot2dhead_frontal(cor_average, XYZ, N); title([name '-' textmeasure1 ': ''average']);
    figure_temp=['Lines-' textmeasure1 '- ' 'average' name(1:end-4)]; 
    saveas(gcf, figure_temp, 'fig')
    clear figure_temp
    [cor_list]=majorlist(cor_average, textmeasure1, now, name, nchan, N, crank)
    [chan_strength_norm, chan_appearance_norm]=strength_appearance(cor_list.couple_conn, cor_list.couple_conn_values,N,crank);
% inpout start
br_areas=brainar(chan_strength_norm, chan_appearance_norm);
% Send the results to excel file 
    stempp=['MostCouples-' textmeasure1 '-stats']; % do not delete this!!!!
    xlswrite(stempp, {name}, 'Sheet1', 'A1:A1');
    titles={name};
    xlswrite(stempp, (titles), 'Sheet1', 'A2:A2');
    xlswrite(stempp,N, 'Sheet1', 'B2');
    xlswrite(stempp, {'strength'}, 'Sheet1', 'A3:A3');
    xlswrite(stempp,chan_strength_norm, 'Sheet1', 'B3');
    xlswrite(stempp, {'appearance'}, 'Sheet1', 'A4:A4');
    xlswrite(stempp,chan_appearance_norm, 'Sheet1', 'B4');
    textmeasure='cor'
% save to results.. \ 
    resultscor.(textmeasure).chan_strength_norm=chan_strength_norm;
    resultscor.(textmeasure).chan_appearance=chan_appearance_norm;
    resultscor.(textmeasure).result1=result1;
    resultscor.(textmeasure).couples=cor_list;
    resultscor.(textmeasure).br_areas=br_areas;
    clear chan_appearance_norm chan_strength_norm
    clear figure_temp br_areas textmeasure cor_average cor_list                   

    clear textmeasure1 textmeasure2 tempiii direct_temp1 direct_temp2 fff
    cd ..