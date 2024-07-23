function PlotSurfaceData(surface, samplesize, surfacename)
%function PlotSurfaceData(surface, samplesize, surfacename)
%  DESCRIPTION
%    This function displays the 2D representation of each acceleration axis
%    in time and the 3D representation of the 3 acceleration axis together
%  INPUT
%    surface: The surface data (accelerations) to display.
%    samplesize: The number of acceleration samples to display.
%    surfacename: [optional] The name of the surface.
%  OUTPUT
%    N/A

    if (nargin < 3)
        figure(1);
    else
        figure('Name', ['Surface Data: ', surfacename], 'NumberTitle', 'off');
    end
    clf;

    xy = 1 : samplesize;

    subplot(3, 2, 1);
    plot(xy, surface(xy, 1));
    title('Accelerations on X');

    subplot(3, 2, 3);
    plot(xy, surface(xy, 2));
    title('Accelerations on Y');

    subplot(3, 2, 5);
    plot(xy, surface(xy, 3));
    title('Accelerations on Z');

    subplot(3, 2, [2, 4, 6]);
    plot3(surface(xy', 1),surface(xy', 2),surface(xy', 3), '+r');
    title('3D Accelerations');
    grid on
    axis square
end
