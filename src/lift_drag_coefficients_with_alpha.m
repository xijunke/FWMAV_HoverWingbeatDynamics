%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% lift and drag coefficients with Alpha
clear all; clc;
% alpha=atan2(-w_y,w_z);    %Aerodynamic angle of attack  %���Ҫ����������Ƹ���ĳ��˶�������
beta=pi/4; f=0.25; %\Hz
delta=pi/4;    %���delta:  ��ǰģʽ:delta=pi/4; �ӳ�ģʽ:delta=-pi/4; �Գ�ģʽ:delta=0;
t=linspace(0,10,200);
alpha=(beta*sin(2*pi*f*t+delta))*180/pi;
% figure(1)
% plot(t,alpha,'r.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��ʹ�ú���fzero,�����ֵ����ʹ�ú���find�ҵ���λ������
options=optimset('Display','off');
t1_0=fzero(inline('45*sin(pi/4 + (pi*t)/2)','t'),[3,4],options); 
t2_0=fzero(inline('45*sin(pi/4 + (pi*t)/2)','t'),[5,6],options);
% Result:   t1_0=3.5000;   t2_0=5.5000;
% indxx1=find(t==1.5)  %ȡ�Ⱥ�ֵ'=='
indx1=find(t>3.45 & t<=3.5);  %�������
indx2=find(t>5.45 & t<=5.5);
% Result:   indx1=70;   indx2=110;
alpha_2=alpha(1,indx1:indx2);      % �������    %  alpha_2��(0��,45��)
% figure(2)
% plot(t(1,indx1:indx2),alpha_2,'ro')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���alpha_2�����ֵ����Сֵ����λ������
[alpha_2_max, locat_max]=max(alpha_2);   % ���:  alpha_2_max =44.9716;  locat_max =22;
% [alpha_2_min locat_min]=min(alpha_2);  % ���:  alpha_2_min =-2.3078;    locat_min =1;
m=length(alpha_2);                                                     %m =41
alpha_3=alpha_2(1,locat_max:m)+45;     % size(alpha_3)  % (1*20)                  %  alpha_3��(45��,90��)
[alpha_new,index]=sort(alpha_3);           %���������У�������������
alpha_4=[0, alpha_2(1,2:locat_max-1), alpha_new];  % size(alpha_4)% (1*41)   %  alpha_4��(0��,90��)
% figure(3)
% plot(t(1,indx1:indx2),alpha_4,'m-d')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ����������ϵ���ĶԱȷ���
%% (1) 1999-Science-MH Dickinson������άʵ�����������ϵ��
C_L_dickinson=0.225+1.58*sin((2.13*alpha_4-7.2)*pi/180);   
C_D_dickinson=1.92-1.55*cos((2.04*alpha_4-9.82)*pi/180);  
% figure(4)
% plot(alpha_4,C_L_dickinson,'r-',alpha_4,C_D_dickinson,'b-')
% grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (2) 2005-ACC-Khan
C_t_khan=7*abs(alpha_4*pi/180)/pi;  % ��Ҫת����������ϵ��
C_L_khan=C_t_khan.*sin(2*alpha_4*pi/180); 
C_D_khan=C_L_khan.*tan(alpha_4*pi/180); 
% figure(5)
% plot(alpha_4,C_L_dickinson,'r*',alpha_4,C_D_dickinson,'b*',alpha_4,C_L_khan,'r-',alpha_4,C_D_khan,'b-')
% grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (3) 2004-JEB-Wang ZJ & 2005-JFM-Andersen_b & 2007-JFM-Bergou
A=1.2; B=1.4;   C=1.0;
C_L_wang=A*sin(2*alpha_4*pi/180);       % �ɶ�άCFD����������϶���,
C_D_wang=B-C*cos(2*alpha_4*pi/180);  % �ɶ�άCFD����������϶���,�������������������̬����Ŀ�Ƭ
% figure(6)
% plot(alpha_4,C_L_dickinson,'r*',alpha_4,C_D_dickinson,'b*',alpha_4,C_L_wang,'r-',alpha_4,C_D_wang,'b-')
% grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (4) 2005-JFM-Andersen_a
C_T=1.833;               
C_d_alpha0=0.21;        
C_d_alphapi_2=3.35;       
C_L_andersen=C_T*sin(2*alpha_4*pi/180); 
C_D_andersen=C_d_alpha0*(cos(alpha_4*pi/180)).^2+C_d_alphapi_2*(sin(alpha_4*pi/180)).^2;  % ��������崵�����ֽ��
% C_L_andersen=C_D_andersen./tan(alpha_4*pi/180);  % ����ϵ��;�ο�2014-JRSI-Nabawy
% figure(7)
% plot(alpha_4,C_L_dickinson,'r*',alpha_4,C_D_dickinson,'b*',alpha_4,C_L_andersen,'r-',alpha_4,C_D_andersen,'b-') 
% grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (5) 2010-JFM-Whitney
% C_R=1.55;   % ת������������ϵ������ת�����ʺ�ת�����λ�ñ仯 
C_Lmax=1.8;   C_Dmax=3.4;     C_D0=0.4;  
C_L_whitney=C_Lmax*sin(2*alpha_4*pi/180);  
C_D_whitney=(C_Dmax+C_D0)/2-(C_Dmax-C_D0)/2*cos(2*alpha_4*pi/180);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (6) 2006-IEEE TR-Deng Xinyan & 2010-EAE-RJ Wood
% C_rot_theo=2*pi*(0.75-x_0nd(r));��  % ת������������ϵ��
C_N_deng=3.4*sin(alpha_4*pi/180);         % 
C_T_deng=0.4*(cos(2*alpha_4*pi/180)).^2.*(alpha_4>=0 & alpha_4<=45);   % ��alpha��[0,pi/4], or else C_T=0;
C_L_deng=C_N_deng.*cos(alpha_4*pi/180)-C_T_deng.*sin(alpha_4*pi/180);
C_D_deng=C_N_deng.*sin(alpha_4*pi/180)+C_T_deng.*cos(alpha_4*pi/180);
% figure(9)
% plot(alpha_4,C_L_dickinson,'r*',alpha_4,C_D_dickinson,'b*',alpha_4,C_N_deng,'k-',alpha_4,C_T_deng,'r-',alpha_4,C_L_deng,'g-',alpha_4,C_D_deng,'b-')
% grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (7) 2010-DSCC-Katie_Byl
% �򻯵�Ŀ���ǣ�
C_L_byl=1.8*sin(2*alpha_4*pi/180);
C_D_byl=1.8*(1-cos(2*alpha_4*pi/180));
% C_T_byl=0;  
C_N_byl=3.6*sin(alpha_4*pi/180);   % C_N_byl=sqrt(C_L_byl.^2+C_D_byl.^2);
% figure(10)
% plot(alpha_4,C_L_byl,'k-',alpha_4,C_D_byl,'b-',alpha_4,C_N_byl,'b-')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (8) ������ɭ����ǰԵ�������ⷨ����������ϵ������ģ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (9) 2014-JRSI-Nabawy
C_La2d=2*pi;    % ��λ��rad^(-1), ����2*pi (rad^(-1))= 0.11 (deg^(-1));   
lambda=0.755;
E=lambda*1.146071666;   % E=C/2/R;
k=1.51;  % ��Թ�Ӭ
AR=3.40158;     % ע�������չ�ұ�AR��(3,5)�ǱȽϺõġ�% ��Թ�Ӭ
C_La_Ny=C_La2d/(E+k*C_La2d/(pi*AR));     % �����������������ۻ�õ���ά�����������б��  % ���: C_La_Ny =2.7506;
C_L_nabawy=0.5*C_La_Ny*sin(2*alpha_4*pi/180);  
C_D_nabawy=C_La_Ny*(sin(alpha_4*pi/180)).^2;  
% �����ǲ���ǰԵ�������ⷨ�����Ĳ�����ɭ����ϵ��ģ��
C_L_polhamus1=(0.5*C_La_Ny*sin(2*alpha_4*pi/180)).*(cos(alpha_4*pi/180)+(1-k*C_La_Ny/(pi*AR)).*sin(alpha_4*pi/180)); 
% figure(11)
% plot(alpha_4,C_L_dickinson,'r*',alpha_4,C_D_dickinson,'b*',alpha_4,C_L_nabawy,'r-',alpha_4,C_D_nabawy,'b-',alpha_4,C_L_polhamus1,'g-')
% grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (10) 2014-AST-Taha
a_0=2*pi;
%  AR being based on one wing: AR=R^2/S;
AR=2.8;  % ע�������չ�ұ�AR��3�ǱȽϺõġ� 
C_La_Ta=pi*AR/(1+sqrt((pi*AR/a_0)^2+1));     % ����չ�����߻�õ���ά�����������б��   % ���:C_La_Ta =3.2334;
% C_L_taha=(0.5*pi*AR/(1+sqrt((pi*AR/a_0)^2+1))).*sin(2*alpha_4*pi/180);
C_L_taha=0.5*C_La_Ta*sin(2*alpha_4*pi/180);
C_D_taha=C_L_taha.*tan(alpha_4*pi/180);
% �����ǲ���ǰԵ�������ⷨ�����Ĳ�����ɭ����ϵ��ģ��
C_L_polhamus2=(0.5*C_La_Ta*sin(2*alpha_4*pi/180)).*(cos(alpha_4*pi/180)+(1-C_La_Ta/(pi*AR)).*sin(alpha_4*pi/180));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��һ���֡�������ϵ���ĶԱȷ���
figure(1)    %  subplot(224)
C_L=plot(alpha_4,C_L_dickinson,'k-',alpha_4,C_L_khan,'r--',...
                alpha_4,C_L_wang,'r-.',alpha_4,C_L_andersen,'r:',alpha_4,C_L_whitney,'b--',...
                alpha_4,C_L_deng,'b-.',alpha_4,C_L_byl,'b:',alpha_4,C_L_nabawy,'g--',alpha_4,C_L_polhamus1,'g-.',...
                alpha_4,C_L_taha,'g:',alpha_4,C_L_polhamus2,'m--');
xlabel('\it\alpha (deg.)')
ylabel('\it C_L (\alpha )')
title('Aerodynamic coefficients of lift \itvs. \alpha \rm for flapping wing')
legend('\itC_{L,dickinson}','\itC_{L,khan}','\itC_{L,wang}','\itC_{L,andersen}','\itC_{L,whitney}',...
             '\itC_{L,deng}','\itC_{L,byl}','\itC_{L,nabawy}','\itC_{L,polhamus1}','\itC_{L,taha}','\itC_{L,polhamus2}')
set(C_L,'LineWidth',2) 
grid on
%axis([xmin,xmax,ymin,ymax])
%% �ڶ����֡�������ϵ���ĶԱȷ���
figure(2)
C_D=plot(alpha_4,C_D_dickinson,'k-',alpha_4,C_D_khan,'r--',...
                alpha_4,C_D_wang,'r-.',alpha_4,C_D_andersen,'r:',alpha_4,C_D_whitney,'b--',...
                alpha_4,C_D_deng,'b-.',alpha_4,C_D_byl,'b:',alpha_4,C_D_nabawy,'g--',alpha_4,C_D_taha,'g-.');
xlabel('\it\alpha (deg.)')
ylabel('\it C_D (\alpha )')
title('Aerodynamic coefficients of drag \itvs. \alpha \rm for flapping wing')
legend('\itC_{D,dickinson}','\itC_{D,khan}','\itC_{D,wang}','\itC_{D,andersen}','\itC_{D,whitney}',...
              '\itC_{D,deng}','\itC_{D,byl}','\itC_{D,nabawy}','\itC_{D,taha}')
set(C_D,'LineWidth',2)  
grid on
%% ��������ʾ������趨
v_axis=axis;     %axis([xmin,xmax,ymin,ymax])
%Result: v_axis =  0   100     0     4
% v_axis(1)=0;          %ָ��x�����Сֵ
% v_axis(2)=100;      %ָ��x������ֵ
v_axis(3)=-0.5;          %ָ��y�����Сֵ
v_axis(4)=3.5;           %ָ��y������ֵ
axis(v_axis);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%