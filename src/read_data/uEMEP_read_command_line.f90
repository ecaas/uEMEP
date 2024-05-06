module read_command_line
    !! Routines for interacting with the command line

    use uemep_configuration, only: name_config_file, config_date_str, n_config_files, n_max_config_files
    use uemep_logger

    implicit none
    private

    public :: uEMEP_read_command_line

contains

    subroutine uEMEP_read_command_line()
        !! Assign the configuration file name and substitution date_str from the command line
        !!
        !! Can have up to 10 config files, limitted by the array definition
        !! Last command line string is always the date string
        
        ! Local variables
        integer n_commandline_inputs
        integer i_config

        name_config_file = ''
        config_date_str = ''

        ! Get number of command line arguments
        n_commandline_inputs = command_argument_count ()

        if (n_commandline_inputs .gt. n_max_config_files+1) then
            ! Note: Output goes to stdout instead of log file
            write(*,'(a,i2,a)') 'ERROR: Too many command line inputs. Maximum is ', n_max_config_files, ' configuration files plus one date_str. Stopping uEMEP'
            stop 1
        end if

        if (n_commandline_inputs .ge. 2) then
            n_config_files = n_commandline_inputs - 1
            do i_config = 1, n_config_files
                call get_command_argument(i_config, name_config_file(i_config))
                write(log_msg,'(a,i1,2a)') 'name_config_file(',i_config,') = ',trim(name_config_file(i_config))
                call log_message(log_msg, INFO)
            end do
            call get_command_argument(n_commandline_inputs, config_date_str)
            write(log_msg,'(2a)') 'config_date_str = ', trim(config_date_str)
            call log_message(log_msg, INFO)
        else
            ! Note: Output goes to stdout instead of log file
            write(*,*) 'ERROR: Insufficient number of command line inputs. Stopping uEMEP'
            stop 1
        end if

    end subroutine uEMEP_read_command_line

end module read_command_line

