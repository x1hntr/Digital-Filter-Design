clc
clear all;
close all;
As=40;
%frecuencia de muestreo (KHz)
Fs = 44100;
%Fs = 22050;
%frecuencia de analogas (KHz)
Ws = 7000;
Wp = 6000;
%frecuencias digitales
disp('Frecuencias analógicas para Fs=22.05[KHz]')
wp1 = Wp/Fs
ws1 = Ws/Fs
wp = wp1*pi;
ws = ws1*pi;
%frecuencias analogicas en KHZ
Aw = ws - wp;
M = ceil(6.2*pi/Aw) + 1;
wc = (ws+wp)/2;
hd = ideal_lp(wc,M);
w_hann = (hann(M))';
h = hd .* w_hann;

[db,mag,pha,grd,w] = freqz_m(h,[1]);

f1=((w/pi)*Fs)/1000;

%funcion de transferencia
disp('Función de transferencias H(z)')
Hz=tf(h, [1], 0.1)
delta_w = 2*pi/1000;
Rp = -(min(db(1:1:wp/delta_w+1)));
At = -floor(max(db(ws/delta_w+1:1:501)));

% plots
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
xlabel('F(KHz)'); ylabel('|H|')

%Cambiando frecuencia digital por frecuencia an'aloga 
subplot(2,3,6); plot(f1,-unwrap(pha)); title('Fase con frecuencia Analógica'); grid
xlabel('F(KHz)'); ylabel('Fase')

%APLICANDO FILTRO A LOS WAV (CAMBIAR POR CADA AUDIO.WAV)
[data Fs]=audioread('Boombo.wav');
y = filter(h, 1, data);                     %FILTRO FIR APLICADO A WAV

%PLOT FILTROS WAV (CAMBIAR POR CADA AUDIO.WAV)
figure(2)
subplot(2,1,1); plot(data);title('AUDIO ORIGINAL');grid  
xlabel('Boombo.wav'); ylabel('Samples')
subplot(2,1,2); plot(y);title('AUDIO FILTRADO');grid  
xlabel('Boombo.wav'); ylabel('Samples') 

