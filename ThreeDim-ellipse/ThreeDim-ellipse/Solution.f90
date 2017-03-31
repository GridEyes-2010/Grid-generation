 !���ģ��
module Solution
   
    use Phy_area_init
    implicit none
    type(vector),save::r_xi(imax,jmax,kmax),r_eta(imax,jmax,kmax),r_zeta(imax,jmax,kmax)
    !���ɷ���ϵ��
    real(kind=8),save::alpha1(imax,jmax,kmax),alpha2(imax,jmax,kmax),alpha3(imax,jmax,kmax)
    real(kind=8),save::beta12(imax,jmax,kmax),beta23(imax,jmax,kmax),beta31(imax,jmax,kmax)
    !��Ⲵ�ɷ������õĲ��ֵ
    real(kind=8),save::x_xi(imax,jmax,kmax),y_xi(imax,jmax,kmax),z_xi(imax,jmax,kmax)  
    real(kind=8),save::x_eta(imax,jmax,kmax),y_eta(imax,jmax,kmax),z_eta(imax,jmax,kmax)!
    real(kind=8),save::x_zeta(imax,jmax,kmax),y_zeta(imax,jmax,kmax),z_zeta(imax,jmax,kmax)
    real(kind=8),save::x_xieta(imax,jmax,kmax),y_xieta(imax,jmax,kmax),z_xieta(imax,jmax,kmax)
    real(kind=8),save::x_etazeta(imax,jmax,kmax),y_etazeta(imax,jmax,kmax),z_etazeta(imax,jmax,kmax)
    real(kind=8),save::x_zetaxi(imax,jmax,kmax),y_zetaxi(imax,jmax,kmax),z_zetaxi(imax,jmax,kmax)
   
    !�����õ����ڵ�����
    real(kind=8),save::x1(imax,jmax,kmax),y1(imax,jmax,kmax),z1(imax,jmax,kmax)
    !��Դ��ʱ�ģ��߽紦�ļ��ͼн�(����ֵ����ʵֵ)
    real(kind=8)::dr(imax,jmax,0:1)!theta_rxi(imax,jmax,0:1),theta_reta(imax,jmax,0:1)  !,dd(imax,jmax,0:1),theta_xz(imax,jmax,0:1),theta_ez(imax,jmax,0:1)
    !��Դ��ʱ�ģ��߽紦�ļ��ͼн�(��ʵֵ)
    real(kind=8)::dd(imax,jmax,0:1),theta_xz(imax,jmax,0:1),theta_ez(imax,jmax,0:1)
    !Ellipse��������ķ���ֵ�����ڿ���ѭ���Ƿ���ֹ
    integer,save::conv      
    !���������ѭ������        
    integer::iter                  
    integer::count
contains

subroutine Solve
    !��������������
    implicit none
   integer::i,j,k
   
   !*******************************************************
   !��ʼ����������
   call Coor_init 
   call Source_init
   call Coeff_cal
   
    count=0
    do while(.true.)
     call Expliit                    !���������������ֵ
     call Restrain_judge              !�жϱ߽��Ƿ�����Լ��������������Դ���������
     count = count +1                 !����һ��ѭ����1
     if(count==countmax) conv=1
     if(conv==1) then
         write(*,*) count,"����߽�Լ����" 
         exit
     else
         write(*,*) count,"δ����߽�Լ��������Դ��������㣡"
         call Source_cal
     end if
  end do
 
end subroutine

