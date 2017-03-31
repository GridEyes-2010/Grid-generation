
module Phy_area_init
    !�����һ�����꣬Դ��ƽ������ĳ�ʼ��ģ��
    use Control
    use r_oper
!    use Coor_of_bound
    implicit none
    
    !����߽���������
    type(vector),save::r(imax,jmax,kmax)
    !����߽�����
    real(kind=8),save::x(imax,jmax,kmax),y(imax,jmax,kmax) ,z(imax,jmax,kmax)  
    !Դ��ֵ������һ��x,y,z��
    real(kind=8),save::phi_p(imax,jmax,kmax),phi_q(imax,jmax,kmax),phi_r(imax,jmax,kmax) 
    !ÿһ����������ƽ�Ԥ�ȸ�������
     real(kind=8),save::lk_init(kmax)     
    
contains 

subroutine Coor_Init    
    !�����������ʼ��
    implicit none
    integer::i,j
    
     !��ʼ���߽�����
    !x(:,:,1)=x_bound(:,:)
    !y(:,:,1)=y_bound(:,:)
    !z(:,:,1)=z_bound(:,:) 
    do j=1,jmax
    do i=1,imax
        
      x(i,j,1)=1.0/(imax-1)*(i-1)
      y(i,j,1)=1.0/(jmax-1)*(j-1)
      z(i,j,1)=0.0
    ! z(i,j,1)=-0.5*x(i,j,1)**3+2*y(i,j,1)**2-x(i,j,1)
    end do
    end do
    r(:,:,1)%x=x(:,:,1)
    r(:,:,1)%y=y(:,:,1)
    r(:,:,1)%z=z(:,:,1)
    
end subroutine

subroutine Inc_len_Init
    implicit none
    integer::k
    
    lk_init(2)=d1
    do k=3,kmax
      lk_init(k)=lk_init(k-1)*lk_ratio
    end do
end subroutine

subroutine Source_Init
    implicit none 
    
        phi_p(:,:,1)   =0.0
        phi_q(:,:,1)   =0.0
        phi_r(:,:,1)   =0.0
        phi_p(:,:,3)   =0.0
        phi_q(:,:,3)   =0.0
        phi_r(:,:,3)   =0.0
       
end subroutine

end module

