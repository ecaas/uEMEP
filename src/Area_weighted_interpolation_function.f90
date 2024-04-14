!Area_weighted_interpolation_function
      
function area_weighted_interpolation_function(xgrid,ygrid,zgrid,xdim,ydim,delta,xval,yval)  
    !Returns the area weight value for a a point at position xval, yval from the grid values xgrid,ygrid,zgrid
    implicit none
    
    integer, intent(in) :: xdim,ydim
    real, intent(in) :: delta(2)
    real, intent(in) :: xgrid(xdim,ydim),ygrid(xdim,ydim),zgrid(xdim,ydim)
    real, intent(in) :: xval,yval
    real zval
    real area_weighted_interpolation_function
    real sum_weight
    
    real weighting
    integer i,j,ii,jj
    real  xpos_area_max,xpos_area_min,ypos_area_max,ypos_area_min
    real  xpos_max,xpos_min,ypos_max,ypos_min
        
    !If only on grid available then return the value of that grid
    if (xdim.eq.1.and.ydim.eq.1) then
        area_weighted_interpolation_function=zgrid(xdim,ydim)
        return
    endif
    
    !Find grid index for position val
    i=1+floor((xval-xgrid(1,1))/delta(1)+0.5)
    j=1+floor((yval-ygrid(1,1))/delta(2)+0.5)     

    i=max(1,i);i=min(xdim,i)
    j=max(1,j);j=min(ydim,j)
    
    if (i.lt.1.or.j.lt.1.or.i.gt.xdim.or.j.gt.ydim) then
        write(*,'(A,4i6)') 'Interpolation out of range in area_weighted_interpolation_function. Stopping. (i,j,xdim,ydim)',i,j,xdim,ydim
        write(*,'(4f12.2)') xval,yval,xgrid(1,1),ygrid(1,1)
        stop
    else
        
        xpos_area_max=xval+delta(1)/2.
        xpos_area_min=xval-delta(1)/2.
        ypos_area_max=yval+delta(2)/2.
        ypos_area_min=yval-delta(2)/2.
                  
        zval=0.
        sum_weight=0.
        
        do jj=j-1,j+1
        do ii=i-1,i+1         
            
            xpos_min=max(xpos_area_min,xgrid(ii,jj)-delta(1)/2.)
            xpos_max=min(xpos_area_max,xgrid(ii,jj)+delta(1)/2.)
            ypos_min=max(ypos_area_min,ygrid(ii,jj)-delta(2)/2.)
            ypos_max=min(ypos_area_max,ygrid(ii,jj)+delta(2)/2.)
               
            if (xpos_max.gt.xpos_min.and.ypos_max.gt.ypos_min) then
                weighting=(ypos_max-ypos_min)*(xpos_max-xpos_min)/delta(1)/delta(2)
            else
                weighting=0.
            endif                

            zval=zval+zgrid(ii,jj)*weighting

            !write(*,'(4i6,f12.4,f12.4)') i,j,ii,jj,weighting,zgrid(ii,jj)
            sum_weight=sum_weight+weighting
        enddo
        enddo
            !write(*,'(f12.4,f12.4)') zval,sum_weight
          
    endif
    
    area_weighted_interpolation_function=zval
        
    
end function area_weighted_interpolation_function
    
function area_weighted_extended_interpolation_function(xgrid,ygrid,zgrid,xdim,ydim,delta,xval,yval,delta_val)  
    !Returns the area weighted value for rectangle of size delta_val at position xval, yval from the grid values xgrid,ygrid,zgrid
    !Delta_val can be any size
    
    implicit none
    
    integer, intent(in) :: xdim,ydim
    real, intent(in) :: delta(2)
    real, intent(in) :: delta_val(2)
    real, intent(in) :: xgrid(xdim,ydim),ygrid(xdim,ydim),zgrid(xdim,ydim)
    real, intent(in) :: xval,yval
    real zval
    real area_weighted_extended_interpolation_function
    real sum_weight
    
    real weighting
    integer i,j,ii,jj,iii,jjj
    real  xpos_area_max,xpos_area_min,ypos_area_max,ypos_area_min
    real  xpos_max,xpos_min,ypos_max,ypos_min
    integer ii_delta,jj_delta
    
    !If only on grid available then return the value of that grid
    if (xdim.eq.1.and.ydim.eq.1) then
        area_weighted_extended_interpolation_function=zgrid(xdim,ydim)
        return
    endif
    
    !Find grid index for position val
    i=1+floor((xval-xgrid(1,1))/delta(1)+0.5)
    j=1+floor((yval-ygrid(1,1))/delta(2)+0.5)     

    i=max(1,i);i=min(xdim,i)
    j=max(1,j);j=min(ydim,j)

    if (i.lt.1.or.j.lt.1.or.i.gt.xdim.or.j.gt.ydim) then
        write(*,'(A,4i6)') 'Interpolation out of range in area_weighted_extended_interpolation_function. Stopping. (i,j,xdim,ydim)',i,j,xdim,ydim
        write(*,'(4f12.2)') xval,yval,xgrid(1,1),ygrid(1,1)
        stop
    else
        
        xpos_area_max=xval+delta_val(1)/2.
        xpos_area_min=xval-delta_val(1)/2.
        ypos_area_max=yval+delta_val(2)/2.
        ypos_area_min=yval-delta_val(2)/2.
                  
        jj_delta=1+floor(0.5*(delta_val(2)/delta(2)-1.))
        ii_delta=1+floor(0.5*(delta_val(1)/delta(1)-1.))

        zval=0.
        sum_weight=0.
        !write(*,*) i,j,ii_delta,jj_delta
        do jjj=j-jj_delta,j+jj_delta
        do iii=i-ii_delta,i+ii_delta         
            
            jj=max(jjj,1);jj=min(jj,ydim)
            ii=max(iii,1);ii=min(ii,xdim)
            xpos_min=max(xpos_area_min,xgrid(ii,jj)-delta(1)/2.)
            xpos_max=min(xpos_area_max,xgrid(ii,jj)+delta(1)/2.)
            ypos_min=max(ypos_area_min,ygrid(ii,jj)-delta(2)/2.)
            ypos_max=min(ypos_area_max,ygrid(ii,jj)+delta(2)/2.)
               
            if (xpos_max.gt.xpos_min.and.ypos_max.gt.ypos_min) then
                weighting=(ypos_max-ypos_min)*(xpos_max-xpos_min)/delta_val(1)/delta_val(2)
            else
                weighting=0.
            endif                

            zval=zval+zgrid(ii,jj)*weighting

            !write(*,'(4i6,f12.4,f12.4)') i,j,ii,jj,weighting,zgrid(ii,jj)
            sum_weight=sum_weight+weighting
            
            !write(*,*) ii,jj,sum_weight
        enddo
        enddo
            !write(*,'(f12.4,f12.4)') zval,sum_weight
          
    endif
    
    area_weighted_extended_interpolation_function=zval
        
    
