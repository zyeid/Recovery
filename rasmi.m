% insertion on the first level of dwt

%% preparation to embed
clc; clear all; close all;

delta=[50 150 150 300];
Nr=[128 1024 1024 1024];% taille de RF
Np=0;% taille de NP
I0=imread('lena.bmp');
fn=1;%variable pour le numéro de figure
 %% watermark embedding
 [CA0,CH0,CV0,CD0] = dwt2(I0,'sym2');

S_CA=CA0(2:257,2:257);% select the real subband (elli mech mech tetbaddal aleatoirement)
S_CH=CH0(2:257,2:257);
S_CV=CV0(2:257,2:257);
S_CD=CD0(2:257,2:257);

[ pop_CA,SH_CA,RF_CA,PL_CA ] = gen_msg( Nr(1),Np,S_CA );% gen message pour chaque sous bande
[ pop_CH,SH_CH,RF_CH,PL_CH ] = gen_msg( Nr(2),Np,S_CH );
[ pop_CV,SH_CV,RF_CV,PL_CV ] = gen_msg( Nr(3),Np,S_CV );
[ pop_CD,SH_CD,RF_CD,PL_CD ] = gen_msg( Nr(4),Np,S_CD );

SH1_CA=ins_Q(SH_CA,[RF_CA,PL_CA],delta(1));% insertion pour chaque sous bande
SH1_CH=ins_Q(SH_CH,[RF_CH,PL_CH],delta(2));
SH1_CV=ins_Q(SH_CV,[RF_CV,PL_CV],delta(3));
SH1_CD=ins_Q(SH_CD,[RF_CD,PL_CD],delta(4));

SW_CA=re_msg( S_CA,SH1_CA,pop_CA );%reintegrer le message dans sa position dans sous bande selon position
SW_CH=re_msg( S_CH,SH1_CH,pop_CH );
SW_CV=re_msg( S_CV,SH1_CV,pop_CV );
SW_CD=re_msg( S_CD,SH1_CD,pop_CD );

CAw=CA0;% update the watermarked subband
CHw=CH0;
CVw=CV0;
CDw=CD0;
CAw(2:257,2:257)=SW_CA;
CHw(2:257,2:257)=SW_CH;
CVw(2:257,2:257)=SW_CV;
CDw(2:257,2:257)=SW_CD;

 Iw=uint8(idwt2(CAw,CHw,CVw,CDw,'sym2'));% idwt
 
 %% perform attack
 Ia=attack(Iw,5);%3
 %% recovery preparation
 [CAa,CHa,CVa,CDa] = dwt2(Ia,'sym2');%idwt
 
 [ PL_H_CA,RF_H_CA ] = dec_msg( CAa(2:257,2:257),pop_CA,Nr(1),Np );%%decoding of the hosts of PL and RF for each subband
 [ PL_H_CH,RF_H_CH ] = dec_msg( CHa(2:257,2:257),pop_CH,Nr(2),Np );
 [ PL_H_CV,RF_H_CV ] = dec_msg( CVa(2:257,2:257),pop_CV,Nr(3),Np );
 [ PL_H_CD,RF_H_CD ] = dec_msg( CDa(2:257,2:257),pop_CD,Nr(4),Np );
 

%% recovery using polyfit function
[B_CA]=polyfit(RF_H_CA,RF_CA,1); %estimation des parametres du canal
[B_CH]=polyfit(RF_H_CH,RF_CH,1); %estimation des parametres du canal
[B_CV]=polyfit(RF_H_CV,RF_CV,1); %estimation des parametres du canal
[B_CD]=polyfit(RF_H_CD,RF_CD,1); %estimation des parametres du canal

figure(fn)% CA
fn=fn+1;
title('CA')
hold on
plot(1:size(RF_H_CA,2),sort(SH_CA))% original
plot(1:size(RF_H_CA,2),sort(SH1_CA))% watermarked
plot(1:size(RF_H_CA,2),sort(RF_H_CA))% attacked
%plot(1:size(RF_H_CA,2),sort(RF_H_CA*B_CA(1)+B_CA(2)))% recovered
hold off
legend('original','watermarked','attacked');

