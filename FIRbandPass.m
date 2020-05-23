clc
clear all;
close all;
As = 60;
%frecuencia de muestreo (KHz)
Fs = 44100;
%Fs = 22050;

fp1=5000;
fp2=10000;
disp('Frecuencias digitales para Fs=44100[Hz]')
Wp1=(fp1/Fs)
Wp2=(fp2/Fs)

%asumimos un valor de 0.05 cercana a wp1 y wp2 
ws1 = (Wp1-0.05)*pi; 
wp1 = Wp1*pi;
wp2 = Wp2*pi;
ws2 = (Wp2+0.05)*pi; 

Aw = min((wp1-ws1),(ws2-wp2));
M = ceil(11*pi/Aw) + 1;
n=[0:1:M-1]; 
wc1 = (ws1+wp1)/2; 
wc2 = (wp2+ws2)/2;
hd = ideal_lp(wc2,M) - ideal_lp(wc1,M);
w_bla = (blackman(M))';
h = hd .* w_bla;
[db,mag,pha,grd,w] = freqz_m(h,[1]); 

f1=((w/pi)*Fs)/1000;

disp('Funciòn de transferencias')
Hz=tf(h, [1], 0.1) %Funcion de transferencia
delta_w = 2*pi/1000;
Rp = -min(db(wp1/delta_w+1:1:wp2/delta_w)); 

%Plots
subplot(2,3,1); zplane(h); title('Diagrama de Polos y Zeros');
axis([-2 2 -1.5 1.5]); xlabel('Real'); ylabel('Imaginario');

subplot(2,3,2); plot(w/pi,mag); title('Magnitud del filtro |H|'); grid
xlabel('Frecuencia Normalizada'); ylabel('|H|')

subplot(2,3,4); plot(w/pi,grd); title('Retardo de grupo'); grid
 xlabel('Frecuencia Normalizada (\times\pi rad/sample)'); ylabel('Retardo de Grupo (samples)')

subplot(2,3,5); plot(w/pi,db);title('Magnitud del filtro en Db'); grid
xlabel('Frecuencia (\times\pi)'); ylabel('Db')

%Cambiando frecuencia digital por frecuencia an'aloga 
subplot(2,3,3); plot(f1, mag); title('Magnitud con frecuencia Analógica'); grid
axis([0 20 0 1.2]);xlabel('F(KHz)'); ylabel('|H|')

%Cambiando frecuencia digital por frecuencia an'aloga 
subplot(2,3,6); plot(f1,-unwrap(pha)); title('Fase con frecuencia Analógica'); grid
axis([0 20 -130 10]);xlabel('F(KHz)'); ylabel('Fase')
%APLICANDO FILTRO A LOS WAV (CAMBIAR POR CADA AUDIO.WAV)
[data Fs]=audioread('Boombo.wav');
y = filter(h, 1, data);                     %FILTRO FIR APLICADO A WAV

%PLOT FILTROS WAV (CAMBIAR POR CADA AUDIO.WAV)
figure(2)
subplot(2,1,1); plot(data);title('AUDIO ORIGINAL');grid  
xlabel('Boombo.wav'); ylabel('Samples')
subplot(2,1,2); plot(y);title('AUDIO FILTRADO');grid  
xlabel('Boombo.wav'); ylabel('Samples') 
