function createfigure(X1, YMatrix1)
%CREATEFIGURE(X1, YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 20-May-2016 19:00:18

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,...
    'XTickLabel',{'-100','0','100','200','300','400','500'},...
    'FontSize',24);
box(axes1,'on');
hold(axes1,'on');

% Create title
title('Cz','FontSize',26.4);

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'LineWidth',4,'Parent',axes1);
set(plot1(1),'DisplayName','AX','Color',[1 0 0]);
set(plot1(2),'DisplayName','AY','Color',[0 0 1]);
set(plot1(3),'DisplayName','BX',...
    'Color',[1 0.600000023841858 0.200000002980232]);
set(plot1(4),'DisplayName','BY',...
    'Color',[0.466666668653488 0.674509823322296 0.18823529779911]);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.15779690782563 0.559999364723475 0.0621980042016808 0.263272058823529]);

