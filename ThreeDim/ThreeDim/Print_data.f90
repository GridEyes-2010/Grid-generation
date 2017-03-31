module Print_data
    use Solution
    implicit none
    
contains
subroutine output
    implicit none
    integer::i,j,k
    integer,parameter::fileid=7
    
    !**************************************
    !����ڱ߽�x��y����
    !open(fileid,file="x_inner.txt")
    !write(fileid,"(I3,3X,F11.8,3X,F11.8)") (i,x_inner(i),y_inner(i),i=1,imax) 
    
    !�����߽�x��y����
    !open(fileid,file="x_outer.txt")
    !write(fileid,"(I3,3X,F11.8,3X,F11.8)")  (i,x_outer(i),y_outer(i),i=1,imax)
    !write(fileid,"(F11.8,3X,F11.8,3X,F11.8,3X,F11.8)")  (x_outer(i,jmax),y_outer(i,jmax),x_outer(imax-i+1,jmax),y_outer(imax-i+1,jmax),i=1,(imax+1)/2)
    !write(*,"(F5.2,3X,F5.2)")(x_outer(i,jmax),y_outer(i,jmax),i=1,imax)
    !******************************************
    
    !������������е��x,y��ʼ��ֵ��p,q�ĳ�ʼ��ֵ
    
    !���x,y,z����
    open(fileid,file="X_Y_Z.dat")
    write(fileid,*)  'VARIABLES="X","Y","Z"'
    write(fileid,"(2X,A7,I2,A3,I2,A3,I2)")  "zone I=",imax,",J=",jmax,",K=",kmax-1
    write(fileid,"(2X,F11.8,2X,F11.8,2X,F11.8)") (((x(i,j,k),y(i,j,k),z(i,j,k),i=1,imax),j=1,jmax),k=1,kmax-1)
   ! write(fileid,"(F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8)") ((x(i,j),y(i,j),i=1,imax),j=1,jmax)
    close(fileid) 
    
     open(fileid,file="Lk.dat")
     write(fileid,"(2X,F11.8)") (lk_init(k),k=2,kmax-1)
   ! write(fileid,"(F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8,2X,F11.8)") ((x(i,j),y(i,j),i=1,imax),j=1,jmax)
    close(fileid) 
    
    !���Դ��ֵ
    !open(fileid,file="p_q.txt")
    !write(fileid,"(I3,2X,I3,2X,F12.8,2X,F12.8)") ((i,j,p(i,j),q(i,j),i=1,imax),j=1,jmax)
    !close(fileid) 
    !**************************************************************************
    
    !�����xi,eta�ĵ���
    open(fileid,file="r_xi.dat")
    write(fileid,"(I3,2X,I3,2X,I3,2X,F12.8,2X,F12.8,2X,F12.8)") (((i,j,k,x_xi(i,j,k),y_xi(i,j,k),z_eta(i,j,k),i=1,imax),j=1,jmax),k=2,kmax-1)
    close(fileid)
    
    !�����eta�ĵ���
    open(fileid,file="r_eta.dat")
    write(fileid,"(I3,2X,I3,2X,I3,2X,F12.8,2X,F12.8,2X,F12.8)") (((i,j,k,x_eta(i,j,k),y_eta(i,j,k),z_eta(i,j,k),i=1,imax),j=1,jmax),k=2,kmax-1)

    close(fileid)
   
    
    !�����zeta�ĵ���
    open(fileid,file="r_zeta.dat")
    write(fileid,"(I3,2X,I3,2X,I3,2X,F12.8,2X,F12.8,2X,F12.8)") (((i,j,k,x_zeta(i,j,k),y_zeta(i,j,k),z_zeta(i,j,k),i=1,imax),j=1,jmax),k=2,kmax-1)
    close(fileid) 
      
    !�����xieta�ĵ���
    ! open(fileid,file="x_xieta.txt")
    ! write(fileid,"(I3,2X,I3,2X,F12.8,2X,F12.8,,2X,F12.8)") (((i,j,x_xieta(i,j,k),y_xieta(i,j,k),z_xieta(i,j,k),i=1,imax),j=1,jmax),k=2,kmax-1)
    !close(fileid) 
      
    !�������ϵ��
    open(fileid,file="Coeff.txt")
    write(fileid,"(I3,2X,I3,2X,I3,2X,F12.8,2X,F12.8,2X,F12.8,2X,F12.8)") (((i,j,k,alpha1(i,j,k),alpha2(i,j,k),alpha3(i,j,k),beta12(i,j,k),i=1,imax),j=1,jmax),k=2,kmax-1)
    close(fileid) 
    
    !******************************************
    
end subroutine

end module
