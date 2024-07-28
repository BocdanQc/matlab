function PlotConfusionMatrix(cm, labels, background)
%function PlotConfusionMatrix(cm, labels, background)
%  DESCRIPTION
%    This function displays the given confusion matrix.
%  INPUT
%    cm: The confusion matrix to display.
%    labels: [optional] The names (strings) of each class of the confusion
%            matrix.
%    background: [optional] If set to true, the background color will
%                reflect the value in the box. The default value is true.
%  OUTPUT
%     N/A

    WIDTH  = 1280;
    HEIGHT = 720;

    if (nargin < 3)
        background = true;
    end
    
    cmsize = size(cm);
    normcm = cm ./ max(max(cm));

    scrsize = get(groot,'ScreenSize');
    figure('Name', 'Confusion Matrix', 'Position', [(scrsize(3) - WIDTH) / 2, (scrsize(4) - HEIGHT) / 2, WIDTH, HEIGHT]);

    if (background)
        imagesc(normcm');
        lightgray = [0.350 0.350 0.350
                     0.500 0.500 0.500
                     0.600 0.600 0.600
                     0.700 0.700 0.700
                     0.750 0.750 0.750
                     0.800 0.800 0.800
                     0.850 0.850 0.850
                     0.900 0.900 0.900
                     0.925 0.925 0.925
                     0.950 0.950 0.950
                     0.975 0.975 0.975
                     1.000 1.000 1.000];
        colormap(lightgray);
    else
        imagesc(ones(cmsize));
        colormap(white);
    end

    set(gca, 'XTick', 1 : cmsize);
    set(gca, 'YTick', 1 : cmsize);
    if (exist('labels', 'var'))
        set(gca, 'XTickLabel', labels, 'FontSize', 10);
        set(gca, 'XTickLabelRotation', 45);
        set(gca, 'YTickLabel', labels, 'FontSize', 10);
    end
    
    xlabel('Predicted', 'FontSize', 10);
    ylabel('Actual', 'FontSize', 10);

    if (background)
        set(gca, 'TickDir', 'out');
        set(gca, 'TickLength', [0.005 0.010]);
    else
        set(gca, 'TickDir', 'in');
        set(gca, 'TickLength', [0.0 0.0]);
        set(gca, 'GridColor', 'white');
        set(gca, 'XGrid', 'on');
        set(gca, 'YGrid', 'on');
        set(gca, 'MinorGridLineStyle', '-');
        set(gca, 'MinorGridColor', 'blue');
        ax = get(gca, 'XAxis');
        ax.MinorTickValues = 0.5 : cmsize - 0.5;
        ax = get(gca, 'YAxis');
        ax.MinorTickValues = 0.5 : cmsize - 0.5;
        set(gca, 'XMinorGrid', 'on');
        set(gca, 'YMinorGrid', 'on');
    end
    
    
    for i = 1 : cmsize
        for j = 1 : cmsize
            if (background && normcm(i, j) < 0.2)
                color = 'white';
            else
                color = 'black';
            end
            value = cm(i, j);
            if (value >= 0.05)
                str = sprintf('%.1f%', value);
            else
                str = ' ';
            end
            text(i, j, str , 'FontSize', 8, 'Color', color, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
        end
    end
end
