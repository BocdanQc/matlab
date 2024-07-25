function PlotConfusionMatrix(cm, accuracy, labels, background)
%function PlotConfusionMatrix(cm, accuracy, labels, background)
%  DESCRIPTION
%    This function displays the given confusion matrix.
%  INPUT
%    cm: The confusion matrix to display.
%    accuracy: The overall accuracy of the prediction shown by the
%              confusion matrix.
%    labels: [optional] The names (strings) of each class of the confusion
%            matrix.
%    background: [optional] If set to true, the background color will
%                reflect the value in the box. The default value is true.
%  OUTPUT
%     N/A

    if (nargin < 4)
        background = true;
    end
    
    cmsize = size(cm);
    normcm = cm ./ max(max(cm));

    figure('Name', 'Confusion Matrix');
    clf;
    if (background)
        imagesc(normcm');
        lightgray = [0.40 0.40 0.40
                     0.45 0.45 0.45
                     0.50 0.50 0.50
                     0.55 0.55 0.55
                     0.60 0.60 0.60
                     0.65 0.65 0.65
                     0.70 0.70 0.70
                     0.75 0.75 0.75
                     0.80 0.80 0.80
                     0.85 0.85 0.85
                     0.90 0.90 0.90
                     0.95 0.95 0.95
                     1.00 1.00 1.00];
        colormap(lightgray);
    else
        imagesc(ones(cmsize));
        colormap(white);
    end

    title(sprintf('Confusion Matrix\n(Accuracy = %.2f%%)\n', accuracy));

    set(gca, 'TickDir', 'out');
    set(gca, 'TickLength', [0.005 0.010]);
    set(gca, 'XTick', 1 : cmsize);
    set(gca, 'YTick', 1 : cmsize);
    if (exist('labels', 'var'))
        set(gca, 'XTickLabel', labels, 'FontSize', 10);
        set(gca, 'XTickLabelRotation', 45);
        set(gca, 'YTickLabel', labels, 'FontSize', 10);
    end
    
    xlabel('Predicted', 'FontSize', 10);
    ylabel('Actual', 'FontSize', 10);
    
    for i = 1 : cmsize
        for j = 1 : cmsize
            if (background && normcm(i, j) < 0.2)
                color = 'w';
            else
                color = 'k';
            end
            str = ' ';
            value = cm(i, j);
            if (value >= 0.1)
                str = sprintf('%.1f%', value);
            end
            text(i, j, str , 'FontSize', 8, 'Color', color, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
        end
    end
end