end function area_weighted_extended_interpolation_function
    
function area_weighted_extended_vectorgrid_interpolation_function(xgrid,ygrid,zgrid,xdim,ydim,delta,xval,yval,delta_val)  
    !Returns the area weighted value for rectangle of size delta_val at position xval, yval from the grid values xgrid,ygrid,zgrid
    !Delta_val can be any size
    !vectorgrid means the grid positions only have one dimension
    
    implicit none
    
    integer, intent(in) :: xdim,ydim
    real, intent(in) :: delta(2)
    real, intent(in) :: delta_val(2)
    real, intent(in) :: xgrid(xdim),ygrid(ydim),zgrid(xdim,ydim)
    real, intent(in) :: xval,yval
    real zval
    real area_weighted_extended_vectorgrid_interpolation_function
    real sum_weight
    
    real weighting
    integer i,j,ii,jj,iii,jjj
    real  xpos_area_max,xpos_area_min,ypos_area_max,ypos_area_min
    real  xpos_max,xpos_min,ypos_max,ypos_min
    integer ii_delta,jj_delta
    
    !If only on grid available then return the value of that grid
    if (xdim.eq.1.and.ydim.eq.1) then
        area_weighted_extended_vectorgrid_interpolation_function=zgrid(xdim,ydim)
        return
    endif
    
    !Find grid index for position val
    i=1+floor((xval-xgrid(1))/delta(1)+0.5)
    j=1+floor((yval-ygrid(1))/delta(2)+0.5)     

    i=max(1,i);i=min(xdim,i)
    j=max(1,j);j=min(ydim,j)

    if (i.lt.1.or.j.lt.1.or.i.gt.xdim.or.j.gt.ydim) then
        write(*,'(A,4i6)') 'Interpolation out of range in area_weighted_extended_interpolation_function. Stopping. (i,j,xdim,ydim)',i,j,xdim,ydim
        write(*,'(4f12.2)') xval,yval,xgrid(1),ygrid(1)
        stop
    else
        
        xpos_area_max=xval+delta_val(1)/2.
        xpos_area_min=xval-delta_val(1)/2.
        ypos_area_max=yval+delta_val(2)/2.
        ypos_area_min=yval-delta_val(2)/2.
                  
        jj_delta=1+floor(0.5*(delta_val(2)/delta(2)-1.))
        ii_delta=1+floor(0.5*(delta_val(1)/delta(1)-1.))

        zval=0.
        sum_weight=0.
        !write(*,*) i,j,ii_delta,jj_delta
        do jjj=j-jj_delta,j+jj_delta
        do iii=i-ii_delta,i+ii_delta         
            
            jj=max(jjj,1);jj=min(jj,ydim)
            ii=max(iii,1);ii=min(ii,xdim)
            xpos_min=max(xpos_area_min,xgrid(ii)-delta(1)/2.)
            xpos_max=min(xpos_area_max,xgrid(ii)+delta(1)/2.)
            ypos_min=max(ypos_area_min,ygrid(jj)-delta(2)/2.)
            ypos_max=min(ypos_area_max,ygrid(jj)+delta(2)/2.)
               
            if (xpos_max.gt.xpos_min.and.ypos_max.gt.ypos_min) then
                weighting=(ypos_max-ypos_min)*(xpos_max-xpos_min)/delta_val(1)/delta_val(2)
            else
                weighting=0.
            endif                

            zval=zval+zgrid(ii,jj)*weighting

            !write(*,'(4i6,f12.4,f12.4)') i,j,ii,jj,weighting,zgrid(ii,jj)
            sum_weight=sum_weight+weighting
            
            !write(*,*) ii,jj,sum_weight
        enddo
        enddo
            !write(*,'(f12.4,f12.4)') zval,sum_weight
          
    endif
    
    area_weighted_extended_vectorgrid_interpolation_function=zval
        
    
end function area_weighted_extended_vectorgrid_interpolation_function    