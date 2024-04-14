!uEMEP_read_command_line.f90
    
    subroutine uEMEP_read_command_line
    
    use uEMEP_definitions
   
    implicit none
    
    integer n_commandline_inputs
    integer i_config
    
    !Assign the configuration file name and substitution date_str from the command line
    !Can have up to 10 config files, limitted by the array definition
    !Last command line string is always the date string
    !
    name_config_file=''
    config_date_str=''
    
    n_commandline_inputs = command_argument_count ()
    
    if (n_commandline_inputs.gt.n_max_config_files+1) then
        write(*,'(a,i2,a)') 'ERROR: Too many command line inputs. Maximum is ',n_max_config_files,' configuration files plus one date_str. Stopping uEMEP '
        stop
    endif
        
    if (n_commandline_inputs.ge.2) then
        n_config_files=n_commandline_inputs-1
        do i_config=1,n_config_files
            call get_command_argument(i_config,name_config_file(i_config))
            write(*,'(a,i1,2a)') 'name_config_file(',i_config,') = ',trim(name_config_file(i_config))
        enddo
        call get_command_argument(n_commandline_inputs,config_date_str)
        write(*,'(a,a)') 'config_date_str= ',trim(config_date_str)
    else
        write(*,*) 'ERROR: Insufficient number of command line inputs. Stopping uEMEP '
        stop
    endif
    
   
    end subroutine uEMEP_read_command_line