subroutine Coeff_cal
  
   !ŷ�����ɷ��̵�ϵ������
   implicit none
   integer::i,j,k
   
    !�������ϵ������
    !*******************************************  
    !xi
    do k=1,kmax
    do j=1,jmax  
    do i=2,imax-1
        x_xi(i,j,k)=(x(i+1,j,k)-x(i-1,j,k))/2
        y_xi(i,j,k)=(y(i+1,j,k)-y(i-1,j,k))/2
        z_xi(i,j,k)=(z(i+1,j,k)-z(i-1,j,k))/2
    end do
    end do
    end do
       !���ұ߽���xi�Ĳ��
    do k=1,kmax
    do j=1,jmax
        x_xi(1,j,k)=x(2,j,k)-x(1,j,k)
        y_xi(1,j,k)=y(2,j,k)-y(1,j,k)
        z_xi(1,j,k)=z(2,j,k)-z(1,j,k)
        x_xi(imax,j,k)=x(imax,j,k)-x(imax-1,j,k)
        y_xi(imax,j,k)=y(imax,j,k)-y(imax-1,j,k)
        z_xi(imax,j,k)=z(imax,j,k)-z(imax-1,j,k)
    end do
    end do
     !*******************************************  
    !eta 
    do k=1,kmax
    do j=2,jmax-1  
    do i=1,imax 
        x_eta(i,j,k)=(x(i,j+1,k)-x(i,j-1,k))/2
        y_eta(i,j,k)=(y(i,j+1,k)-y(i,j-1,k))/2
        z_eta(i,j,k)=(z(i,j+1,k)-z(i,j-1,k))/2
    end do
    end do
    end do
      !ǰ��߽���eta�Ĳ��
    do k=1,kmax
    do i=1,imax
        x_eta(i,1,k)=x(i,2,k)-x(i,1,k)
        y_eta(i,1,k)=y(i,2,k)-y(i,1,k)
        z_eta(i,1,k)=z(i,2,k)-z(i,1,k)
        x_eta(i,jmax,k)=x(i,jmax,k)-x(i,jmax-1,k)
        y_eta(i,jmax,k)=y(i,jmax,k)-y(i,jmax-1,k)
        z_eta(i,jmax,k)=z(i,jmax,k)-z(i,jmax-1,k)
    end do
    end do
    
   
    !�淨���ϵ������
    !*******************************************  
    !zeta
    do k=2,kmax-1
    do j=1,jmax  
    do i=1,imax
        x_zeta(i,j,k)=(x(i,j,k+1)-x(i,j,k-1))/2
        y_zeta(i,j,k)=(y(i,j,k+1)-y(i,j,k-1))/2
        z_zeta(i,j,k)=(z(i,j,k+1)-z(i,j,k-1))/2
    end do
    end do
    end do
    !���±߽�
    do j=1,jmax  
    do i=1,imax
        x_zeta(i,j,1)=x(i,j,2)-x(i,j,1)
        y_zeta(i,j,1)=y(i,j,2)-y(i,j,1)
        z_zeta(i,j,1)=z(i,j,2)-z(i,j,1)
        x_zeta(i,j,kmax)=x(i,j,kmax)-x(i,j,kmax-1)
        y_zeta(i,j,kmax)=y(i,j,kmax)-y(i,j,kmax-1)
        z_zeta(i,j,kmax)=z(i,j,kmax)-z(i,j,kmax-1)
    end do
    end do
 
    !***********************************************
    !���׵���
    !xieta
    do k=1,kmax
    do j=2,jmax-1  
    do i=1,imax
       ! x_xieta(i,j,k)=(x(i-1,j-1,k)-x(i-1,j+1,k)-x(i+1,j-1,k)+x(i+1,j+1,k))/4
       ! y_xieta(i,j,k)=(y(i-1,j-1,k)-y(i-1,j+1,k)-y(i+1,j-1,k)+y(i+1,j+1,k))/4
       ! z_xieta(i,j,k)=(z(i-1,j-1,k)-z(i-1,j+1,k)-z(i+1,j-1,k)+z(i+1,j+1,k))/4
       
        x_xieta(i,j,k)=(x_xi(i,j+1,k)-x_xi(i,j-1,k))/2
        y_xieta(i,j,k)=(y_xi(i,j+1,k)-y_xi(i,j-1,k))/2
        z_xieta(i,j,k)=(z_xi(i,j+1,k)-z_xi(i,j-1,k))/2
    end do
    end do
    end do
    !ǰ��߽�Ĵ���
    do k=1,kmax
    do i=2,imax-1
       x_xieta(i,1,k)=x_xi(i,2,k)-x_xi(i,1,k)
       y_xieta(i,1,k)=y_xi(i,2,k)-y_xi(i,1,k)
       z_xieta(i,1,k)=z_xi(i,2,k)-z_xi(i,1,k)
       x_xieta(i,jmax,k)=x_xi(i,jmax,k)-x_xi(i,jmax-1,k)
       y_xieta(i,jmax,k)=y_xi(i,jmax,k)-y_xi(i,jmax-1,k)
       z_xieta(i,jmax,k)=z_xi(i,jmax,k)-z_xi(i,jmax-1,k)
    end do
    end do
  
    !*************************************************
    !etazeta
    do k=2,kmax-1
    do j=1,jmax  
    do i=1,imax
        x_etazeta(i,j,k)=2*(x_eta(i,j,k+1)-2*x_eta(i,j,k-1))/2
        y_etazeta(i,j,k)=2*(y_eta(i,j,k+1)-2*y_eta(i,j,k-1))/2
        z_etazeta(i,j,k)=2*(z_eta(i,j,k+1)-2*z_eta(i,j,k-1))/2
    end do
    end do
    end do
    !���±߽�Ĵ���
    do j=1,jmax
    do i=1,imax
        x_etazeta(i,j,1)=x_eta(i,j,2)-x_eta(i,j,1)
        y_etazeta(i,j,1)=y_eta(i,j,2)-y_eta(i,j,1)
        z_etazeta(i,j,1)=z_eta(i,j,2)-z_eta(i,j,1)
        x_etazeta(i,j,kmax)=x_eta(i,j,kmax)-x_eta(i,j,kmax-1)
        y_etazeta(i,j,kmax)=y_eta(i,j,kmax)-y_eta(i,j,kmax-1)
        z_etazeta(i,j,kmax)=z_eta(i,j,kmax)-z_eta(i,j,kmax-1)
    end do
    end do
    !*************************************************
    !zetaxi  =xizeta
    !�����������߽�����е�
    do k=2,kmax-1
    do j=1,jmax  
    do i=1,imax
        x_zetaxi(i,j,k)=(x_xi(i,j,k+1)-x_xi(i,j,k-1))/2
        y_zetaxi(i,j,k)=(y_xi(i,j,k+1)-y_xi(i,j,k-1))/2
        z_zetaxi(i,j,k)=(z_xi(i,j,k+1)-z_xi(i,j,k-1))/2
    end do
    end do
    end do
    !���±߽�Ĵ���
    do j=1,jmax
    do i=1,imax
       x_zetaxi(i,j,1)=x_xi(i,j,2)-x_xi(i,j,1)
       y_zetaxi(i,j,1)=y_xi(i,j,2)-y_xi(i,j,1)
       z_zetaxi(i,j,1)=z_xi(i,j,2)-z_xi(i,j,1)
       x_zetaxi(i,j,kmax)=x_xi(i,j,kmax)-x_xi(i,j,kmax-1)
       y_zetaxi(i,j,kmax)=y_xi(i,j,kmax)-y_xi(i,j,kmax-1)
       z_zetaxi(i,j,kmax)=z_xi(i,j,kmax)-z_xi(i,j,kmax-1)
    end do
    end do
    !******************************************* 
    !������
    r_xi(:,:,:)%x=x_xi(:,:,:)
    r_xi(:,:,:)%y=y_xi(:,:,:)
    r_xi(:,:,:)%z=z_xi(:,:,:)
    
    r_eta(:,:,:)%x=x_eta(:,:,:)
    r_eta(:,:,:)%y=y_eta(:,:,:)
    r_eta(:,:,:)%z=z_eta(:,:,:)
    
    r_zeta(:,:,:)%x=x_zeta(:,:,:)
    r_zeta(:,:,:)%y=y_zeta(:,:,:)
    r_zeta(:,:,:)%z=z_zeta(:,:,:)
    
    !*************************************************
    !���е��ϵļ�����������
    do k=1,kmax
    do j=1,jmax
    do i=1,imax
       alpha1(i,j,k) =pow2(r_eta(i,j,k) )  *  pow2(r_zeta(i,j,k) ) -(r_eta(i,j,k) * r_zeta(i,j,k) )**2
       alpha2(i,j,k) =pow2(r_zeta(i,j,k)) *  pow2(r_xi(i,j,k)) -(r_zeta(i,j,k) * r_xi(i,j,k) )**2
       alpha3(i,j,k) =pow2(r_xi(i,j,k)) *  pow2(r_eta(i,j,k))  - ( r_xi(i,j,k) * r_eta(i,j,k) )**2
       beta12(i,j,k) =( r_xi(i,j,k)*r_zeta(i,j,k) )* ( r_zeta(i,j,k)*r_eta(i,j,k) ) -(r_xi(i,j,k)*r_eta(i,j,k)) *pow2(r_zeta(i,j,k))
       beta23(i,j,k) =( r_eta(i,j,k)*r_xi(i,j,k) )* ( r_xi(i,j,k)*r_zeta(i,j,k) )-(r_eta(i,j,k)*r_zeta(i,j,k)) *pow2(r_xi(i,j,k))
       beta31(i,j,k) =( r_zeta(i,j,k)*r_eta(i,j,k) )* ( r_eta(i,j,k)*r_xi(i,j,k) )-(r_zeta(i,j,k)*r_xi(i,j,k)) *pow2(r_eta(i,j,k))
   ! write(*,*)  pow2(r_eta(i,j,k) ) , pow2(r_zeta(i,j,k) )
    end do
    end do
    end do
    !************************************************
    
    !do j=1,jmax
    !do i=1,imax  
    !write(*,*) alpha1(i,j,k),alpha2(i,j,k),alpha3(i,j,k),beta12(i,j,k)
    !end do
    !end do
    !write(*,*)  "521"
    !stop
   
