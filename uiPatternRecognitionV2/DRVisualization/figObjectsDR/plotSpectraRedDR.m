function DRdata = plotSpectraRedDR(DRdata,xlims, ylims)
%% plotSpectraRedDR creates a lineplot object of spectra of biological
%%                  samples
%                  Input: DRdata - data of dimension reduction objects
%                         values - loadings or explained variable variances
%                         if showVarExpByPCs = 0, then loadings are visualized
%                         xlims  - limits of x axes
%                         ylims  - limits of y axes
%% Author: Kirill Veselkov, Imperial College London, 2011

%% re-define the axis limits
set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(2)); cla reset;
%Pos = get(DRdata.subplot.h(2),'Position');
delete(get(DRdata.subplot.h(2),'Children'));
%set(DRdata.subplot.h(2),'Position',Pos);

if nargin<2
    xlims = [];
end
if nargin<3
    ylims = [];
end
[xlims,ylims]      = getSpAxisLimitsDR(DRdata,xlims,ylims);

nGroups  = length(DRdata.groupIds);
mMColors = length(DRdata.marker.color);
if mMColors<nGroups
    iMColor = [0 1:nGroups-nMTypes];
else
    iMColor  = zeros(1,nGroups);
end


%% Case 1: No samples selected. If resolution is large, plot binned dataset
hold on;
redRatio = DRdata.redRatio;
if ~isempty(DRdata.PCplot.spIndcs)
    groups    = DRdata.groups(DRdata.PCplot.spIndcs);
    Sp        = DRdata.Sp(DRdata.PCplot.spIndcs,:);
else
    groups    = DRdata.groups;
    Sp        = DRdata.Sp;
end

DRdata.h.spectra = zeros(1,size(Sp,1));
for iGrp = 1:nGroups
    iGrpIndcs = (groups == iGrp);
    DRdata.h.spectra(iGrpIndcs) = line(single(xlims(1):redRatio:xlims(2)),...
        single(Sp(iGrpIndcs,xlims(1):redRatio:xlims(2))), ...
        'Color', DRdata.marker.color{iGrp-iMColor(iGrp)},...
        'LineWidth',DRdata.SPplot.linewidth);
end

%end
hold off;

%% Case 2:  Selected samples. 
selsamples = getSelectedSpectra(DRdata);
if ~isempty(selsamples)
    sampleindcs             = 1:length(DRdata.h.spectra);
    sampleindcs(selsamples) = [];
    
    if ~isempty(DRdata.marker.selcolor)
        set(DRdata.h.spectra(sampleindcs),'Color', DRdata.PCplot.marker.selcolor);
        legend(DRdata.h.spectra(sampleindcs(1)),'Non Selected Samples',...
            'FontSize',DRdata.fontsize.axislabel,'Location','NorthWest', 'Box', 'off');
        legend boxoff
    end
    set(DRdata.h.spectra(selsamples),'LineWidth',...
        DRdata.SPplot.linewidth+DRdata.SPplot.zoomLinewidthIncrease);
else 
    legend off
end
%if ~isempty(DRdata.test)
%    plotTestSpecrumDR(DRdata,0,1,xlims);
%end
if strcmp(get(DRdata.h.showLoadingPlot,'State'),'on')
    set(DRdata.subplot.h(2),'YAxisLocation','Left');
    set(DRdata.subplot.h(2),'XAxisLocation','Top');
end
ylim(ylims); xlim(xlims);
DRdata = getAxisTickMarksDR(DRdata);
DRdata.h.PCregions = drawRectangleDR(DRdata);
return;