module Coor_of_bound  
    !�������񻮷�ģ��
    use Control
    implicit none
    !real(kind=8),parameter::pi=3.14159265
    !integer,parameter::imax=133,jmax=60    !�����������������,��o������imaxΪ������
    !integer,parameter::imax=201,jmax=60   !�����������������,��c������imaxΪ������
    !c����������
    !real(kind=8),parameter::x_left=-6,x_right=6    !������x�����ҷ�Χ
    !real(kind=8),parameter::y_bottom=-4,y_top=4    !������y�����·�Χ
    !o����������
    !real(kind=8),parameter::R_outer=6.0
    real(kind=8)::x_bound(imax,jmax),y_bound(imax,jmax),z_bound(imax,jmax)  !�߽�����������������(��ά)
    
contains


subroutine Inner_O                !O�������ڱ߽�������Ķ�ȡ
    implicit none
    integer,parameter::fileid=10  !�ļ����
    character(len=80)::filename  !�ļ���
    integer::error              !��ȡ�����Ƿ�ɹ��ж�
    logical::alive              !��ѯ�ļ��Ƿ�����ж�
    integer::i                  !�ڱ߽�����ѭ������y=0
    
    !write(*,*)  "Filename:"         
    !read(*,"(A80)") filename       !����Ҫ��ȡ���ļ���

    filename="naca0012_O.txt"
    inquire(file=filename,exist=alive)    
    if(.not.alive) then
        write(*,*) trim(filename),"Does't exist!"   
        stop
    end if
    
    open(fileid,file=filename,action='read',status='old')
    do i=1,imax
        read(fileid,"(F10.8,4X,F9.8)",iostat=error) x_inner(i),y_inner(i)  !����9λ��Ч���֣�8λС���ĸ�ʽ��ȡ
        if(error/=0) then
           write(*,*) "error,��ȡ����"
           exit
        end if 
     !   x_outer(i)= x_outer(i)-Center
    end do
    close(fileid)
   
      
end subroutine

subroutine Outer_O          !���ﲻ��Ҫ��ȡ����Ҫ���м��λ��֣����õȽǶȻ���
    implicit none           !�ѿ��������������򼸺�����
    integer::i
    
    do i=1,imax
        x_outer(i)=R_outer*cos(2*pi/(imax-1)*(i-1))
        y_outer(i)=R_outer*sin(2*pi/(imax-1)*(i-1))
    end do
    
end subroutine

subroutine Inner_C               !O�������ڱ߽�������Ķ�ȡ
    implicit none
    integer::airfoil_num=131
    integer::traiedge_num
    integer,parameter::fileid=10  !�ļ����
    character(len=80)::filename   !�ļ���
    integer::error                !��ȡ�����Ƿ�ɹ��ж�
    logical::alive                !��ѯ�ļ��Ƿ�����ж�
    integer::i                    !�ڱ߽�����ѭ������y=0
    
    !�ڱ߽��Ե���ұ߽�Ĳ�ֵ(�������Բ�ֵ����ȱ�㣬���Բ���ָ����ֵ)
    traiedge_num=(imax-airfoil_num)/2
    do i=1,traiedge_num
        x_inner(i)=x_right-(x_right-1.0084)/(traiedge_num-1)*(i-1)!��ȥ1.01�ǽ�������΢���ӳ�һ��
        y_inner(i)=0.0
        x_inner(imax+1-i)=x_inner(i)
        y_inner(imax+1-i)=y_inner(i)
    end do
    
    !�������ͱ߽�����
    !write(*,*)  "Filename:"         
    !read(*,"(A80)") filename       !����Ҫ��ȡ���ļ���
    filename="naca0012_C.txt"
    
    inquire(file=filename,exist=alive)    
    if(.not.alive) then
        write(*,*) trim(filename),"Does't exist!"   
        stop
    end if
    
    open(fileid,file=filename,action='read',status='old')
    do i=traiedge_num+1,traiedge_num+airfoil_num
        read(fileid,"(F10.8,4X,F11.8)",iostat=error) x_inner(i),y_inner(i)  !����9Ϊ��Ч���֣�8λС���ĸ�ʽ��ȡ
        if(error/=0) then
           write(*,*) "error,��ȡ����"
           exit
        end if
    end do
    close(fileid)
    
    
end subroutine

subroutine Outer_C            !���ﲻ��Ҫ��ȡ����Ҫ���м��λ��֣����õȻ��Ȼ���
    implicit none           !�ѿ��������������򼸺�����
    !real,parameter::r=2    !Բ���뾶
    integer::arc_num     !����Բ�����ַ������������
    integer::bottom_num  !�ײ���߽���������
    integer::left_num  !���²���߽���������
    integer::i,i2,i3,i4,i5
    arc_num=(imax+1)/2*(0.5*pi*r/(abs(x_right)+abs(x_left)-r+abs(y_bottom)-r+0.5*pi*r))  !imax+1֮����ż������
    left_num=anint(((imax+1)/2-arc_num)*((abs(y_bottom)-r)/(abs(x_right)+abs(x_left)-r+abs(y_bottom)-r)))  !����ӽ�������ȡ��
    bottom_num=(imax+1)/2-arc_num-left_num
    i2=bottom_num
    i3=bottom_num+arc_num
    i4=bottom_num+arc_num+left_num
    !write(*,*) i2,i3,i4,bottom_num,arc_num,left_num
    do i=1,i2
        x_outer(i)=x_right-(i-1)*(abs(x_right)+abs(x_left)-r)/bottom_num
        y_outer(i)=y_top
    end do
    do i=i2+1,i3
        x_outer(i)=x_left+r-r*sin(pi/4.0/arc_num*(i-i2))
        y_outer(i)=y_top-r+r*cos(pi/4.0/arc_num*(i-i2))
    end do
    do i=i3+1,i4
        x_outer(i)=x_left
        y_outer(i)=y_top-r-(abs(y_top)-r)/left_num*(i-i3)
    end do
    
    !���������������߽�Գƣ����Բ�ȡ�ԳƸ�ֵ
    do i=imax,imax/2,-1            
        x_outer(i)=x_outer(imax-i+1)
        y_outer(i)=-y_outer(imax-i+1)
    end do
    
end subroutine

end module



    
         
        