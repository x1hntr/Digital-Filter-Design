clc
clear all;
close all;

%frecuencia de muestreo (KHz)
Fs = 44100
%Fs = 22050
disp('Frecuencias digitales para Fs=44100[Hz]')
wc1=(7000)/Fs
wc2=(12000)/Fs

%asumimos un valor de 0.05 cercana a wc1 y wc2 

wp1 = (wc1-0.05)*pi; % lower passband edge
ws1 = wc1*pi; % lower stopband edge
ws2 = wc2*pi; % upper stopband edge
wp2 = (wc2+0.05)*pi; % upper passband edge

Rp = 0.2; % passband ripple
As = 50; % stopband attenuation
tr_width = abs(min((wp1-ws1),(ws2-wp2)));
M = ceil(11*pi/tr_width);
M = 2*floor(M/2)+1; % choose odd M

n = 0:M-1; 
w_black = (blackman(M))';
wc1 = (ws1+wp1)/2; 
wc2 = (ws2+wp2)/2;
hd = ideal_lp(pi,M)+ideal_lp(wc1,M)-ideal_lp(wc2,M); 
h = hd .* w_black;
disp('Funciòn de transferencia')
Hz=tf(h, [1], 0.1) %Funcion de transferencia
[db,mag,pha,grd,w] = freqz_m(h,1); 
delta_w = pi/500;
f1=((w/pi)*Fs)/1000;
Asd = floor(-max(db(ceil(ws1/delta_w)+1:floor(ws2/delta_w)+1))); % Actual Attn
Rpd = -min(db(1:floor(wp1/delta_w)+1)); % Actual passband ripple



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
axis([0 20 -0.1 1.2]);xlabel('F(KHz)'); ylabel('|H|')

%Cambiando frecuencia digital por frecuencia an'aloga 
subplot(2,3,6); plot(f1,-unwrap(pha)); title('Fase con frecuencia Analógica'); grid
axis([0 20 -200 0]);xlabel('F(KHz)'); ylabel('Fase')

%APLICANDO FILTRO A LOS WAV (CAMBIAR POR CADA AUDIO.WAV)
[data Fs]=audioread('Boombo.wav');
y = filter(h, 1, data);                     %FILTRO FIR APLICADO A WAV

%PLOT FILTROS WAV (CAMBIAR POR CADA AUDIO.WAV)
figure(2)
subplot(2,1,1); plot(data);title('AUDIO ORIGINAL');grid  
xlabel('Boombo.wav'); ylabel('Samples')
subplot(2,1,2); plot(y);title('AUDIO FILTRADO');grid  
xlabel('Boombo.wav'); ylabel('Samples') 