end subroutine     

 subroutine Expliit  !��ʽ���x1��y1��z1
    implicit none 
    integer::flag
    integer::i,j,k
    !***************************************************  
 do iter=1,itermax
  do k=2,kmax-1  
  do j=2,jmax-1
  do i=2,imax-1
     x1(i,j,k)=0.5/(alpha1(i,j,k)+alpha2(i,j,k)+alpha3(i,j,k))* &
               &( alpha1(i,j,k)*(x(i-1,j,k)+x(i+1,j,k))+alpha1(i,j,k)*phi_p(i,j,k)*x_xi(i,j,k) + &
               &  alpha2(i,j,k)*(x(i,j-1,k)+x(i,j+1,k))+alpha2(i,j,k)*phi_q(i,j,k)*x_eta(i,j,k)+ &
               &  alpha3(i,j,k)*(x(i,j,k-1)+x(i,j,k+1))+alpha3(i,j,k)*phi_r(i,j,k)*x_zeta(i,j,k)  + &
               &  2*(beta12(i,j,k)*x_xieta(i,j,k)+beta23(i,j,k)*x_etazeta(i,j,k)+beta31(i,j,k)*x_zetaxi(i,j,k) )  )
     y1(i,j,k)=0.5/(alpha1(i,j,k)+alpha2(i,j,k)+alpha3(i,j,k))* &
               &( alpha1(i,j,k)*(y(i-1,j,k)+y(i+1,j,k))+alpha1(i,j,k)*phi_p(i,j,k)*y_xi(i,j,k) + &
               &  alpha2(i,j,k)*(y(i,j-1,k)+y(i,j+1,k))+alpha2(i,j,k)*phi_q(i,j,k)*y_eta(i,j,k)+ &
               &  alpha3(i,j,k)*(y(i,j,k-1)+y(i,j,k+1))+alpha3(i,j,k)*phi_r(i,j,k)*y_zeta(i,j,k)  + &
               &  2*(beta12(i,j,k)*y_xieta(i,j,k)+beta23(i,j,k)*y_etazeta(i,j,k)+beta31(i,j,k)*y_zetaxi(i,j,k) )  )
     z1(i,j,k)=0.5/(alpha1(i,j,k)+alpha2(i,j,k)+alpha3(i,j,k))* &
               &( alpha1(i,j,k)*(z(i-1,j,k)+z(i+1,j,k))+alpha1(i,j,k)*phi_p(i,j,k)*z_xi(i,j,k) + &
               &  alpha2(i,j,k)*(z(i,j-1,k)+z(i,j+1,k))+alpha2(i,j,k)*phi_q(i,j,k)*z_eta(i,j,k)+ &
               &  alpha3(i,j,k)*(z(i,j,k-1)+z(i,j,k+1))+alpha3(i,j,k)*phi_r(i,j,k)*z_zeta(i,j,k)  + & 
               &  2*(beta12(i,j,k)*z_xieta(i,j,k)+beta23(i,j,k)*z_etazeta(i,j,k)+beta31(i,j,k)*z_zetaxi(i,j,k) )  )
  end do
  end do 
  end do
  
    !*************************************************************
    !�����ж�
    !����û�����㾫��Ҫ�������㣬�Ͱѱ����Ϊ0
     flag=1
  do k=2,kmax-1
  do j=2,jmax-1
  do i=2,imax-1
      !�ж��Ƿ���������Ҫ��
      if(abs(x1(i,j,k)-x(i,j,k))>eps .or. abs(y1(i,j,k)-y(i,j,k))>eps .or.  abs(z1(i,j,k)-z(i,j,k))>eps)  then
         flag=0
         exit
      end if   
  end do
  end do
  end do
  
  !��������Ҫ������ѭ���������������
  if (flag==1) exit        !
  
  !**********************************************
  !�߽���������,��ȥ���±߽�
  !ǰ��߽�
  do k=2,kmax-1
  do i=1,imax
      x1(i,1,k)=2*x1(i,2,k)-x1(i,3,k)
      y1(i,1,k)=2*y1(i,2,k)-y1(i,3,k)
      z1(i,1,k)=2*z1(i,2,k)-z1(i,3,k)
      x1(i,jmax,k)=2*x1(i,jmax-1,k)-x1(i,jmax-2,k)
      y1(i,jmax,k)=2*y1(i,jmax-1,k)-y1(i,jmax-2,k)
      z1(i,jmax,k)=2*z1(i,jmax-1,k)-z1(i,jmax-2,k)
  end do
  end do
  
  !���ұ߽�
  do k=2,kmax-1
  do j=2,jmax-1
      x1(1,j,k)=2*x1(2,j,k)-x1(3,j,k)
      y1(1,j,k)=2*y1(2,j,k)-y1(3,j,k)
      z1(1,j,k)=2*z1(2,j,k)-z1(3,j,k)
      x1(imax,j,k)=2*x1(imax-1,j,k)-x1(imax-2,j,k)
      y1(imax,j,k)=2*y1(imax-1,j,k)-y1(imax-2,j,k)
      z1(imax,j,k)=2*z1(imax-1,j,k)-z1(imax-2,j,k)
  end do
  end do
    
   !*********************************************** 
   !��������������
     x(:,:,2:kmax-1)=x(:,:,2:kmax-1)+omg*(x1(:,:,2:kmax-1)-x(:,:,2:kmax-1))
     y(:,:,2:kmax-1)=y(:,:,2:kmax-1)+omg*(y1(:,:,2:kmax-1)-y(:,:,2:kmax-1))
     z(:,:,2:kmax-1)=z(:,:,2:kmax-1)+omg*(z1(:,:,2:kmax-1)-z(:,:,2:kmax-1))
     
     !����ϵ������
     call Coeff_Cal
     
 end do
    write(*,*)   iter,"����"
 
 end subroutine
 

