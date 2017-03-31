module boundCoor   !determine the x and y coordinates on the boundaries 
    use controlData
    implicit none
    real(8),dimension(imax)::x_inner,y_inner , &  !coordinates of points on the inside boundary 
                             x_outer,y_outer      !coordinates of points on the outside boundary
    real(8),dimension(jmax)::x_l,y_l , &  !coordinates of points on the inside boundary 
                             x_r,y_r      !coordinates of points on the outside boundary
contains

subroutine inside               !read points coordinats 
    implicit none
   
    integer::traiedge_num
    integer,parameter::fileid=10  !file id
    character(len=80)::filename   !�ļ���
    integer::error , &            !return value of wheather the file is readed correctly
             alive                !return value of wheather the file exist
    integer::i                    
 
    !write(*,*)  "Filename:"         
    !read(*,"(A80)") filename       
  

    traiedge_num=(imax-aerofoil_num)/2  !the index of the trailing edge of the aerofoil  
     
    filename="naca0012.dat"
    inquire(file=filename,exist=alive)     
    
    if(.not.alive) then
        write(*,*) trim(filename),"Does't exist !"   
        stop "Insure the file exist ! "
    end if
    
    open(fileid,file=filename,action='read',status='old')
    do i=traiedge_num+aerofoil_num,traiedge_num+1,-1
        read(fileid,*,iostat=error) x_inner(i),y_inner(i)  !����9Ϊ��Ч���֣�8λС���ĸ�ʽ��ȡ
        if(error/=0) then
           write(*,*) "Read Error!"
           stop "Make sure both the read-format and the data are correct !"
        end if  
        x_inner(i)=x_inner(i)-Center   
    end do
    close(fileid)
       
    !linear interpolation 
   
    do i=1,traiedge_num
        x_inner(i)= x_right*exp(-0.15*(i-1) )
        y_inner(i)= y_inner(traiedge_num + 1 )
        x_inner(imax+1-i) =  x_inner(i)
        y_inner(imax+1-i) = -y_inner(i)
    end do
    
end subroutine

subroutine outside          !���ﲻ��Ҫ��ȡ����Ҫ���м��λ��֣����õȻ��Ȼ���
    implicit none             !�ѿ��������������򼸺�����
    integer::i,i2,i3

    i2=(imax-aerofoil_num)/2 + 1
    i3 = i2 + (aerofoil_num-1 )/2
  
    do i=1,i2
        x_outer(i) = x_inner(i)
        y_outer(i) = y_top
        x_outer(imax+1-i) =  x_outer(i)
        y_outer(imax+1-i) = -y_outer(i)
    end do
    
    do i=i2+1,i3
        x_outer(i)=-r*sin( pi/2*exp( 0.05*(i-i3) ) )
        y_outer(i)= r*cos( pi/2*exp( 0.05*(i-i3) ) )
        
        x_outer(imax+1-i)= x_outer(i)
        y_outer(imax+1-i)= -y_outer(i)
    end do
  
    !���������������߽�Գƣ����Բ�ȡ�ԳƸ�ֵ
    
end subroutine

subroutine leftRight          !���ﲻ��Ҫ��ȡ����Ҫ���м��λ��֣����õȻ��Ȼ���
    implicit none             !�ѿ��������������򼸺�����
    integer::j

    do j=2,jmax
        x_l(j) = x_right
        y_l(j) = ( y_top - y_inner(1) )*exp( 0.1*(j-jmax) ) + y_inner(1)
        x_r(j) =  x_right
        y_r(j) = -y_l(j)
    end do
    
  
    !���������������߽�Գƣ����Բ�ȡ�ԳƸ�ֵ
    
end subroutine


end module



    
         
        