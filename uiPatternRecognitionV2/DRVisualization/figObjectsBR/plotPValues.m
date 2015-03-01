function [hsurf,hCB,YTick,YTickLbls] = plotPValues(x,y,p,pmin,pmax,colorMap,barplot)
%% plotPValues gives a surface plot of covariance values of the data matrix
%% X with the vector of class labels y which are colour-coded by the vector
%% of p-values for pair wise comparative analysis (PWCA)
% Input:  x [1xnVrbls] - a vector of x values
%         y [1xnVrbls] - a vector of y values plot(x,y)
%         p [1xnVrbls] - a vector of p-values
%         pmin         - p minimum value (a scalar) 
%         pmax         - p maximum value (a scalar) 

% Output: hsurf  - surface plot handle
%         hCB    - colobar handle
%         YTick  - colobar Y Ticks
%         YTickLbls  - colobar Y Tick labels
%% Author: Kirill A. Veselkov, Imperial College London, 2010.

if nargin<7
    barplot = 0;
end

p=1-p;

if nargin<4
    pmin = min(p);
end

if nargin<5
    pmax = max(p);
end

if nargin<6
    colorMap = [];
end

if pmin == pmax
    pmin = pmin -10e-5;
    colorMap = [0.0784313753247261,0.168627455830574,0.549019634723663;0.0750213190913200,0.204774081707001,0.568627476692200;0.0716112554073334,0.240920722484589,0.588235318660736;];
elseif isempty(colorMap)
    colorMap = [0.0784313753247261,0.168627455830574,0.549019634723663;0.0750213190913200,0.204774081707001,0.568627476692200;0.0716112554073334,0.240920722484589,0.588235318660736;0.0682011991739273,0.277067363262177,0.607843160629273;0.0647911354899406,0.313213974237442,0.627451002597809;0.0613810755312443,0.349360615015030,0.647058844566345;0.0579710155725479,0.385507255792618,0.666666686534882;0.0545609556138516,0.421653896570206,0.686274528503418;0.0511508956551552,0.457800507545471,0.705882370471954;0.0477408356964588,0.493947148323059,0.725490212440491;0.0443307757377625,0.530093789100647,0.745098054409027;0.0409207157790661,0.566240429878235,0.764705896377564;0.0375106595456600,0.602387070655823,0.784313738346100;0.0341005995869637,0.638533651828766,0.803921580314636;0.0306905377656221,0.674680292606354,0.823529422283173;0.0272804778069258,0.710826933383942,0.843137264251709;0.0238704178482294,0.746973574161530,0.862745106220245;0.0204603578895330,0.783120214939117,0.882352948188782;0.0170502997934818,0.819266855716705,0.901960790157318;0.0136402389034629,0.855413496494293,0.921568632125855;0.0102301789447665,0.891560077667236,0.941176474094391;0.00682011945173144,0.927706718444824,0.960784316062927;0.00341005972586572,0.963853359222412,0.980392158031464;0,1,1;0.0625000000000000,1,0.937500000000000;0.125000000000000,1,0.875000000000000;0.187500000000000,1,0.812500000000000;0.250000000000000,1,0.750000000000000;0.312500000000000,1,0.687500000000000;0.375000000000000,1,0.625000000000000;0.437500000000000,1,0.562500000000000;0.500000000000000,1,0.500000000000000;0.562500000000000,1,0.437500000000000;0.625000000000000,1,0.375000000000000;0.687500000000000,1,0.312500000000000;0.750000000000000,1,0.250000000000000;0.812500000000000,1,0.187500000000000;0.875000000000000,1,0.125000000000000;0.937500000000000,1,0.0625000000000000;1,1,0;1,0.937500000000000,0;1,0.875000000000000,0;1,0.812500000000000,0;1,0.750000000000000,0;1,0.687500000000000,0;1,0.625000000000000,0;1,0.562500000000000,0;1,0.500000000000000,0;1,0.437500000000000,0;1,0.375000000000000,0;1,0.312500000000000,0;1,0.250000000000000,0;1,0.187500000000000,0;1,0.125000000000000,0;1,0.0625000000000000,0;1,0,0;0.980882346630096,0.0200980398803949,0;0.961764693260193,0.0401960797607899,0;0.942647039890289,0.0602941215038300,0;0.923529386520386,0.0803921595215797,0;0.904411792755127,0.100490197539330,0;0.885294139385223,0.120588243007660,0;0.866176486015320,0.140686273574829,0;0.847058832645416,0.160784319043159,0;];
end

if barplot == 0
    hsurf = surface('XData',[x(:) x(:)],'YData',[y(:) y(:)],...
        'ZData',zeros(length(x(:)),2),'CData',[p(:) p(:)],...
        'FaceColor','none','EdgeColor','flat','Marker','none');
else
    p(p<pmin) = pmin;
    hsurf = bar2D(x,y,p,colorMap);
end
set(gca,'clim',[pmin pmax]);
%% check the matlab version 
hCB = setUniqAxesMap(gca, colorMap, 1);

YTick         = get(hCB,'YTick');
%YTick(end)    = 1;
if length(YTick)>6 
    YTick = YTick(1:2:end);
end
set(hCB,'YTick',YTick);
YTickLbls     = num2cell(1-YTick');
YTickLbls{1 } = ['>',num2str(YTickLbls{1})];
set(hCB,'YTickLabel',YTickLbls);