subroutine  Restrain_judge   !�߽�Լ�������ж�
    implicit none
    integer::i,j,k
    integer::flag,flag1,flag2,flag3,flag4,flag5,flag6
   
    
  !�߽�������ֵ
     dr(:,:,0)=dd_inner
     dr(:,:,1)=dd_outer  
     
  !****************************************************  
  !�߽����ͼн�ʵ��ֵ���м���  
  ! �ڱ߽�
  do j=1,jmax
  do i=1,imax
     !dd(i,j,0)=sqrt((r(i,j,k+1)-r(i,j,k))**2)
     !theta_xz(i,j,0)=acos((x_xi(i,j,k)*x_zeta(i,j,k))+y_xi(i,j,k)*y_zeta(i,j,k)+z_xi(i,j,k)*z_zeta(i,j,k))/(sqrt(x_xi(i,j,k)**2+y_xi(i,j,k)**2+z_xi(i,j,k)**2)+sqrt(x_zeta(i,j,k)**2+y_zeta(i,j,k)**2+z_zeta(i,j,k)**2)))
     !theta_ez(i,j,0)=acos((x_eta(i,j,k)*x_zeta(i,j,k))+y_eta(i,j,k)*y_zeta(i,j,k)+z_eta(i,j,k)*z_zeta(i,j,k))/(sqrt(x_eta(i,j,k)**2+y_eta(i,j,k)**2+z_eta(i,j,k)**2)+sqrt(x_zeta(i,j,k)**2+y_zeta(i,j,k)**2+z_zeta(i,j,k)**2)))
     dd(i,j,0)=sqrt(pow2(r_zeta(i,j,1)))
     theta_xz(i,j,0)=acos((r_xi(i,j,1)*r_zeta(i,j,1))/(sqrt(pow2(r_xi(i,j,1)))*sqrt(pow2(r_zeta(i,j,1))) ) )
     theta_ez(i,j,0)=acos((r_eta(i,j,1)*r_zeta(i,j,1))/(sqrt(pow2(r_eta(i,j,1)))*sqrt(pow2(r_zeta(i,j,1))) ) )
     
     if(abs(dd(i,j,0)-dr(i,j,0))>eps1)  flag1=0
     if(abs(theta_xz(i,j,0)-theta_rxz)>eps3)  flag2=0
     if(abs(theta_ez(i,j,0)-theta_rez)>eps3)  flag3=0
  end do
  end do
 
  ! ��߽�
  do j=1,jmax
  do i=1,imax  
     !dd(i,j,1)=sqrt((r(i,j,k)-r(i,j,k-1))**2)
     !theta_xz(i,j,1)=acos((x_xi(i,j,k)*x_zeta(i,j,k))+y_xi(i,j,k)*y_zeta(i,j,k)+z_xi(i,j,k)*z_zeta(i,j,k))/(sqrt(x_xi(i,j,k)**2+y_xi(i,j,k)**2+z_xi(i,j,k)**2)+sqrt(x_zeta(i,j,k)**2+y_zeta(i,j,k)**2+z_zeta(i,j,k)**2)))
     !theta_ez(i,j,1)=acos((x_eta(i,j,k)*x_zeta(i,j,k))+y_eta(i,j,k)*y_zeta(i,j,k)+z_eta(i,j,k)*z_zeta(i,j,k))/(sqrt(x_eta(i,j,k)**2+y_eta(i,j,k)**2+z_eta(i,j,k)**2)+sqrt(x_zeta(i,j,k)**2+y_zeta(i,j,k)**2+z_zeta(i,j,k)**2)))
     dd(i,j,1)=sqrt(pow2(r_zeta(i,j,kmax)))
     theta_xz(i,j,1)=acos((r_xi(i,j,kmax)*r_zeta(i,j,kmax))/(sqrt(pow2(r_xi(i,j,kmax)))*sqrt(pow2(r_zeta(i,j,kmax))) )  )
     theta_ez(i,j,1)=acos((r_eta(i,j,kmax)*r_zeta(i,j,kmax))/(sqrt(pow2(r_eta(i,j,kmax)))*sqrt(pow2(r_zeta(i,j,kmax))) ) )
     if(abs(dd(i,j,1)-dr(i,j,1))>eps1)  flag4=0
     if(abs(theta_xz(i,j,1)-theta_rxz)>eps3)  flag5=0
     if(abs(theta_ez(i,j,1)-theta_rez)>eps3)  flag6=0
  end do
  end do
   
  flag=flag1*flag2*flag3*flag4*flag5*flag6
  if(flag==1) then
      conv=1
  else
      conv=0
  end if
     
