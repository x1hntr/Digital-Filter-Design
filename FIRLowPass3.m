clc
clear all;
close all;
As = 70;
%frecuencia de muestreo (KHz)
%Fs = 44100;
Fs = 22050;
%frecuencia de analogas (KHz)
Ws = 1500;
Wp = 1000;
%frecuencias digitales
disp('Frecuencias digitales para Fs=44100[Hz]')
wp1 = Wp/Fs
ws1 = Ws/Fs
wp = wp1*pi;
ws = ws1*pi;
%frecuencias analogicas en KHZ

%Diseño del filtro BLACKMAN
Aw = ws - wp;
M = ceil(11*pi/Aw) + 1;
wc = (ws+wp)/2;
hd = ideal_lp(wc,M);
w_black = (blackman(M))';
h = hd .* w_black;
[db,mag,pha,grd,w] = freqz_m(h,[1]);

f1=((w/pi)*Fs)/1000;

%funcion de transferencia
disp('Funciòn de transferencias')
Hz=tf(h, [1], 0.1)
delta_w = 2*pi/1000;
Rp = -(min(db(1:1:wp/delta_w+1)));
At = -round(max(db(ws/delta_w+1:1:501)));

%plots
subplot(2,3,1); zplane(h); title('Diagrama de Polos y Zeros');
axis([-2 2 -1.5 1.5]); xlabel('Real'); ylabel('Imaginario');

subplot(2,3,2); plot(w/pi,mag); title('Magnitud del filtro |H|'); grid
axis([0 1 -0.1 1.25]); xlabel('Frecuencia Normalizada'); ylabel('|H|')

subplot(2,3,4); plot(w/pi,grd); title('Retardo de grupo'); grid
xlabel('Frecuencia Normalizada (\times\pi rad/sample)'); ylabel('Retardo de Grupo (samples)')

subplot(2,3,5); plot(w/pi,db);title('Magnitud del filtro en Db'); grid
axis([0 1 -250 10]); xlabel('Frecuencia (\times\pi)'); ylabel('Db')

%Cambiando frecuencia digital por frecuencia an'aloga 
subplot(2,3,3); plot(f1, mag); title('Magnitud con frecuencia Analógica'); grid
axis([0 5 0 1.2]);xlabel('F(KHz)'); ylabel('|H|')

%Cambiando frecuencia digital por frecuencia an'aloga 
subplot(2,3,6); plot(f1,-unwrap(pha)); title('Fase con frecuencia Analógica'); grid
axis([0 5 -60 0]); xlabel('F(KHz)'); ylabel('Fase')

%APLICANDO FILTRO A LOS WAV (CAMBIAR POR CADA AUDIO.WAV)
[data Fs]=audioread('Boombo.wav');
y = filter(h, 1, data);                     %FILTRO FIR APLICADO A WAV

%PLOT FILTROS WAV (CAMBIAR POR CADA AUDIO.WAV)
figure(2)
subplot(2,1,1); plot(data);title('AUDIO ORIGINAL');grid  
xlabel('Boombo.wav'); ylabel('Samples')
subplot(2,1,2); plot(y);title('AUDIO FILTRADO');grid  
xlabel('Boombo.wav'); ylabel('Samples') 