submodule (mod_mpifw) mod_send_mpi

    use mpi_f08
    use iso_fortran_env

    implicit none
   
	@INTERFACE_START@
		module function send_@DIM_ID@_@F_KIND_ID@(send_msg, pfrom, pto) result (recv_msg)
			@F_KIND@,intent(in) :: send_msg(@RANK@)
			@F_KIND@,allocatable :: recv_msg(@RANK@)
			integer(int32),intent(in) :: pfrom, pto
		end function
	@INTERFACE_END@

	@INTERFACE_START@
		module function send_s@F_KIND_ID@(send_msg, pfrom, pto) result (recv_msg)
			@F_KIND@,intent(in) :: send_msg
			@F_KIND@ :: recv_msg
			integer(int32),intent(in) :: pfrom, pto
		end function
	@INTERFACE_END@

    @INTERFACE_NAME@ send_mpi @
    
contains
@PROCEDURE_START@
!=======================================================================
module function send_s@F_KIND_ID@(send_msg, pfrom, pto) result (recv_msg)
    @F_KIND@,intent(in) :: send_msg
    @F_KIND@ :: recv_msg
    integer(int32),intent(in) :: pfrom, pto
    integer(int32) :: i
        
    recv_msg = send_msg
    tag = bcast_mpi(tag+1,pfrom)
    
    if(this_proc == pfrom) then
        call MPI_SEND(send_msg,1,@MPI_KIND@,pto,tag,comm,ierr)
        if(ierr /= 0) call stop_mpi("send_s@F_KIND_ID@: MPI_SEND: ERROR")
    elseif(this_proc == pto) then
        call MPI_RECV(recv_msg,1,@MPI_KIND@,pfrom,tag,comm,trans_stat,ierr)
        if(ierr /= 0) call stop_mpi("send_s@F_KIND_ID@: MPI_RECV: ERROR")
    endif
    
end function
@PROCEDURE_END@
@PROCEDURE_START@
!=======================================================================
module function send_@DIM_ID@_@F_KIND_ID@(send_msg, pfrom, pto) result (recv_msg)
    @F_KIND@,intent(in) :: send_msg(@RANK@)
    @F_KIND@,allocatable :: recv_msg(@RANK@)
    integer(int32),intent(in) :: pfrom, pto
    integer(int32) :: i
        
    allocate(recv_msg, source=send_msg)
    tag = bcast_mpi(tag+1,pfrom)
    
    if(this_proc == pfrom) then
        call MPI_SEND(send_msg,size(send_msg),@MPI_KIND@,pto,tag,comm,ierr)
        if(ierr /= 0) call stop_mpi("send_@DIM_ID@_@F_KIND_ID@: MPI_SEND: ERROR")
    elseif(this_proc == pto) then
        call MPI_RECV(recv_msg,size(recv_msg),@MPI_KIND@,pfrom,tag,comm,trans_stat,ierr)
        if(ierr /= 0) call stop_mpi("send_@DIM_ID@_@F_KIND_ID@: MPI_RECV: ERROR")
    endif
    
end function
@PROCEDURE_END@
end submodule
