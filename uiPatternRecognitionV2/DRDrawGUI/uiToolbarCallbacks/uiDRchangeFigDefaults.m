function DRdata = uiDRchangeFigDefaults(hMainFigDR,eventdata)
%% uiDRchangeFigDefaults chages properties of DR toolbox objects
%   Input: hMainFigDR - figure handle
%          DRdata     - properties and parameter values
%                       of dimension reduction toolbox objects
%% Author: Kirill A. Veselkov, Imperial College 2011.

if ishandle(hMainFigDR)
    DRdata = guidata(hMainFigDR);
else
    DRdata = hMainFigDR;
end

%% Get marker data
nGrps = length(DRdata.groupIds);
Data = [];
for iGrp = 1:nGrps
    temp = {DRdata.groupIds{iGrp}, removeSpaces(num2str(DRdata.marker.color{iGrp})),...
        logical(DRdata.PCplot.marker.fill{iGrp}),DRdata.PCplot.marker.type{iGrp},num2str(DRdata.groupOrder(iGrp))};
    Data = [Data; temp];
end
pstns      = get(DRdata.subplot.h(4),'Position');

%% Setup group names, colors and markers
columnname      = {'Group Name', 'Marker Color', 'Marker Fill', 'Marker Type','Group order'};
columnformat    = {'char', 'char', 'logical', 'char','char'};
columneditable  = [true true true true true];
DRdata.h.Def.Table1         = uitable('Units','normalized','Position',[0 0 0.001 0.001],...
    'Data', Data,'ColumnName', columnname,'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,'RowName',[],'Tag','MarkerSettings',...
    'CellEditCallback',@defTableEditCallBackDR);
% Adjust positions
table1Pstns        = get(DRdata.h.Def.Table1,'Extent');   % Required uitable size
if (pstns(3)-table1Pstns(3))/pstns(3)<0.5; % Check whether a table occupies the half width of the figure
    table1Pstns(3) = pstns(3)./2 -0.05*pstns(3);
end
%if (pstns(4)-table1Pstns(4))/pstns(4)<0.2; % Check whether a table occupies the 0.8 height of the figure
    table1Pstns(4) = 0.8*pstns(4);
%end
table1Pstns(1) = pstns(1);
table1Pstns(2) = pstns(2)+pstns(4)-table1Pstns(4);
set(DRdata.h.Def.Table1,'Position',table1Pstns);

%% Setup group names, colors and markers
columnname      = {'Decsription of parameter  ','Value'};
columnformat    = {'char', 'char'};
columneditable  = [false true];
Data            = {'Color of non-selected samples', 'Spectrum line width', ...
    'line width adjustment', 'Font size: sample identifiers',...
    '                 axis','                 axis labels', '                 axis title',...
    'Marker: line width','             size','             size adjustement',...
    'Region color for PCA','Renderer','Peak Picked Data','xlabel', 'reverse','max number of displayed spectra',...
    'min number of displayed spectra per group';...
    removeSpaces(num2str(DRdata.PCplot.marker.selcolor)),...
    num2str(DRdata.SPplot.linewidth),...
    num2str(DRdata.SPplot.linewitdthIncrease),...
    num2str(DRdata.fontsize.sampleIds), num2str(DRdata.fontsize.axis),...
    num2str(DRdata.fontsize.axislabel),num2str(DRdata.fontsize.title),...
    num2str(DRdata.PCplot.marker.linewidth),num2str(DRdata.PCplot.marker.size),...
    num2str(DRdata.PCplot.marker.zoomMarSizeIncrease),...
    removeSpaces(num2str(DRdata.SPplot.regions.color)),DRdata.renderer,...
    num2str(DRdata.peakPickedData),DRdata.SPplot.xlabel,DRdata.SPplot.xreverse,...
    DRdata.PCplot.maxNumPoints,DRdata.PCplot.minNumClassPoints};

DRdata.h.Def.Table2         = uitable('Units','normalized','Position',[0 0 0.001 0.001],...
    'Data', Data','ColumnName', columnname,'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,'RowName',[],'Tag','ImageSettings',...
    'CellEditCallback',@defTableEditCallBackDR);
table2Pstns = get(DRdata.h.Def.Table2,'Extent');   % Required uitable size
horspace    = pstns(3) - table1Pstns(3);
if horspace<table2Pstns(3);                          % the table width
    table2Pstns(3) = horspace;
end
if (pstns(4)-table2Pstns(4))/pstns(4)<0.2; % Check whether a table occupies the 0.8 height of the figure
    table2Pstns(4) = 0.8*pstns(4);
end
table2Pstns(1) = pstns(1)+table1Pstns(3);
table2Pstns(2) = pstns(2)+pstns(4)-table2Pstns(4);
set(DRdata.h.Def.Table2,'Position',table2Pstns);

%% Setup "OK" and "Make as defaults" push buttons
PB1Pstns    = table2Pstns;
PB1Pstns(3) = table2Pstns(3)./2;
PB1Pstns(4) = table2Pstns(4)./5;
PB1Pstns(2) = table2Pstns(2)-PB1Pstns(4);
DRdata.h.Def.PB1 = uicontrol(gcf,'Style','PushButton','Units','normalized',...
    'String','Make as defaults','Tag','Make as defaults','Position',...
    PB1Pstns,'Callback',@defTableEditCallBackDR);
PB2Pstns    = PB1Pstns;
PB2Pstns(1) = PB1Pstns(1)+PB1Pstns(3);
DRdata.h.Def.PB2 = uicontrol(gcf,'Style','PushButton','Units','normalized',...
    'String','OK','Position',PB2Pstns,'Tag','OK','Callback',...
    @defTableEditCallBackDR);
if ishandle(hMainFigDR)
    guidata(hMainFigDR,DRdata);
end
return;

function pattern = removeSpaces(pattern)
spaceIndcs = find(pattern==' ');
diffSIndcs = diff(spaceIndcs);
index      = find(diffSIndcs>1)+1;
indices    = [];
if length(spaceIndcs(1)+1:spaceIndcs(index-1))>1;
    indices = spaceIndcs(1)+1:spaceIndcs(index-1);
end
if length(spaceIndcs(index)+1:spaceIndcs(end))>1;
    indices = [indices spaceIndcs(index)+1:spaceIndcs(end)];
end
pattern(indices)=[];