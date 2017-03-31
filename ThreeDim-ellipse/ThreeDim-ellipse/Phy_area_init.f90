 !�����������ʼ��
module Phy_area_init  
    use Control
    use r_oper
   ! use Coor_of_bound
    implicit none
    
    !����߽���������
    type(vector),save::r(imax,jmax,kmax)
    !����߽�����
    real(kind=8),save::x(imax,jmax,kmax),y(imax,jmax,kmax) ,z(imax,jmax,kmax)  
    !Դ��ֵ������һ��x,y,z��
    real(kind=8),save::phi_p(imax,jmax,kmax),phi_q(imax,jmax,kmax),phi_r(imax,jmax,kmax)      
    
contains 

subroutine Coor_init    
    !�����������ʼ��
    implicit none
    integer::i,j,k
    integer,parameter::fileid=10  !�ļ����
    character(len=80)::filename  !�ļ���
    integer::error              !��ȡ�����Ƿ�ɹ��ж�
    logical::alive              !��ѯ�ļ��Ƿ�����ж�
   
    
     !��ʼ���߽�����
    !x(:,:,1)=x_bound(:,:)
    !y(:,:,1)=y_bound(:,:)
    !z(:,:,1)=z_bound(:,:) 
    
    filename="Coordinate.dat"
    inquire(file=filename,exist=alive)    
    if(.not.alive) then
        write(*,*) trim(filename),"Does't exist!"   
        stop
    end if
    
    open(fileid,file=filename,action='read',status='old')
    do k=1,kmax
    do j=1,jmax
    do i=1,imax
        read(fileid,"(2X,F11.8,2X,F11.8,2X,F11.8)",iostat=error) x(i,j,k),y(i,j,k),z(i,j,k) !����11λ��ȣ�8λС���ĸ�ʽ��ȡ

        if(error/=0) then
           write(*,*) "error,��ȡ����"
           exit
        end if 
    end do
    end do 
    end do
    close(fileid)
    
  
    r(:,:,:)%x=x(:,:,:)
    r(:,:,:)%y=y(:,:,:)
    r(:,:,:)%z=z(:,:,:)
    
end subroutine


subroutine Source_init
    implicit none 
    integer::i,j,k
    
    phi_p(:,:,:)   =0.0
    phi_q(:,:,:)   =0.0
    phi_r(:,:,:)   =0.0
  
end subroutine

end module

