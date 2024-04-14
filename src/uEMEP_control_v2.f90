!****************************************************************************
!   uEMEP control v2
!
!   Bruce rolstad Denby (brucerd@met.no)
!   MET Norway
!****************************************************************************
! Reminder note for compilation on Intel
! To add this library to your linker input in the IDE, open the context menu for the project node, choose Properties, then in the Project Properties dialog box, choose Linker
! , and edit the Linker Input to add legacy_stdio_definitions.lib to the semi-colon-separated list
! Tools/options/intel compilers and tools/visual fortran/compilers and add bin, include and lib, e.g. C:\Program Files (x86)\netcdf 4.3.3.1\bin;
!   Control programme for running the downscaling routine uEMEP
!****************************************************************************

    !****************************************************************************
!To link to netcdf in visual studio
!Tools - options - Intel compilers - VisusalFortran - Compilers - Libraries/includes/executables
!C:\Program Files (x86)\netcdf 4.3.3.1\include
!C:\Program Files (x86)\netcdf 4.3.3.1\bin
!C:\Program Files (x86)\netcdf 4.3.3.1\lib
    
    program uEMEP_v6

    use uEMEP_definitions
   
    implicit none
    
    integer source_index
    real start_time_cpu,end_time_cpu
    logical :: have_read_emep=.false.
    !real temp_val,area_weighted_interpolation_function
    !real x_temp,y_temp,lon_temp,lat_temp
    
    model_version_str='uEMEP_v6.3'
    
    call CPU_TIME(start_time_cpu)
    
    write(*,*) ''
    write(*,*) '------------------------------------------------------------------------'
    write(*,*) 'Starting program '//trim(model_version_str)
    write(*,*) '------------------------------------------------------------------------'
    
    !Read the command line, assigning the configuration file names and the substitution date_str
    call uEMEP_read_command_line
    
    !Set constants and variable names to be read from EMEP and meteo files
    call uEMEP_set_constants
    
    
    !Read the configuration files. Hard coded to be up to 5 files. Log file opened in this routine
    call uEMEP_read_config
    
    !If selected then specify subgrid using the lat and lon coordinates
    if (select_latlon_centre_domain_position_flag) then
        call uEMEP_set_subgrid_select_latlon_centre
    endif
    
    !Set the landuse if required
    if (use_landuse_as_proxy.or.read_landuse_flag) then
        call uEMEP_set_landuse_classes
    endif
    
    !Set the pollutant and compound loop definitions
    call uEMEP_set_pollutant_loop
    
    !Reset any constants needed based on the configuration input
    call uEMEP_reset_constants
    

    !Autoselect files and countries if required. Place here because it changes config data
    if (auto_select_OSM_country_flag.or.trim(select_country_by_name).ne.'') then
        call read_country_bounding_box_data
    endif
    
    !Set the EMEP species definitions if they are to be read
    !write(*,*) '####-1: ',n_species_loop_index
    call uEMEP_set_species_loop

    !write(*,*) '####1: ',n_species_loop_index
    
    !Set the names of files to be written to when saving intermediate files
    call uEMEP_set_filenames
    
    !Read positions of receptor points (usually observations) for specifying multiple receptor grids or calculation points within a single grid
    call uEMEP_read_receptor_data
    
    !Enter the routine for saving emissions used in uEMEP for EMEP in netcdf files defined for the Norwegian domain in Lambert coordinates. Will stop after this
    if (save_emissions_for_EMEP(allsource_index)) then
        call uEMEP_calculate_emissions_for_EMEP
    endif
  
    !We set up an initial emission grid parameter set that can be used to first select the outester region
    !This has been done to enable reading of multiple road link files but only keeping those in the initial defined emission area
    call uEMEP_set_subgrids
    init_emission_subgrid_min=emission_subgrid_min
    init_emission_subgrid_max=emission_subgrid_max
    init_emission_subgrid_dim=emission_subgrid_dim
    init_emission_subgrid_delta=emission_subgrid_delta

    !Set the grid loop (g_loop) extent based on use_multiple_receptor_grids_flag or not
    if (use_multiple_receptor_grids_flag) then
        start_grid_loop_index=1
        end_grid_loop_index=n_receptor_in
        n_receptor=1
        n_valid_receptor=1
        valid_receptor_index(1)=1
        !reduce_roadlink_region_flag=.false. !Multiple receptor flags reads in all road links and allocates to the different receptor grids. Only reads once
    else
        start_grid_loop_index=1
        end_grid_loop_index=1
        n_receptor=n_receptor_in
        use_receptor(start_grid_loop_index)=.true.
    endif
    
    first_g_loop=.true.
    
    !If the use_single_time_loop_flag is true (Reads and calculates one time step at a time to save memory) then set these parameters
    if (use_single_time_loop_flag) then
        start_time_loop_index=1
        end_time_loop_index=end_time_nc_index-start_time_nc_index+1
        subgrid_dim(t_dim_index)=1
        dim_length_nc(time_dim_nc_index)=1
    else
        start_time_loop_index=1
        end_time_loop_index=1
        subgrid_dim(t_dim_index)=end_time_nc_index-start_time_nc_index+1
        dim_length_nc(time_dim_nc_index)=subgrid_dim(t_dim_index)
    endif
 
   
    !Start internal grid receptor loop using only those receptor grids specified in uEMEP_read_receptor_data
    do g_loop=start_grid_loop_index,end_grid_loop_index
    if (use_receptor(g_loop)) then
    
        
        !Set the grid definitions according to the receptor/observation positions
        call uEMEP_set_loop_receptor_grid
        
        !Create the subgrid
        call uEMEP_set_subgrids
        
        !Set emission factors for the current subgrid
        call uEMEP_set_emission_factors
        
        !Start the internal time loop
        do t_loop=start_time_loop_index,end_time_loop_index
   
            !Write progress in time and receptor grid loop to screen
            write(*,*) 'REC LOOP= ',g_loop,' OF ',end_grid_loop_index
            if (unit_logfile.ne.0) then 
                write(unit_logfile,*) 'REC LOOP= ',g_loop,' OF ',end_grid_loop_index
            endif
            write(*,*) 'TIME LOOP=',t_loop,' OF ',end_time_loop_index
            if (unit_logfile.ne.0) then 
                write(unit_logfile,*) 'TIME LOOP=',t_loop,' OF ',end_time_loop_index
            endif
                 
            !For the first time loop set the initial subgrid range values used in reading EMEP and meteo data
            if (t_loop.ge.start_time_loop_index) then
                init_subgrid_min=subgrid_min
                init_subgrid_max=subgrid_max
            endif
                
            !Read EMEP data from netcdf files. Time stamps based on this
            if (.not.have_read_emep) then
                call uEMEP_read_EMEP
            endif

            !If read EMEP only once flag is on then turn off the EMEP reading
            !This is intended for use with multiple receptor files and requires alot of memory so is permanently turned off
            if (read_EMEP_only_once_flag) have_read_emep=.true.
            
            !Read meteo grid from netcdf files if required
            if (use_alternative_meteorology_flag.or.use_alternative_z0_flag) then
                call uEMEP_read_meteo_nc
            endif
            
            !Set the following for the first internal time step only
            if (t_loop.eq.start_time_loop_index) then
        
                !Define subgrid positions and buffer zones. Must be done after reading EMEP data as is based on EMEP grid sizes
                call uEMEP_define_subgrid_extent
                call uEMEP_define_subgrid
        
                !Define and allocate cross reference subgrids used to transfer data between different subgrids
                call uEMEP_crossreference_grids
        
                
                !Read all road link data from ascii files
                if (calculate_source(traffic_index).and..not.read_subgrid_emission_data) then
                    !Do this only for the first receptor grid loop
                    if (first_g_loop) then
                        call uEMEP_read_roadlink_data_ascii
                        call uEMEP_change_road_data
                        !Read in the NORTRIP emission data for traffic in the first g_loop if required
                        if (use_NORTRIP_emission_data) then
                            call uEMEP_read_roadlink_emission_data
                        endif       
                    endif
                endif
 
                !Read in and grid industry data
                if (calculate_source(industry_index).and..not.read_subgrid_emission_data) then                    
                    call uEMEP_read_industry_data
                endif

                !Read and subgrid shipping data
                if (calculate_source(shipping_index).and..not.read_subgrid_emission_data) then
                    !If necessary aggregate shipping data first
                    call uEMEP_preaggregate_shipping_asi_data
                    !Read in shipping data
                    if (read_shipping_from_netcdf_flag) then
                        call uEMEP_read_netcdf_shipping_latlon
                    else
                        if (read_weekly_shipping_data_flag) then
                            call uEMEP_read_weekly_shipping_asi_data
                        elseif (read_monthly_and_daily_shipping_data_flag) then
                            call uEMEP_read_monthly_and_daily_shipping_asi_data
                        else
                            call uEMEP_read_shipping_asi_data
                        endif
                    endif
                    
                endif

                !Read in proxy data for home heating. Currently dwelling density
                if (calculate_source(heating_index).and..not.read_subgrid_emission_data) then
                    !If calculating tiles then read only the dwelling data
                    if (calculate_tiling_flag.or.calculate_region_tiling_flag) then
                        use_RWC_emission_data=.false.
                    endif
                    !Read the Residential Wood Combustion data from MetVed
                    if (use_RWC_emission_data) then
                        call uEMEP_read_RWC_heating_data
                    else
                        !Read and subgrid SSB dwelling data
                        SSB_data_type=dwelling_index
                        if (read_population_from_netcdf_flag) then
                            call uEMEP_read_netcdf_population_latlon
                        elseif (read_population_from_netcdf_local_flag) then
                            call uEMEP_read_netcdf_population
                        else           
                            call uEMEP_read_SSB_data
                        endif
                    endif
                    
                endif

                !Read and subgrid agriculture data
                if (calculate_source(agriculture_index).and.use_rivm_agricuture_emission_data.and..not.read_subgrid_emission_data) then
                    !Currently only data from RIVM here
                    call uEMEP_read_agriculture_rivm_data
                endif
                if (read_rivm_landuse_flag) then
                    call uEMEP_read_landuse_rivm_data
                endif
                if (read_subgrid_emission_data) then
                    !Special routine for reading in RIVM point source emission data
                    if (use_rivm_subgrid_emission_format) then
                        call uEMEP_read_emission_rivm_data
                    else
                        !Nothing else available yet
                    endif
                    
                endif

                
                !Read in population data
                if (calculate_population_exposure_flag.or.use_population_positions_for_auto_subgrid_flag.or.save_population) then
                    !Read and subgrid SSB population data
                    SSB_data_type=population_data_type
                        if (read_population_from_netcdf_flag) then
                            call uEMEP_read_netcdf_population_latlon
                        elseif (read_population_from_netcdf_local_flag) then
                            call uEMEP_read_netcdf_population
                        else           
                            call uEMEP_read_SSB_data
                        endif
                endif

                if (use_landuse_as_proxy.or.read_landuse_flag) then
                    call uEMEP_read_netcdf_landuse_latlon
                    !stop
                endif
                
                !Autogrid setting for selecting which subgrids to calculate
                if (use_emission_positions_for_auto_subgrid_flag(allsource_index)) then
                    call uEMEP_grid_roads
                    call uEMEP_auto_subgrid
                endif
                
                if (use_region_select_and_mask_flag) then
                    call uEMEP_region_mask
                endif
                
                !Determine the fraction of an EMEP grid within the one defined region
                if (trace_emissions_from_in_region) then
                    call uEMEP_assign_region_coverage_to_EMEP
                endif
                
                !Specify the subgrids sizes to be calculated using use_receptor_region
                call uEMEP_grid_receptor_data
                
                !Carry out tiling. Programme will stop here
                if (calculate_tiling_flag) then
                    call uEMEP_grid_roads
                    call uEMEP_set_tile_grids
                endif
                
                !Carry out regional tiling. Programme will stop here
                if (calculate_region_tiling_flag) then
                    call uEMEP_set_region_tile_grids
                endif

            endif
    
            !Read time profiles for emissions
            call uEMEP_read_time_profiles

            !Call grid_roads again to include the time variation from NORTRIP
            if (.not.read_subgrid_emission_data) then
                call uEMEP_grid_roads
            endif
            
            !Interpolate meteo data to subgrid. Placed on the integral subgrid
            call uEMEP_subgrid_meteo_EMEP
        
            !Replaces proxy emissions with distributed EMEP emissions
            call uEMEP_subgrid_emission_EMEP  
               
            !Convert proxies to emissions including time profiles
            call uEMEP_convert_proxy_to_emissions
            
            !Adjust traffic emissions of NOx based on temperature
            if (use_traffic_nox_emission_temperature_dependency) then
                call uEMEP_nox_emission_temperature
            endif
        
           !Places EMEP deposition velocities into the deposition_subgrid
            if (calculate_deposition_flag) then
                call uEMEP_set_deposition_velocities
            endif

            !Set travel_time values to 0 outside of the source loop as these are aggregated over all sources
            traveltime_subgrid=0.
            !Subgrid dispersion calculation
            do source_index=1,n_source_index
            if (calculate_source(source_index).and..not.use_plume_dispersion_deposition_flag) then
                call uEMEP_subgrid_dispersion(source_index)
            endif
            enddo
            
            do source_index=1,n_source_index
            if (calculate_source(source_index).and.use_plume_dispersion_deposition_flag) then
                call uEMEP_subgrid_deposition(source_index)
            endif
            enddo
            
            
            !Interpolate local_subgrid if necessary
            if (interpolate_subgrids_flag) then
                call uEMEP_interpolate_auto_subgrid
            endif
    
            !Old diagnostic for comparing EMEP and proxy data emissions. Working only on lat lon EMEP grids. Do not use
            if (make_EMEP_grid_emission_data(allsource_index)) then
                !call uEMEP_aggregate_proxy_emission_in_EMEP_grid
            endif    
    
            !Put EMEP data into the additional subgrids for all sources.
            !Must be run first
            if (EMEP_additional_grid_interpolation_size.gt.0) then
                calculate_EMEP_additional_grid_flag=.true.
                call uEMEP_subgrid_EMEP
                calculate_EMEP_additional_grid_flag=.false. 
                !stop
            endif
            
            !Put EMEP data into subgrids for all sources
            call uEMEP_subgrid_EMEP

            if (calculate_deposition_flag) then
                call uEMEP_subgrid_deposition_EMEP
            endif

            !Interpolate EMEP to sub-grid
            do source_index=1,n_source_index
            if (calculate_source(source_index)) then
                !Redistributes proxy subgrid data into the EMEP grid concentrations only when local_subgrid_method_flag=1 (based on EMEP concentration redistribution scaling factor)
                call uEMEP_redistribute_local_source(source_index)
                !Places the proxy_subgrid data into the local_subgrid when local_subgrid_method_flag<>1
                call uEMEP_disperse_local_source(source_index)
            endif
            enddo

            !Combine and save sources in local and total values
            call uEMEP_combine_local_source
    
            !Calculate the nonlocal depositions
            if (calculate_deposition_flag) then
                call uEMEP_calculate_deposition
            endif
            
            !Calculate chemistry for NO2 and O3
            call uEMEP_chemistry_control
            
            !Correct annual mean chemistry for pdf
            if (use_annual_mean_pdf_chemistry_correction) then
                call correct_annual_mean_chemistry
            endif
            

            !Calculate exposure
            if (calculate_population_exposure_flag) then
                call uEMEP_calculate_exposure
            endif
    
            !Save results to netcdf
            if (save_netcdf_file_flag.or.save_netcdf_receptor_flag) then
                call uEMEP_save_netcdf_control
            endif         
    
        enddo !t_loop
    
        !Update first_g_loop flag
        if (first_g_loop) first_g_loop=.false.
    
    endif !use_receptor
    
    enddo !g_loop

    call CPU_TIME(end_time_cpu)

    if (unit_logfile.ne.0) then 
    write(unit_logfile,*) ''
    write(unit_logfile,*) '------------------------------------------------------------------------'
    write(unit_logfile,*) 'Ending program '//trim(model_version_str)
    write(unit_logfile,'(a,i5,a,i2)') ' CPU time taken (MM:SS): ',floor((end_time_cpu-start_time_cpu)/60.),':',floor(mod(end_time_cpu-start_time_cpu,60.))
    write(unit_logfile,*) '------------------------------------------------------------------------'
    endif
    
    if (unit_logfile.gt.0) then
         close(unit_logfile,status='keep')
    endif

    !Save finished file
    if (trim(finished_filename).ne.'') then
        if (save_netcdf_receptor_flag.and.n_valid_receptor.ne.0) then
	        write(*,'(2A)') 'Writing finished file for uEMEP output: ',trim(finished_file_rec)
            open(unit_finishedfile,file=finished_file_rec,status='replace')
            close(unit_finishedfile)
        endif
        if (save_netcdf_file_flag) then
	        write(*,'(2A)') 'Writing finished file for uEMEP output: ',trim(finished_file)
            open(unit_finishedfile,file=finished_file,status='replace')
            close(unit_finishedfile)
        endif
    endif

    write(*,*) ''
    write(*,*) '------------------------------------------------------------------------'
    write(*,*) 'Ending program '//trim(model_version_str)
    write(*,'(a,i5,a,i2)') ' CPU time taken (MM:SS): ',floor((end_time_cpu-start_time_cpu)/60.),':',floor(mod(end_time_cpu-start_time_cpu,60.))
    write(*,*) '------------------------------------------------------------------------'

    end program uEMEP_v6

