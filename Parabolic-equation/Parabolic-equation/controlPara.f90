module controlPara
    
    implicit none
    integer,parameter::Mx=10,My=40
    real(8),parameter::eps=10E-8,eps2=2E-20
    real(8),parameter::thick=2E-5,angle=1.57079663,growthRate=1.2!Ԥ��ĸ����ߺͽǶȣ��˴����ԸĽ�,epsΪԴ��ȷ��֮��ĵ������ȣ�eps2ΪԴ��ľ���
    real(8),parameter::a=0.5,b=0.5,c=0.5,d=0.5,sigama=0.30!0.3   !Դ��Ĳ�����ֵ
    real,parameter::steps=300   !��˳
    
end module
