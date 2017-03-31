module wall   !����߽���������ά���������񣬶�ά���Ǳ߽�ڵ㣬������������Ƿǽṹ����Ĵ洢�ļ�
    use controlPara
    
    implicit none
    
    integer::nnodes,nedges
    real(8),allocatable::inode(:,:)
    integer,allocatable::iedge(:,:)
    
contains

subroutine readWall
    implicit none
    integer:: i
    open(10,file='airfoil/naca0012.dat')
    read(10,*) nnodes,nedges
    
      
    !allocate space for iedge array
    allocate(inode(2,nodes))
    allocate(iedge(2,nedges))
    
    do i=1,nnodes
         read(10,*) inode(:,i)                                          !inode(1,i)��ʾ��i�����x���꣬inode(2,i)��ʾ��i�����y����
    end do
    
    do i=1,nedges
        read(10,*)  iedge(:,i)                              !iedge(1,i)��ʾ��i���ߵĵ�һ��������ţ�iedge(2,i)��ʾ��i���ߵĵ�2��������
    end do 
    
    close(10)
    
end subroutine

end module