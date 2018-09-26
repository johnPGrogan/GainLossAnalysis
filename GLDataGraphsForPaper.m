function GLDataGraphsForPaper()
% GLDataGraphsForPaper()
% Draw figures from paper, and summary statistics table
% Loads GLDataAnalysis.mat

    close all

    load('GLDataAnalysis.mat')
    %%
    sqrtNPps = sqrt(sum(drug));
    symVals = {'-80%','-20%','0%','0%','20%','80%'};
    set(0,'DefaultAxesFontSize',16)
    xAx = 6:-1:1;%vector to l/r swap np figs
    
    %% acc figure

    accMeans = [nanmean(lAcc(drug)),nanmean(lAcc(placebo));...
        nanmean(t0Acc(drug)),nanmean(t0Acc(placebo));...
        nanmean(t30Acc(drug)),nanmean(t30Acc(placebo));...
        nanmean(t24Acc(drug)),nanmean(t24Acc(placebo));];
    accSEM = [SEM(nPps,condSep(lAcc,drug,placebo)).*1.996;...
        SEM(nPps,condSep(t0Acc,drug,placebo)).*1.996;...
        SEM(nPps,condSep(t30Acc,drug,placebo)).*1.996;...
        SEM(nPps,condSep(t24Acc,drug,placebo)).*1.996;];

    figure(1)
    set(gca,'ColorOrder',[0 0 1; 1 0 0],'NextPlot','replacechildren')
    errorbar(accMeans,accSEM,'LineWidth',2.5)
    hold on
    plot(repmat(3.7,1,101),0:100,':k')

    box off
    xlabel('Task')
    ylabel('% Accuracy')
    set(gca,'XTick',1:4,'XTickLabel',{'Learning','0 mins','30 mins','24 hours'});
    axis([0.5 4.5 40 80])
    legend({'drug','placebo','drug administered'},'Location','SouthEast')

    % saveas(figure(1),'.\Figures\GLAcc.jpg')


    %% 24hr NP by cond
    figure(2)

    t24ChooseDrug = t24Choose(:,drug);
    t24ChoosePlacebo = t24Choose(:,placebo);
    t24ChooseByCondMeans = [nanmean(t24ChooseDrug,2),nanmean(t24ChoosePlacebo,2)];
    t24ChooseByCondSEM = [nanstd(t24ChooseDrug,[],2)./sqrtNPps, nanstd(t24ChoosePlacebo,[],2)./sqrtNPps].*1.996;

    set(gca,'ColorOrder',[0 0 1; 1 0 0],'NextPlot','replacechildren')
    errorbar(repmat(xAx',1,2),t24ChooseByCondMeans,t24ChooseByCondSEM,'-^','LineWidth',2.5)
    box off
    axis([0.5 6.5 0 100])
    set(gca,'XTick',1:6,'XTickLabel',symVals)
    xlabel('card selected')
    ylabel('% selections')
    legend('drug','placebo','Location','Best')

    % saveas(figure(1),'.\Figures\GLNP24ByCond.jpg')

    %% now draw individual data version of those figures
    figure(3)

    accDiffs = [lAccDiff;t0AccDiff;t30AccDiff;t24AccDiff];

    plot(accDiffs,'-xk')
    axis([0.5 4.5 -70 70])
    box off
    ylabel('drug - placebo % accuracy')
    xlabel('task')
    set(gca,'XTick',1:4,'XTickLabel',{'Learning','0 mins','30 mins','24 hours'})
    % saveas(figure(1),'.\Figures\GLChooseIndividual.jpg')



    %% choose diff - reverse order of symbols from low to high
    figure(4)

    boxplot(t24ChooseDiff(6:-1:1,:)','colors',[0 0 0])
    hold on
    for i = 1:6
        xVec = (7-i) + .2*rand(1,nPps)-.1;
        plot(xVec,t24ChooseDiff(i,:),'xk')
    end
    axis([0.5 6.5 -100 100])
    box off
    ylabel('drug - placebo % selections')
    xlabel('card selected')
    set(gca,'XTick',1:6,'XTickLabel',{'-80%','-20%','0%','0%','20%','80%'})

    % saveas(figure(1),'.\Figures\GLChooseDiffIndividual.jpg')
    % clf

    %% now make table of summary stats

    drugVars = [lAcc(drug);t0Acc(drug);t30Acc(drug);t24Acc(drug);t24Choose(:,drug)];
    placeboVars = [lAcc(placebo);t0Acc(placebo);t30Acc(placebo);t24Acc(placebo);t24Choose(:,placebo)];

    sumStats = [sum(~isnan(drugVars),2),nanmean(drugVars,2),nanstd(drugVars,[],2),...
        sum(~isnan(placeboVars),2),nanmean(placeboVars,2),nanstd(placeboVars,[],2)];

    sumStats = array2table(sumStats);
    sumStats.Properties.VariableNames = {'drugN';'drugMean';'drugSD';'placeboN';'placeboMean';'placeboSD'};
    sumStats.Properties.RowNames = {'learnAcc';'t0Acc';'t30Acc';'t24Acc';...
        't24ChooseA';'t24ChooseB';'t24ChooseC';'t24ChooseD';'t24ChooseE';'t24ChooseF';};
    
    writetable(sumStats,'summaryStatistics.txt')
end