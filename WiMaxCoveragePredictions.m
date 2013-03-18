%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation of different propagation models and their comparison between them. 							%
% Models to be simulated: COST 231 LOS and Freespace propagation Model, COST 231 NLOS for medium city %
% and metropolitan centre, behaviour of path loss exponent (Gamma) in Erceg's Model						%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cont=1;

%Constants for Category A (Hilly/Moderate-to-Heavy Tree Density)
a1=4.6
b1=0.0075
c1=12.6
sigmagamma1=0.57

%Constants for Category B (Hilly/Light Tree Density or Flat/Moderate-to-Heavy Tree Density)
a2=4.0
b2=0.0065
c2=17.1
sigmagamma2=0.75

%Constants for Category C (Flat/Light Tree Density)
a3=3.6
b3=0.0050
c3=20.0
sigmagamma3=0.59

fLOS=3.5e03; %(fLOS=3.5e09 Hz=3.5 GHz->Frequency to be simulatedm,fLOS in MHz)
lLos=zeros(1,490);
lLosfreespace=zeros(1,490);
lLosfreespace2=zeros(1,490);
Lmsdmedium=zeros(1,490);
Lmsdmetro=zeros(1,490);
Hroof=12; %Hroof in meters, a typical value is 3m(number of floors)+roof
Hmobile=1; %Hmobile in meters
DeltaHmob=Hroof-Hmobile;
phi=90; %Phi in degrees which is the street orientation with respect to the incident wave.
Lori= -10+((0.354*phi)-55);
w=10;   %w in meters. It is the mean value of widths of streets 
b=25;  %b in meters. It is the mean separation of the buildings
Lrts=-16.9-(10*log10(w))+(10*log10(fLOS))+(20*log10(DeltaHmob))+Lori; %Lrts is the roof top to street diffraction, and this is applied wheen hroof>hmobile, otherwise it turns to zero.
Hbase=35 %Hbase in meters
DeltaHbase=Hbase-Hroof;
Lbeh=-18*log10(1+(DeltaHbase)) %If Hbase>Hroof otherwise Lbeh turns to zero.
Ka=54 %Hbase>Hroof
Kd=18 %Hbase>Hroof
Kfmedium=-4+(0.7*((fLOS/925)-1)) 
Kfmetro=-4+(1.5*((fLOS/925)-1))

hb=10:0.1:80 %from 10 to 80 m (height of the transmitter)
%For Category A
x1=sigmagamma1*randn(1,701);
%For Category B
x2=sigmagamma2*randn(1,701);
%For Category C
x3=sigmagamma3*randn(1,701);
%For randomness of Gamma
gamma1=(a1-(b1*hb)+(c1./hb))+x1; %Category A
gamma2=(a2-(b2*hb)+(c2./hb))+x2; %Category B
gamma3=(a3-(b3*hb)+(c3./hb))+x3; %Category C

for d=0.1:0.01:5,           %d in km
   lLos(cont)=42.64+(26*log10(d))+(20*log10(fLOS)); %Compute the path loss for W-I LOS
   lLosfreespace(cont)=-147.5584+(20*log10(fLOS*1e06))+(20*log10(d*1e03)); %Compute the path loss for freespace
  	Lmsdmedium(cont)=Lbeh+Ka+(Kd*log10(d))+(Kfmedium*log10(fLOS))-(9*log10(b)); %Compute Lmsd for W-I NLOS in a medium city scenario
   Lmsdmetro(cont)=Lbeh+Ka+(Kd*log10(d))+(Kfmetro*log10(fLOS))-(9*log10(b)); %Compute Lmsd for W-I NLOS in a metropolitan centre  
   cont=cont+1;
end
Lbmedium=lLosfreespace+Lmsdmedium+Lrts; %Compute the path loss for W-I NLOS in the medium city scenario
Lbmetro=lLosfreespace+Lmsdmetro+Lrts;   %Compute the path loss for W-I NLOS in the metropolitan centre
d=0.1:0.01:5;
figure(1);
plot_handles_lLos=plot(d,lLos,'r');
grid on;
hold on;
plot_handles_lLosfreespace=plot(d,lLosfreespace);
title('COST 231 Walfisch-Ikegami Model for LOS & Free Space Propagation Model');
legend_handle=[plot_handles_lLos,plot_handles_lLosfreespace];
legend(legend_handle,'COST 231 (WI) for LOS','Free space path loss',1);
axis([0.1 5 80 140]);
xlabel('Distance [km] (d>=0.1km)');
ylabel('Propagation loss');
hold off;

figure(2);
plot_handles_Lbmedium=plot(d,Lbmedium,'g');
grid on;
hold on;
plot_handles_Lbmetro=plot(d,Lbmetro);
title('COST 231 Walfisch-Ikegami Model for NLOS (Medium sized city and metropolitan centre)');
legend_handle=[plot_handles_Lbmedium,plot_handles_Lbmetro];
legend(legend_handle,'COST 231 (WI) for NLOS (Medium sized city)','COST 231 (WI) for NLOS (Metro. centre)',2);
axis([0.1 5 70 150]);
xlabel('Distance [km] (d>=0.1km)');
ylabel('Propagation loss');
hold off;

figure(3);
plot_handles_CAs=plot(hb,gamma1);
grid on;
hold on;
plot_handles_CBs=plot(hb,gamma2,'r');
plot_handles_CCs=plot(hb,gamma3,'g');
legend_handle=[plot_handles_CAs,plot_handles_CBs, plot_handles_CCs];
legend(legend_handle,'Category A','Category B','Category C',1);
title('Ercegs Model');
xlabel('hb [m]');
ylabel('Path loss exponent [dB]');

figure(4);
plot_handles_CAm=plot(hb, (a1-(b1*hb)+(c1./hb)));
grid on;
hold on;
plot_handles_CBm=plot(hb, (a2-(b2*hb)+(c2./hb)),'r');
plot_handles_CCm=plot(hb, (a3-(b3*hb)+(c3./hb)),'g');
legend_handle=[plot_handles_CAm,plot_handles_CBm, plot_handles_CCm];
legend(legend_handle,'Category A','Category B','Category C',1);
title('Ercegs Model');
xlabel('hb [m]');
ylabel('Mean of Path loss exponent [dB]');
