%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATION OF A FIRST ORDER STATISTICAL MODEL FOR K                                %
% ASSUMING K AS A LOGNORMAL VARIABLE AND K IS A FUNCTION OF DISTANCE, Fs, Fh, AND Fb.% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% WE DEFINE THE VALUES OF THE HEIGHT RECEIVER AND THE ANTENNA BEAMWIDTH (IN
% ACCORDANCE WITH THE TABLE 1. OF THE PAPER "RICEAN K-VALUES.."
% HEIGHTS
h1=3;
h2=10;

%BEAMWIDTHS
b1=17;
b2=30;
b3=65;

% DEFINITION OF Fs, Fh AND Fb.
Fs_Summer= 1.0; % SUMMER (LEAVES)
Fs_Winter= 2.5; % WINTER (NO LEAVES)

Fh1=(h1/3)^0.46; % H IN METERS
Fh2=(h2/3)^0.46

Fb1=(b1/17)^-0.62; % B IN DEGREES
Fb2=(b2/17)^-0.62;
Fb3=(b3/17)^-0.62;

Ko=10.0; %Ko is 10 in dB
Gamma=-0.5; %Go is -0.5 dB

% Distance goes from 2 to 10
% Definition of two variables K_Summer and K_Winter in which each one depends if it is
% Summer or Winter.
K_Summer1_3m=Fs_Summer*Fh1*Fb1*Ko;
K_Summer2_3m=Fs_Summer*Fh1*Fb2*Ko;
K_Summer3_3m=Fs_Summer*Fh1*Fb3*Ko;

K_Summer1_10m=Fs_Summer*Fh2*Fb1*Ko;
K_Summer2_10m=Fs_Summer*Fh2*Fb2*Ko;
K_Summer3_10m=Fs_Summer*Fh2*Fb3*Ko;

K_Winter1_3m=Fs_Winter*Fh1*Fb1*Ko;
K_Winter2_3m=Fs_Winter*Fh1*Fb2*Ko;
K_Winter3_3m=Fs_Winter*Fh1*Fb3*Ko;

K_Winter1_10m=Fs_Winter*Fh2*Fb1*Ko;
K_Winter2_10m=Fs_Winter*Fh2*Fb2*Ko;
K_Winter3_10m=Fs_Winter*Fh2*Fb3*Ko;

% Generation of a Gaussian random variable with standard deviation of 8 db, with 1001 samples
y=2:0.008:10;
s=8;
x=s*randn(1,1001);

% Compute of K_SummerTot and K_WinterTot
d=y;
K_SummerTot1_3m=10*log10(K_Summer1_3m)+ 10*Gamma*log10(d); %K_SummerTot in dB, this value is the mean for the r.v. K
K_SummerTot2_3m=10*log10(K_Summer2_3m)+ 10*Gamma*log10(d);
K_SummerTot3_3m=10*log10(K_Summer3_3m)+ 10*Gamma*log10(d);

K_SummerTot1_10m=10*log10(K_Summer1_10m)+ 10*Gamma*log10(d);
K_SummerTot2_10m=10*log10(K_Summer2_10m)+ 10*Gamma*log10(d);
K_SummerTot3_10m=10*log10(K_Summer3_10m)+ 10*Gamma*log10(d);

K_WinterTot1_3m=10*log10(K_Winter1_3m)+ 10*Gamma*log10(d); %K_WinterTot in dB, this value is the mean for the r.v. K
K_WinterTot2_3m=10*log10(K_Winter2_3m)+ 10*Gamma*log10(d);
K_WinterTot3_3m=10*log10(K_Winter3_3m)+ 10*Gamma*log10(d);
K_WinterTot1_10m=10*log10(K_Winter1_10m)+ 10*Gamma*log10(d);
K_WinterTot2_10m=10*log10(K_Winter2_10m)+ 10*Gamma*log10(d);
K_WinterTot3_10m=10*log10(K_Winter3_10m)+ 10*Gamma*log10(d);

%Mean and variations around the mean (mean=k_SummerTot or K_WinterTot) plus the Gaussian random variable with zero 
%mean and standard deviation=s

K_SummerEst1_3m=K_SummerTot1_3m+x;
K_SummerEst2_3m=K_SummerTot2_3m+x;
K_SummerEst3_3m=K_SummerTot3_3m+x;

K_SummerEst1_10m=K_SummerTot1_10m+x;
K_SummerEst2_10m=K_SummerTot2_10m+x;
K_SummerEst3_10m=K_SummerTot3_10m+x;

K_WinterEst1_3m=K_WinterTot1_3m+x;
K_WinterEst2_3m=K_WinterTot2_3m+x;
K_WinterEst3_3m=K_WinterTot3_3m+x;

K_WinterEst1_10m=K_WinterTot1_10m+x;
K_WinterEst2_10m=K_WinterTot2_10m+x;
K_WinterEst3_10m=K_WinterTot3_10m+x;

figure(2);
plot(y,K_SummerEst1_3m,'g')
hold on;
plot_handles_median=plot(y,K_SummerTot1_3m,'r')
grid on;
title('SUMMER H=3m, BW=17')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Summer1_3m=median(K_SummerEst1_3m)
hold off;

figure(3);
plot(d,K_SummerEst2_3m,'g')
hold on;
plot_handles_median=plot(y,K_SummerTot2_3m,'r')
grid on;
title('SUMMER H=3m, BW=30')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Summer2_3m=median(K_SummerEst2_3m)
hold off;

figure(4);
plot(d,K_SummerEst3_3m,'g')
hold on;
plot_handles_median=plot(y,K_SummerTot3_3m,'r')
grid on;
title('SUMMER H=3m, BW=65')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Summer3_3m=median(K_SummerEst3_3m)
hold off;

figure(5);
plot(d,K_SummerEst1_10m,'g')
hold on;
plot_handles_median=plot(y,K_SummerTot1_10m,'r')
grid on;
title('SUMMER H=10m, BW=17')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Summer1_10m=median(K_SummerEst1_10m)
hold off;

figure(6);
plot(d,K_SummerEst2_10m,'g')
hold on;
plot_handles_median=plot(y,K_SummerTot2_10m,'r')
grid on;
title('SUMMER H=10m, BW=30')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Summer2_10m=median(K_SummerEst2_10m)
hold off;

figure(7);
plot(d,K_SummerEst3_10m,'g')
hold on;
plot_handles_median=plot(y,K_SummerTot3_10m,'r')
grid on;
title('SUMMER H=10m, BW=65')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Summer3_10m=median(K_SummerEst3_10m)
hold off;

figure(8);
plot(d,K_WinterEst1_3m,'g')
hold on;
plot_handles_median=plot(y,K_WinterTot1_3m,'r')
grid on;
title('WINTER H=3m, BW=17')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Winter1_3m=median(K_WinterEst1_3m)
hold off;

figure(9);
plot(d,K_WinterEst2_3m,'g')
hold on;
plot_handles_median=plot(y,K_WinterTot2_3m,'r')
grid on;
title('WINTER H=3m, BW=30')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Winter2_3m=median(K_WinterEst2_3m)
hold off;

figure(10);
plot(d,K_WinterEst3_3m,'g')
hold on;
plot_handles_median=plot(y,K_WinterTot3_3m,'r')
grid on;
title('WINTER H=3m, BW=65')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Winter3_3m=median(K_WinterEst3_3m)
hold off;

figure(11);
plot(d,K_WinterEst1_10m,'g')
hold on;
plot_handles_median=plot(y,K_WinterTot1_10m,'r')
grid on;
title('WINTER H=10m, BW=17')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Winter1_10m=median(K_WinterEst1_10m)

figure(12);
plot(d,K_WinterEst2_10m,'g')
hold on;
plot_handles_median=plot(y,K_WinterTot2_10m,'r')
grid on;
title('WINTER H=10m, BW=30')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Winter2_10m=median(K_WinterEst2_10m)

figure(13);
plot(d,K_WinterEst3_10m,'g')
hold on;
plot_handles_median=plot(y,K_WinterTot3_10m,'r')
grid on;
title('WINTER H=10m, BW=65')
xlabel('Distance [km]')
ylabel('K [dB]')
legend_handle=[plot_handles_median];
legend(legend_handle,'Mean of K',1);
Median_Winter3_10m=median(K_WinterEst3_10m)
Median3_Winter3_10m=median(K_WinterTot3_10m)
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following figures represent the CDF's of the K factors obtained by the relationship given previously.
%We know that the pdf is a Gaussian distribution with mean K_xxx_Tot and deviation standard of 8.
%We define the values of K in which we want to know its cumulative distribution function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K=-30:0.070:40
figure(14);
r=CDFNormal(K,K_SummerTot1_3m,8);
plot_handles1=plot(K,r);
grid on;
title('CDF of K w/Beamwidth 17 (SUMMER-WINTER)')
hold on;
r=CDFNormal(K,K_SummerTot1_10m,8); %parameters: x, mean, sigma.
plot_handles2=plot(K,r,'r')
r=CDFNormal(K,K_WinterTot1_3m,8);
plot_handles3=plot(K,r,'g')
r=CDFNormal(K,K_WinterTot1_10m,8);
plot_handles4=plot(K,r,'c')
legend_handles=[plot_handles1;plot_handles2;plot_handles3;plot_handles4];
legend(legend_handles,'Summer H=3m','Summer H=10m','Winter H=3m','Winter H=10m',2);
hold off;

figure(15);
r=CDFNormal(K,K_SummerTot2_3m,8);
plot_handles1=plot(K,r);
grid on;
title('CDF of K w/Beamwidth 30 (SUMMER-WINTER)')
hold on;
r=CDFNormal(K,K_SummerTot2_10m,8);
plot_handles2=plot(K,r,'r')
r=CDFNormal(K,K_WinterTot2_3m,8);
plot_handles3=plot(K,r,'g')
r=CDFNormal(K,K_WinterTot2_10m,8);
plot_handles4=plot(K,r,'c')
legend_handles=[plot_handles1;plot_handles2;plot_handles3;plot_handles4];
legend(legend_handles,'Summer H=3m','Summer H=10m','Winter H=3m','Winter H=10m',2);
hold off;

figure(16);
r=CDFNormal(K,K_SummerTot3_3m,8);
plot_handles1=plot(K,r);
grid on;
title('CDF of K w/Beamwidth 65 (SUMMER-WINTER)')
hold on;
r=CDFNormal(K,K_SummerTot3_10m,8);
plot_handles2=plot(K,r,'r')
r=CDFNormal(K,K_WinterTot3_3m,8);
plot_handles3=plot(K,r,'g')
r=CDFNormal(K,K_WinterTot3_10m,8);
plot_handles4=plot(K,r,'c')
legend_handles=[plot_handles1;plot_handles2;plot_handles3;plot_handles4];
legend(legend_handles,'Summer H=3m','Summer H=10m','Winter H=3m','Winter H=10m',2);
hold off;




