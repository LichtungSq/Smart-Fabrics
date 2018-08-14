function [fitresult, gof] = createFit(A_t, A)
%CREATEFIT(A_T,A)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : A_t
%      Y Output: A
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 13-Aug-2018 12:07:59 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( A_t, A );

% Set up fittype and options.
ft = fittype( 'a*exp(b*x)/(c+exp(d*x))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'Bisquare';
opts.StartPoint = [0.296675873218327 0.318778301925882 0.424166759713807 0.507858284661118];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'A vs. A_t', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel A_t
ylabel A
grid on


