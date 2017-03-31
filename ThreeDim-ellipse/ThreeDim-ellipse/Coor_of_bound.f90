module Coor_of_bound  
    !�������񻮷�ģ��
    use Control
    implicit none
    !�߽�����������������
    real(kind=8)::x_bound(imax,jmax,0:1),y_bound(imax,jmax,0:1),z_bound(imax,jmax,0:1) 
    
contains


subroutine Bound               !O�������ڱ߽�������Ķ�ȡ
    implicit none
    integer,parameter::fileid=10  !�ļ����
    character(len=80)::filename  !�ļ���
    integer::error              !��ȡ�����Ƿ�ɹ��ж�
    logical::alive              !��ѯ�ļ��Ƿ�����ж�
    integer::i,j,k                  !�ڱ߽�����ѭ������y=0
    
    !write(*,*)  "Filename:"         
    !read(*,"(A80)") filename       !����Ҫ��ȡ���ļ���
    
    !��ȡ�ڱ߽�����
    filename="inner.dat"
    inquire(file=filename,exist=alive)    
    if(.not.alive) then
        write(*,*) trim(filename),"Does't exist!"   
        stop
    end if
    
    open(fileid,file=filename,action='read',status='old')
    do k=1,kmax
    do j=1,jmax
    do i=1,imax
        read(fileid,"(F10.8,4X,F9.8)",iostat=error) x_bound(i,j,0),y_bound(i,j,0),z_bound(i,j,0) !����9λ��Ч���֣�8λС���ĸ�ʽ��ȡ

        if(error/=0) then
           write(*,*) "error,��ȡ����"
           exit
        end if 
    end do
    end do
    end do
    close(fileid)
    
    !��ȡ��߽�����
     filename="outer.dat"
    inquire(file=filename,exist=alive)    
    if(.not.alive) then
        write(*,*) trim(filename),"Does't exist!"   
        stop
    end if
    
    open(fileid,file=filename,action='read',status='old')
    do k=1,kmax
    do j=1,jmax
    do i=1,imax
        read(fileid,"(F10.8,4X,F9.8)",iostat=error) x_bound(i,j,1),y_bound(i,j,1),z_bound(i,j,1) !����9λ��Ч���֣�8λС���ĸ�ʽ��ȡ

        if(error/=0) then
           write(*,*) "error,��ȡ����"
           exit
        end if 
    end do
    end do
    end do
    close(fileid)
      
end subroutine

end module



    
         
        