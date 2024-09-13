close all;
clear all;
%script that reads in the monthly SIE(Sea Ice Extent) from the mat file

filename='osisaf_nh_SIE_monthly.mat';
load(filename);

SIE=Data.SIE;
years=Data.year;
months=Data.month;


%replace -999 FillValue with NaN:
SIE(SIE == -999) = NaN;

%calculate overall trend:
x=linspace(1,length(SIE),length(SIE));
y=SIE.';

dates = years + (1/12 * (months-1) );


% Fit the data
mdl = fitlm(x,y);
a = mdl.Coefficients.Estimate(2);% slope
b = mdl.Coefficients.Estimate(1);% intercept

figure(1)
plot(dates,y,'r') ;
hold on
%plot(mdl)
plot(dates,a*x+b,'black')
hold off
title('SIE NH, Slope = ',a)
xlim([1978,2023])
xlabel('Time')
ylabel('SIE')


%% only September

SIE_sep = SIE(months == 9);
dates_sep = years(months == 9);

% Fit the data
mdl_sep = fitlm(dates_sep,SIE_sep);
a2 = mdl_sep.Coefficients.Estimate(2);% slope
b2 = mdl_sep.Coefficients.Estimate(1);% intercept

figure(2)
plot(dates_sep,SIE_sep,'r') ;
hold on
plot(dates_sep,a2*dates_sep+b2,'black')
hold off
title('SIE NH September, Slope (km2/year) = ',a2)
xlim([1978,2023])
xlabel('Time')
ylabel('SIE')

%% when will the NH be ice free ??
%use september trend and see, when SIE hits 1 mill. km2

%extend dates from 1979-2021 to 1979-2070
dates_sep2=linspace(1979,2100,122);

%plot:
figure(3)
plot(dates_sep,SIE_sep,'r') ;
hold on
plot(dates_sep2,a2*dates_sep2+b2,'black')
yline(1*10^(6));
hold off
title('SIE NH September, Slope (km2/year) = ',a2)
xlim([1978,2100])
xlabel('Time')
ylabel('SIE')

%calculate first year in which september is ice free (SIE "below" zero):
expected_SIE = a2*dates_sep2+b2;
icefree_sep = dates_sep2(expected_SIE<1*10^(6));
icefree_sep(1)

years_to_icefree=icefree_sep(1)-2023



