function DRdata = insertLegendDR(DRdata)

% Check if any legends are numerical
nGrps = length(DRdata.PCplot.legids); 
for i = 1:nGrps
    if isnumeric(DRdata.PCplot.legids{i})
        DRdata.PCplot.legids{i} = num2str(DRdata.PCplot.legids{i});
    end
end

DRdata.PCplot.h.legend = legend(DRdata.PCplot.h.scoresForLeg ,DRdata.PCplot.legids );
set(DRdata.PCplot.h.legend,'FontSize',DRdata.fontsize.axis+4);
legOutPos    = get(DRdata.PCplot.h.legend,'Position');
PCplotOutPos = get(DRdata.subplot.h(1),'Position');
legOutPos(1) = PCplotOutPos(1);
legOutPos(2) = max(PCplotOutPos(2)-2*legOutPos(4),0);
ImPlotPos    = get(DRdata.subplot.h(3),'Position');
if legOutPos(1) + legOutPos(3) > ImPlotPos(1)
    legOutPos(1) = ImPlotPos(1) - legOutPos(3)-0.01;
    if legOutPos(1)<0.01
        legOutPos(1) = 0.01;
    end    
end
set(DRdata.PCplot.h.legend,'Position',legOutPos);
DRdata.PCplot.h.legobj = get(DRdata.PCplot.h.legend,'Children');
%set(DRdata.PCplot.h.legobj(1:3:end),'MarkerSize',DRdata.PCplot.marker.size);   