end subroutine

subroutine Source_cal
    implicit none
    integer::i,j,k
     
 !���ݱ߽紦Լ�����������Դ��
  do j=1,jmax
  do i=1,imax  
     phi_p(i,j,1)=phi_p(i,j,1) - sigma*atan(theta_rxz-theta_xz(i,j,0))
     phi_q(i,j,1)=phi_q(i,j,1) - sigma*atan(theta_rez-theta_ez(i,j,0))
     phi_r(i,j,1)=phi_r(i,j,1) + sigma*atan(dr(i,j,0)-dd(i,j,0))
     phi_p(i,j,kmax)=phi_p(i,j,kmax) + sigma*atan(theta_rxz-theta_xz(i,j,1))
     phi_q(i,j,kmax)=phi_q(i,j,kmax) + sigma*atan(theta_rez-theta_ez(i,j,1))
     phi_r(i,j,kmax)=phi_r(i,j,kmax) - sigma*atan(dr(i,j,1)-dd(i,j,1))
  end do
  end do
 
     !�ڵ�Դ�����
  do k=2,kmax-1
  do j=1,jmax
  do i=1,imax
       phi_p(i,j,k)=phi_p(i,j,1)*exp(-a*(k-1))-phi_p(i,j,kmax)*exp(-b*(kmax-k))
       phi_q(i,j,k)=phi_q(i,j,1)*exp(-c*(k-1))-phi_q(i,j,kmax)*exp(-d*(kmax-k))
       phi_r(i,j,k)=phi_r(i,j,1)*exp(-e*(k-1))-phi_r(i,j,kmax)*exp(-f*(kmax-k))
  end do
  end do
  end do
  
end subroutine

end module


   
        
   
   
    