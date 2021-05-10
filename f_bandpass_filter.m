function y=f_bandpass_filter(x,fsl,fpl,fph,fsh,Fs,Rp,As)

wpl=2*pi*fpl/Fs;
wph=2*pi*fph/Fs;
wsl=2*pi*fsl/Fs;
wsh=2*pi*fsh/Fs;
Wp=[wpl wph];
Ws=[wsl wsh];


[n,wn]=cheb1ord(Ws/pi,Wp/pi,Rp,As);
[bz1,az1]=cheby1(n,Rp,Wp/pi);



y=filter(bz1,az1,x);
%%
% fft_num=1024;
% frex=fft(x,fft_num);
% figure;plot((1:fft_num/2)*Fs/fft_num,sqrt(real(frex(1:fft_num/2)).^2+imag(frex(1:fft_num/2))));
%
% frey=fft(y,fft_num);
% hold on;plot((1:fft_num/2)*Fs/fft_num,sqrt(real(frey(1:fft_num/2)).^2+imag(frey(1:fft_num/2))),'r');
% legend('true frequence','filtered frequence');
% xlabel('frequence');
%
% figure;plot(x,1:length(x));
% hold on;plot(y,1:length(y),'r');
% ylabel('time');
% legend('true value','filtered value');