figure(fn)% CH
fn=fn+1;
title('CH')
hold on
plot(1:size(RF_H_CH,2),sort(SH_CH))% original
plot(1:size(RF_H_CH,2),sort(SH1_CH))% watermarked
plot(1:size(RF_H_CH,2),sort(RF_H_CH))% attacked
%plot(1:size(RF_H_CH,2),sort(RF_H_CH*B_CH(1)+B_CH(2)))% recovered
hold off
legend('original','watermarked','attacked');

figure(fn)% CV
fn=fn+1;
title('CV')
hold on
plot(1:size(RF_H_CV,2),sort(SH_CV))% original
plot(1:size(RF_H_CV,2),sort(SH1_CV))% watermarked
plot(1:size(RF_H_CV,2),sort(RF_H_CV))% attacked
%plot(1:size(RF_H_CV,2),sort(RF_H_CV*B_CV(1)+B_CV(2)))% recovered
hold off
legend('original','watermarked','attacked');

figure(fn)% CD
fn=fn+1;
title('CD')
hold on
plot(1:size(RF_H_CD,2),sort(SH_CD))% original
plot(1:size(RF_H_CD,2),sort(SH1_CD))% watermarked
plot(1:size(RF_H_CD,2),sort(RF_H_CD))% attacked
%plot(1:size(RF_H_CD,2),sort(RF_H_CD*B_CD(1)+B_CD(2)))% recovered
hold off
legend('original','watermarked','attacked');

%%  recovery using channel estimation

[A_CA]=PSO_adaptive(RF_H_CA,RF_CA); %estimation des parametres du canal avec PSO
[A_CH]=PSO_adaptive(RF_H_CH,RF_CH);
[A_CV]=PSO_adaptive(RF_H_CV,RF_CV); 
[A_CD]=PSO_adaptive(RF_H_CD,RF_CD); 

figure(fn)% estimated detection regions
fn=fn+1; 
subplot(4,1,1)
sawar_det_reg( RF_H_CA,RF_CA,A_CA,'CA' )
subplot(4,1,2)
sawar_det_reg( RF_H_CH,RF_CH,A_CH,'CH' )
subplot(4,1,3)
sawar_det_reg( RF_H_CV,RF_CV,A_CV,'CV' )
subplot(4,1,4)
sawar_det_reg( RF_H_CD,RF_CD,A_CD,'CD' )

 
gain_noise_CA=delta(1)/A_CA(1);% calul des parametres du canal
gain_noise_CH=delta(2)/A_CH(1);
gain_noise_CV=delta(3)/A_CV(1);
gain_noise_CD=delta(4)/A_CD(1);
mean_noise_CA=0;%A_CA(2);
mean_noise_CH=0;%A_CH(2);
mean_noise_CV=0;%A_CV(2);
mean_noise_CD=0;%A_CD(2);
 
%recovery from the channel destortion
CAr=CAa;% update of each subband
CHr=CHa;
CVr=CVa;
CDr=CDa;
CAr=CAr*gain_noise_CA+mean_noise_CA;
CHr=CHr*gain_noise_CH+mean_noise_CH;
CVr=CVr*gain_noise_CV+mean_noise_CV;
CDr=CDr*gain_noise_CD+mean_noise_CD;
 
 
Ir=uint8(idwt2(CAr,CHr,CVr,CDr,'sym2')); %reconstruction of the image

figure(fn)%plot of different image(original, watermarked, attacked and recovered)
fn=fn+1; 
subplot(2,2,1)
imshow(I0);title('original')
subplot(2,2,2)
imshow(Iw);title(['watermarked ' num2str(psnr(Iw,I0))])
subplot(2,2,3)
imshow(Ia);title(['Attacked ' num2str(psnr(Ia,I0))])
subplot(2,2,4)
imshow(Ir);title(['recovered ' num2str(psnr(Ir,I0))])