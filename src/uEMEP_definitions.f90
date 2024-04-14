!UEMEP_definitions
!Defines variables and indexes used in the uEMEP routines
!Bruce Rolstad Denby 09.11.2016
   
    module uEMEP_definitions
    
    implicit none
    
    !Directory seperator for linux (/) or windows (\)
    character(1) :: slash='\'

    character(256) :: model_version_str='uEMEP_vx.x'
    
    !Configuration file name entered in command line
    integer n_max_config_files
    parameter(n_max_config_files=10)
    character(256) :: name_config_file(n_max_config_files)=''
    character(256) :: filename_log_file='uEMEP_log.txt'
    character(256) :: pathname_log_file=''
    character(256) :: config_date_str=''
    character(256) :: emission_date_str=''
    character(256) :: replacement_date_str='<>'
    character(256) :: replacement_yesterday_date_str='[]'
    character(256) :: replacement_hour_str='<>'
    character(256) :: NORTRIP_replacement_hour_str='<>'
    integer :: n_config_files=0
    
    logical :: use_single_time_loop_flag=.false.
    logical :: reduce_EMEP_region_flag=.false.
    logical :: reduce_roadlink_region_flag=.true.
    logical :: read_EMEP_only_once_flag=.false. !Note can lead to virtual memory overflow
    
    !Nodata value
    !Changed to -99 so it can be used with int1 variables
    real NODATA_value
    !parameter (NODATA_value=-99.)
    !Change to allow the int1 value to be -100
    parameter (NODATA_value=-128.)
    
    !often used
    !integer i,j,k
    
    integer :: unit_logfile=0
    integer :: unit_finishedfile=20
    integer :: n_roadlinks=0
    integer :: n_roadlinks_major=0
    integer :: n_roadlinks_major_selected=0
    integer :: utm_zone=33
    real :: utm_lon0=15.
    real :: ltm_lon0=0.
    integer :: EMEP_grid_interpolation_flag=0
    integer :: EMEP_meteo_grid_interpolation_flag=1
    real :: EMEP_grid_interpolation_size=1.
    real :: EMEP_additional_grid_interpolation_size=0.
    integer :: local_subgrid_method_flag=1
    logical :: calculate_EMEP_additional_grid_flag=.false.
    
    !Single loop time variables
    integer t_loop
    integer :: start_time_loop_index=1
    integer :: end_time_loop_index=1
    
    !Dimensions of the netcdf files that are read
    integer num_dims_nc 
    parameter (num_dims_nc=6) !(x,y,z,t,xpos,ypos)
    integer num_dims_meteo_nc 
    parameter (num_dims_meteo_nc=4) !(x,y,z,t)
    
    integer dim_length_nc(num_dims_nc)
    integer dim_start_nc(num_dims_nc)
    data dim_start_nc /1, 1, 1, 1, 1, 1/                 ! start at first value
    integer dim_length_meteo_nc(num_dims_meteo_nc)
    integer dim_start_meteo_nc(num_dims_meteo_nc)
    data dim_start_meteo_nc /1, 1, 1, 1/                 ! start at first value
    integer dim_length_EMEP_nc(num_dims_nc)
    integer dim_start_EMEP_nc(num_dims_nc)
    
    !Dimensions of the netcdf files that are used
    integer end_dim_nc(num_dims_nc)
    integer start_dim_nc(num_dims_nc)

    
    integer lat_nc_index,lon_nc_index
    integer ugrid_nc_index,vgrid_nc_index,FF10_nc_index,FFgrid_nc_index,inv_FFgrid_nc_index,inv_FF10_nc_index
    integer hmix_nc_index,kz_nc_index,invL_nc_index,ustar_nc_index,logz0_nc_index,J_nc_index
    integer conc_nc_index,emis_nc_index
    integer x_nc_index,y_nc_index,ZTOP_nc_index
    integer u10_nc_index,v10_nc_index,uw_nc_index,vw_nc_index,Hflux_nc_index,t2m_nc_index,precip_nc_index,wetdepo_nc_index,drydepo_nc_index
    integer phi_nc_index
    parameter (lon_nc_index=1,lat_nc_index=2)
    parameter (ugrid_nc_index=3,vgrid_nc_index=4,FF10_nc_index=5,FFgrid_nc_index=6,inv_FFgrid_nc_index=7,inv_FF10_nc_index=8)
    parameter (hmix_nc_index=9,kz_nc_index=10,invL_nc_index=11,ustar_nc_index=12,logz0_nc_index=13,J_nc_index=14)
    !parameter (conc_nc_index=15,frac_nc_index=16,local_nc_index=17,emis_nc_index=18)
    parameter (conc_nc_index=15,emis_nc_index=18) !frac_nc_index,local_nc_index have now become variables to be set with the loop_index (multiple EMEP lf grids)
    parameter (x_nc_index=19,y_nc_index=20,ZTOP_nc_index=21)
    parameter (u10_nc_index=22,v10_nc_index=23,uw_nc_index=24,vw_nc_index=25,Hflux_nc_index=26,t2m_nc_index=27,precip_nc_index=28,wetdepo_nc_index=29,drydepo_nc_index=30)
    parameter (phi_nc_index=31)
    integer num_var_nc  !This will be set later when the number local fraction grids is known
    integer num_var_nc_start    
    integer num_var_nc_name
    parameter (num_var_nc_start=31)                  ! number of readable variables
    parameter (num_var_nc_name=51)                  ! number of possible variable names, add 20 to include any extra local fraction grids
    integer num_var_meteo_nc
    parameter (num_var_meteo_nc=num_var_nc_start)
    
    !parameter (lc_frac_nc_index=1,lc_local_nc_index=2)
    integer num_lc_var_nc_start
    parameter (num_lc_var_nc_start=2)                  ! number of readable local contribution variables
    
    integer :: frac_nc_index=num_var_nc_start+1,local_nc_index=num_var_nc_start+2
    integer :: lc_frac_nc_index=1,lc_local_nc_index=2
    integer :: num_lc_var_nc=num_lc_var_nc_start

    integer compound_index

    integer no2_nc_index,nox_nc_index,pm25_nc_index,pm10_nc_index,nh3_nc_index,o3_nc_index,so2_nc_index,pmex_nc_index
    parameter (no2_nc_index=1,nox_nc_index=2,pm25_nc_index=3,pm10_nc_index=4,nh3_nc_index=5,o3_nc_index=6,so2_nc_index=7,pmex_nc_index=8)
    !Additional for nh3 compounds
    integer nh4_nc_index
    parameter (nh4_nc_index=9)
    !Additional NORTRIP specific compounds
    integer pm25_sand_nc_index,pm10_sand_nc_index,pm25_salt_nc_index,pm10_salt_nc_index
    parameter (pm25_sand_nc_index=10,pm10_sand_nc_index=11,pm25_salt_nc_index=12,pm10_salt_nc_index=13)
    !Additional compounds. Need to change n_compound_index as well
    integer c6h6_nc_index,bap_nc_index,co_nc_index,somo35_nc_index,comax_nc_index,o3max_nc_index,o3_26th_nc_index
    parameter (c6h6_nc_index=14,bap_nc_index=15,co_nc_index=16,somo35_nc_index=17,comax_nc_index=18,o3max_nc_index=19,o3_26th_nc_index=20)    
    integer n_compound_nc_index
    parameter (n_compound_nc_index=20)
    !These are only used in names but need to change the variable n_pollutant_nc_index to fit these!
    integer pmco_nc_index,all_nc_index,pm_nc_index,all_sand_nc_index,all_salt_nc_index,all_sand_salt_nc_index,all_totals_nc_index,aaqd_totals_nc_index,gp_totals_nc_index,op_totals_nc_index
    parameter (pmco_nc_index=21,all_nc_index=22,pm_nc_index=23,all_sand_nc_index=24,all_salt_nc_index=25,all_sand_salt_nc_index=26,all_totals_nc_index=27,aaqd_totals_nc_index=28,gp_totals_nc_index=29,op_totals_nc_index=30)
    !THese must be the same as the subgrid source indexes. Should probably just use the one
    integer allsource_nc_index,traffic_nc_index,shipping_nc_index,heating_nc_index,agriculture_nc_index,industry_nc_index
    parameter (allsource_nc_index=1,traffic_nc_index=2,shipping_nc_index=3,heating_nc_index=4,agriculture_nc_index=5,industry_nc_index=6)
    integer n_source_nc_index
    !parameter (n_source_nc_index=6)
    
    !All the other GNFR emissions
    integer publicpower_nc_index,fugitive_nc_index,solvents_nc_index,aviation_nc_index,offroad_nc_index,waste_nc_index,livestock_nc_index,other_nc_index
    integer traffic_exhaust_nc_index,traffic_nonexhaust_nc_index,traffic_gasoline_nc_index,traffic_diesel_nc_index,traffic_gas_nc_index
    integer publicpower_point_nc_index,publicpower_area_nc_index,extrasource_nc_index
    parameter (publicpower_nc_index=7,fugitive_nc_index=8,solvents_nc_index=9,aviation_nc_index=10,offroad_nc_index=11,waste_nc_index=12,livestock_nc_index=13,other_nc_index=14)
    parameter (traffic_exhaust_nc_index=15,traffic_nonexhaust_nc_index=16,traffic_gasoline_nc_index=17,traffic_diesel_nc_index=18,traffic_gas_nc_index=19)
    parameter (publicpower_point_nc_index=20,publicpower_area_nc_index=21,extrasource_nc_index=22)
    parameter (n_source_nc_index=22)
    
    integer convert_GNFR_to_uEMEP_sector_index(n_source_nc_index)
    integer convert_uEMEP_to_GNFR_sector_index(n_source_nc_index)
    
    !integer GNFR_index(n_source_nc_index)
    !A �PublicPower� (1)
    !B �Industry� (3)
    !C �OtherStationaryComb� (2)
    !D �Fugitive� (4)
    !E �Solvents� (6)
    !F �RoadTransport� (7)
    !G �Shipping� (8)
    !H �Aviation� (8)
    !I �Offroad� (8)
    !J �Waste� (9)
    !K �AgriLivestock� (10)
    !L �AgriOther� (10)
    !M �Other� (5)
    
    !Compound loop for nox chemistry
    !integer :: n_compound_loop = 1
    !integer compound_loop_index(n_compound_nc_index)

    !Loop for all pollutants to be calculated
    integer pollutant_index
    integer n_pollutant_nc_index
    parameter (n_pollutant_nc_index=30) !Includes the addition naming indexes index
    integer :: n_pollutant_loop = 1
    integer :: n_emep_pollutant_loop = 1
    integer pollutant_loop_index(n_pollutant_nc_index)
    integer pollutant_loop_back_index(n_pollutant_nc_index)
    
    !Set pollutant compound loop 
    integer :: n_pollutant_compound_loop(n_pollutant_nc_index)=0
    integer :: pollutant_compound_loop_index(n_pollutant_nc_index,n_compound_nc_index)=0
    !Set the pollutant reference index for meteo data. All meteo data read from EMEP uses this index
    integer :: meteo_p_loop_index=1
    character(256) :: pollutant_file_str(n_pollutant_nc_index)=''

    character(256) var_name_nc(num_var_nc_name,n_pollutant_nc_index,n_source_nc_index)
    character(256) dim_name_nc(num_dims_nc)
    character(256) var_name_meteo_nc(num_var_meteo_nc)
    character(256) dim_name_meteo_nc(num_dims_meteo_nc)
    character(256) comp_name_nc(n_compound_nc_index)
    character(256) input_comp_name
    real comp_scale_nc(n_compound_nc_index)
    
    integer num_var_population_nc,num_dims_population_nc,population_nc_index,dwelling_nc_index
    !parameter (num_var_population_nc=3,num_dims_population_nc=2,population_nc_index=3) !population_nc_index=3 assumes lat and lon are 1 and 2
    parameter (num_var_population_nc=2,num_dims_population_nc=2,population_nc_index=1,dwelling_nc_index=2) !population_nc_index=1 assumes population files in lat and lon
    character(256) var_name_population_nc(num_var_population_nc)
    character(256) dim_name_population_nc(num_dims_population_nc)

    integer num_var_shipping_nc,num_dims_shipping_nc
    parameter (num_var_shipping_nc=1,num_dims_shipping_nc=2) !assumes shipping files in lat and lon
    character(256) var_name_shipping_nc(num_var_shipping_nc)
    character(256) dim_name_shipping_nc(num_dims_shipping_nc)

    integer num_var_landuse_nc,num_dims_landuse_nc
    parameter (num_var_landuse_nc=1,num_dims_landuse_nc=2) !assumes landuse files in lat and lon
    character(256) var_name_landuse_nc(num_var_landuse_nc)
    character(256) dim_name_landuse_nc(num_dims_landuse_nc)
    integer dim_length_landuse_nc(num_dims_landuse_nc)
    integer dim_start_landuse_nc(num_dims_landuse_nc)
    data dim_start_landuse_nc /1, 1/                 ! start at first value

    !dimension netcdf fields
    integer x_dim_nc_index,y_dim_nc_index,z_dim_nc_index,time_dim_nc_index,xdist_dim_nc_index,ydist_dim_nc_index
    parameter (x_dim_nc_index=1,y_dim_nc_index=2,z_dim_nc_index=3,time_dim_nc_index=4,xdist_dim_nc_index=5,ydist_dim_nc_index=6)

    !Declare netcdf files
    real, allocatable :: var1d_nc(:,:)
    real, allocatable :: var2d_nc(:,:,:)
    real, allocatable :: var3d_nc(:,:,:,:,:,:)
    real, allocatable :: var4d_nc(:,:,:,:,:,:,:)
    real, allocatable :: lc_var3d_nc(:,:,:,:,:,:,:,:)         !Netcdf local contribution array (idist,jdist,i,j,k,t,type,source)
    real, allocatable :: lc_var4d_nc(:,:,:,:,:,:,:,:,:)       !Netcdf local contribution array (idist,jdist,i,j,k,t,type,source)
    real, allocatable :: comp_var3d_nc(:,:,:,:)             !Netcdf additional compounds array (i,j,t,compound)
    real, allocatable :: comp_var4d_nc(:,:,:,:,:)           !Netcdf additional compounds array (i,j,k,t,compound)
    !Alternative meteorological input data netcdf files. No source element
    real, allocatable :: meteo_var1d_nc(:,:)
    real, allocatable :: meteo_var2d_nc(:,:,:)  
    real, allocatable :: meteo_var3d_nc(:,:,:,:)
    real, allocatable :: meteo_var4d_nc(:,:,:,:,:)
    
    real dgrid_nc(2)
    real meteo_dgrid_nc(2)
    double precision, allocatable :: val_dim_nc(:,:)
    double precision, allocatable :: val_dim_meteo_nc(:,:)
    character(256), allocatable :: unit_dim_nc(:)
    character(256), allocatable :: unit_dim_meteo_nc(:)
    
    integer surface_level_nc
    
    !Indicates the centre of the EMEP local fraction distance array. Set in uEMEP_read_EMEP and used in uEMEP_subgrid_EMEP
    !Source of a significant bug up to febuary 2021 when the EMEP lf grid used in the interpolation were not the same
    integer :: xdist_centre_nc=0,ydist_centre_nc=0
    
    !Declare road link data arrays
    real, allocatable :: inputdata_rl(:,:)
    integer, allocatable :: inputdata_int_rl(:,:)
    real, allocatable :: inputdata_rl_emissions(:,:,:)
    logical :: use_NORTRIP_emission_data=.false.
    logical :: use_NORTRIP_emission_pollutant(n_pollutant_nc_index)=.true.
    logical, allocatable :: valid_link_flag(:)
    
    !Road link (rl) indexes
    integer x1_rl_index,x2_rl_index,y1_rl_index,y2_rl_index,x0_rl_index,y0_rl_index
    parameter (x1_rl_index=1,x2_rl_index=2,y1_rl_index=3,y2_rl_index=4,x0_rl_index=5,y0_rl_index=6)
    integer lon1_rl_index,lon2_rl_index,lat1_rl_index,lat2_rl_index,lon0_rl_index,lat0_rl_index
    parameter (lon1_rl_index=7,lon2_rl_index=8,lat1_rl_index=9,lat2_rl_index=10,lon0_rl_index=11,lat0_rl_index=12)
    integer length_rl_index,z0_rl_index,width_rl_index
    parameter (length_rl_index=13,z0_rl_index=14,width_rl_index=15)
    integer adt_rl_index,speed_rl_index,hdv_rl_index,tunnel_length_rl_index
    parameter (adt_rl_index=16,speed_rl_index=17,hdv_rl_index=18,tunnel_length_rl_index=19)
    integer num_var_rl
    parameter(num_var_rl=19)

    integer id_rl_index,roadtype_rl_index,nlanes_rl_index,major_index_rl_index
    parameter (id_rl_index=1,roadtype_rl_index=2,nlanes_rl_index=3,major_index_rl_index=4)
    integer num_int_rl
    parameter(num_int_rl=4)

    !Declare file and path names for input roadlink files
    character(256) filename_rl(2)
    character(256) pathname_rl(2)
    character(256) pathfilename_rl(2)
    !Filenames for multiple road link (mrl) files
    integer :: num_multiple_roadlink_files=0
    character(256) filename_mrl(50)
    character(256) pathname_mrl(50)
    character(256) pathfilename_mrl(50)

    character(256) file_tag

    !Declare ais shiping data arrays
    !real, allocatable :: inputdata_ship(:,:)
    !integer, allocatable :: inputdata_int_ship(:,:)
    !character(8), allocatable :: inputdata_char_ship(:,:)
    
    !Input shipping (ship) indexes ddlatitude;ddlongitude;totalnoxemission;totalparticulatematteremission;fk_vessellloydstype;fk_ais_norwegianmainvesselcategory;date;time
    integer lon_ship_index,lat_ship_index,nox_ship_index,tpm_ship_index
    parameter (lon_ship_index=1,lat_ship_index=2,nox_ship_index=3,tpm_ship_index=4)
    integer num_var_ship
    parameter(num_var_ship=4)

    integer idloyds_ship_index,idnorwegian_ship_index
    parameter (idloyds_ship_index=1,idnorwegian_ship_index=2)
    integer num_int_ship
    parameter(num_int_ship=2)

    integer date_ship_index,time_ship_index
    parameter (date_ship_index=1,time_ship_index=2)
    integer num_char_ship,num_char_rl
    parameter(num_char_rl=2)

    !Declare file and path names for shipping ais files
    character(256) filename_ship(2)
    character(256) pathname_ship(2)
    character(256) pathfilename_ship(2)
    
    !Input agriculture
    integer lon_agriculture_index,lat_agriculture_index,nh3_agriculture_index
    parameter (lon_agriculture_index=1,lat_agriculture_index=2,nh3_agriculture_index=3)
    integer num_var_agriculture
    parameter(num_var_agriculture=3)

    !Declare file and path names for input agriculture rivm files
    character(256) filename_agriculture(2)
    character(256) pathname_agriculture(2)
    character(256) pathfilename_agriculture(2)

    !Declare file and path names for input emission rivm files
    character(256) filename_emission_rivm(2)
    character(256) pathname_emission_rivm(2)
    character(256) pathfilename_emission_rivm(2)

    !Declare file and path names for SSB building and population files
    !Check this, should be limitted by n_population_index=8 but really not necessary
    character(256) filename_heating(10)
    character(256) pathname_heating(10)
    character(256) pathfilename_heating(10)
    
    character(256) filename_industry(10)
    character(256) pathname_industry(10)
    character(256) pathfilename_industry(10)
    
    !integer traffic_emission_file_index,traffic_proxy_file_index,traffic_proxy_integral_file_index
    !parameter (traffic_emission_file_index=1,traffic_proxy_file_index=2,traffic_proxy_integral_file_index=3)
    
    !integer shipping_emission_file_index,shipping_proxy_file_index,shipping_proxy_integral_file_index
    !parameter (shipping_emission_file_index=4,shipping_proxy_file_index=5,shipping_proxy_integral_file_index=6)
    
    !integer emep_traffic_input_file_index,emep_traffic_subgrid_file_index,emep_traffic_subgrid_lf_file_index,traffic_subgrid_local_file_index
    !parameter(emep_traffic_input_file_index=7,emep_subgrid_file_index=8,emep_subgrid_frac_file_index=9,subgrid_local_file_index=10)
    
    !integer emep_shipping_input_file_index,emep_shipping_subgrid_file_index,emep_shipping_subgrid_lf_file_index,shipping_subgrid_local_file_index
    !parameter(emep_shipping_input_file_index=11,emep_shipping_subgrid_file_index=12,emep_shipping_subgrid_lf_file_index=13,shipping_subgrid_local_file_index=14)
    
    !integer subgrid_uwind_file_index,subgrid_vwind_file_index,subgrid_hmix_file_index,subgrid_kz_file_index
    !parameter (subgrid_uwind_file_index=15,subgrid_vwind_file_index=16,subgrid_hmix_file_index=17,subgrid_kz_file_index=18)
    
    !integer emep_agriculture_input_file_index,emep_agriculture_subgrid_file_index,emep_agriculture_subgrid_lf_file_index,agriculture_subgrid_local_file_index
    !parameter(emep_agriculture_input_file_index=19,emep_agriculture_subgrid_file_index=20,emep_agriculture_subgrid_lf_file_index=21,agriculture_subgrid_local_file_index=22)
 
    !integer agriculture_emission_file_index,agriculture_proxy_file_index,agriculture_proxy_integral_file_index
    !parameter (agriculture_emission_file_index=23,agriculture_proxy_file_index=24,agriculture_proxy_integral_file_index=25)

    !Definition of the EMEP file to be read. Two files. 1 is base file and 2 is uEMEP file
    character(256) filename_EMEP(4)
    character(256) pathname_EMEP(4)
    character(256) pathfilename_EMEP(4)  !Combined path and filename
    character(256) original_filename_EMEP(4)
    character(256) original_pathname_EMEP(4)

    !Definition of the receptor file to be read.
    character(256) filename_receptor
    character(256) pathname_receptor
    character(256) pathfilename_receptor  !Combined path and filename

    !Definition of the timeprofilefile to be read.
    character(256) filename_timeprofile
    character(256) pathname_timeprofile
    character(256) pathfilename_timeprofile  !Combined path and filename

    !Declaration for all filenames used to save gridded data produced by uEMEP. Up to 200 file names but of course can be more
    integer n_filenames_grid
    parameter (n_filenames_grid=500)
    character(256) filename_grid(n_filenames_grid)
    character(256) pathname_grid(n_filenames_grid)
    character(256) pathfilename_grid(n_filenames_grid)  !Combined path and filename
    character(256) pathname_output_grid
    character(256) :: filename_date_output_grid='<replace_date>_<replace_hour>'
        
    !integer traffic_param_index,shipping_param_index,heating_param_index,agriculture_param_index
    !parameter (traffic_param_index=1,shipping_param_index=2,heating_param_index=3,agriculture_param_index=4)
    !integer num_param_index
    !parameter (num_param_index=4)
    
    !Declare subgrid variable indexes for 'subgrid' array
    integer proxy_subgrid_index,proxy_integral_subgrid_index
    integer scaling_factor_subgrid_index,local_subgrid_index,nonlocal_subgrid_index,total_subgrid_index
    integer emep_subgrid_index,emep_frac_subgrid_index,emep_local_subgrid_index,emep_nonlocal_subgrid_index,emep_additional_local_subgrid_index,emep_additional_nonlocal_subgrid_index
    integer drydepo_local_subgrid_index,wetdepo_local_subgrid_index,drydepo_nonlocal_subgrid_index,wetdepo_nonlocal_subgrid_index
    parameter (proxy_subgrid_index=1,proxy_integral_subgrid_index=2)
    parameter (scaling_factor_subgrid_index=3,local_subgrid_index=4,nonlocal_subgrid_index=5,total_subgrid_index=6)
    parameter (emep_subgrid_index=7,emep_frac_subgrid_index=8,emep_local_subgrid_index=9,emep_nonlocal_subgrid_index=10,emep_additional_local_subgrid_index=11,emep_additional_nonlocal_subgrid_index=12)
    parameter (drydepo_local_subgrid_index=13,wetdepo_local_subgrid_index=14,drydepo_nonlocal_subgrid_index=15,wetdepo_nonlocal_subgrid_index=16)
    integer n_subgrid_index
    parameter (n_subgrid_index=16)

    !Declare meteo subgrid variables. Does nothave to be the same as the nc version
    integer ugrid_subgrid_index,vgrid_subgrid_index,FF10_subgrid_index,FFgrid_subgrid_index,inv_FFgrid_subgrid_index,inv_FF10_subgrid_index
    integer hmix_subgrid_index,kz_subgrid_index,invL_subgrid_index,ustar_subgrid_index,logz0_subgrid_index,J_subgrid_index,t2m_subgrid_index,cos_subgrid_index,sin_subgrid_index,precip_subgrid_index
    integer u10_subgrid_index,v10_subgrid_index,phi_index
    parameter (ugrid_subgrid_index=1,vgrid_subgrid_index=2,FF10_subgrid_index=3,FFgrid_subgrid_index=4,inv_FFgrid_subgrid_index=5,inv_FF10_subgrid_index=6)
    parameter (hmix_subgrid_index=7,kz_subgrid_index=8,invL_subgrid_index=9,ustar_subgrid_index=10,logz0_subgrid_index=11,J_subgrid_index=12,t2m_subgrid_index=13,cos_subgrid_index=14,sin_subgrid_index=15,precip_subgrid_index=16)
    parameter (u10_subgrid_index=17,v10_subgrid_index=18,phi_index=19)
    integer n_meteo_subgrid_index
    parameter (n_meteo_subgrid_index=19)

    !Declare compound indexes for the subgrid. Same as nc_index values for compounds. Must be converted when necessary
    integer no2_index,nox_index,pm25_index,pm10_index,nh3_index,o3_index,so2_index,pmex_index,no_index
    parameter (no2_index=1,nox_index=2,pm25_index=3,pm10_index=4,nh3_index=5,o3_index=6,so2_index=7,pmex_index=8)
    !Additional for nh3 compounds
    integer nh4_index
    parameter (nh4_index=9)
    integer pm25_sand_index,pm10_sand_index,pm25_salt_index,pm10_salt_index
    parameter (pm25_sand_index=10,pm10_sand_index=11,pm25_salt_index=12,pm10_salt_index=13)
    !Additional compounds
    integer c6h6_index,bap_index,co_index,somo35_index,comax_index,o3max_index,o3_26th_index
    parameter (c6h6_index=14,bap_index=15,co_index=16,somo35_index=17,comax_index=18,o3max_index=19,o3_26th_index=20)
    integer n_compound_index
    parameter (n_compound_index=20)
    
    !Declare source indexes (type_source) must be the same as source_nc_index
    integer allsource_index,traffic_index,shipping_index,heating_index,agriculture_index,industry_index
    parameter (allsource_index=1,traffic_index=2,shipping_index=3,heating_index=4,agriculture_index=5,industry_index=6)
    integer n_source_index,n_source_calculate_index
    !parameter (n_source_index=6)
    !All the other GNFR emissions
    integer publicpower_index,fugitive_index,solvents_index,aviation_index,offroad_index,waste_index,livestock_index,other_index
    integer traffic_exhaust_index,traffic_nonexhaust_index
    parameter (publicpower_index=7,fugitive_index=8,solvents_index=9,aviation_index=10,offroad_index=11,waste_index=12,livestock_index=13,other_index=14)
    parameter (traffic_exhaust_index=15,traffic_nonexhaust_index=16) !Not used
    parameter (n_source_index=16,n_source_calculate_index=14)
    integer compound_source_index(n_compound_index,n_source_index)
    
    character(256) source_file_postfix(n_source_nc_index)
    logical :: calculate_source(n_source_nc_index)=.false.
    logical :: calculate_EMEP_source(n_source_nc_index)=.false.
    logical :: save_EMEP_source(n_source_nc_index)=.false.
    logical :: make_EMEP_grid_emission_data(n_source_nc_index)=.false.
    logical :: replace_EMEP_local_with_subgrid_local(n_source_nc_index)=.false.
    !logical combine_emission_subsources_during_dispersion(n_source_index)

    integer x_dim_index,y_dim_index,t_dim_index,n_dim_index
    parameter (x_dim_index=1,y_dim_index=2,t_dim_index=3,n_dim_index=3)
    
    !Target redistribution grid, the same for all sources and compounds
    !subgrid (i,j,t,type_subgrid,type_source,type_subsource)
    integer subgrid_dim(n_dim_index)
    real subgrid_delta(2),subgrid_min(2),subgrid_max(2)   !Only x and y
    real subgrid_proj_min(2),subgrid_proj_max(2)   !Only x and y
    integer init_subgrid_dim(n_dim_index)
    real init_subgrid_delta(2),init_subgrid_min(2),init_subgrid_max(2)   !Only x and y
    real, allocatable :: subgrid(:,:,:,:,:,:)
    real, allocatable :: meteo_subgrid(:,:,:,:)
    real, allocatable :: last_meteo_subgrid(:,:,:)
    real, allocatable :: comp_subgrid(:,:,:,:)
    real, allocatable :: comp_EMEP_subgrid(:,:,:,:)
    real, allocatable :: orig_EMEP_subgrid(:,:,:,:)
    real, allocatable :: x_subgrid(:,:)
    real, allocatable :: y_subgrid(:,:)
    real, allocatable :: lon_subgrid(:,:)
    real, allocatable :: lat_subgrid(:,:)
    real, allocatable :: xproj_subgrid(:,:)
    real, allocatable :: yproj_subgrid(:,:)
    real, allocatable :: traveltime_subgrid(:,:,:,:,:)
    real, allocatable :: exposure_subgrid(:,:,:,:,:)
    integer subgrid_loop_index(2)               !Number of target subgrids to loop through, limitted by the size of the EMEP grid
    integer integral_subgrid_loop_index(2)      !Number of integral subgrids to loop through, limitted by the size of the EMEP grid
    integer emission_subgrid_loop_index(2,n_source_index)      !Number of emission subgrids to loop through, limitted by the size of the EMEP grid
    integer init_emission_subgrid_loop_index(2,n_source_index)      !Number of emission subgrids to loop through, limitted by the size of the EMEP grid
    logical, allocatable :: use_subgrid(:,:,:)    !Specifies if calculations are to be made at a particular set of target subgrids or not
    integer, allocatable :: use_subgrid_val(:,:,:) !Same as use_subgrid but given a value to indicate if it is in the buffer zone of a region ore not
    integer, allocatable :: use_subgrid_interpolation_index(:,:,:) !Assigns the resolution level for auto gridding to the target grid
    integer n_use_subgrid_levels(n_source_index)
    logical :: use_emission_positions_for_auto_subgrid_flag(n_source_index)=.false.

    real :: loop_index_scale=1.5
    real :: buffer_index_scale=1.5
    
    !Emission subgrid per source and subsource. Can be time dependent
    !Each source type has its own x and y and dim
    !Each source may be of lesser dimensions than the total array size (which is the same as the target grid)
    integer n_possible_subsource
    parameter (n_possible_subsource=2)
    integer :: n_subsource(n_source_index)=1 !Initialise the number of actual emission subsources to 1 for all subsources
    character(2) subsource_str(n_possible_subsource)
    
    integer emission_h_index,emission,emission_sigz00_index,emission_sigy00_index,emission_minFF_index,n_emission_index
    parameter (emission_h_index=1,emission_sigz00_index=2,emission_sigy00_index=3,emission_minFF_index=4,n_emission_index=4)
    
    integer emission_subgrid_dim(n_dim_index,n_source_index)
    integer emission_max_subgrid_dim(n_dim_index)
    real emission_subgrid_delta(2,n_source_index),emission_subgrid_min(2,n_source_index),emission_subgrid_max(2,n_source_index)  !Only x and y
    integer init_emission_subgrid_dim(n_dim_index,n_source_index)
    real init_emission_subgrid_delta(2,n_source_index),init_emission_subgrid_min(2,n_source_index),init_emission_subgrid_max(2,n_source_index)  !Only x and y
    !emission_subgrid (i,j,t,n_source,n_subsource)
    real, allocatable :: emission_subgrid(:,:,:,:,:)
    real, allocatable :: proxy_emission_subgrid(:,:,:,:) !No time dependence
    real, allocatable :: emission_time_profile_subgrid(:,:,:,:,:)
    real, allocatable :: emission_properties_subgrid(:,:,:,:) !No time dependence and no pollutant dependence. Would then need to do the gaussian calculation for each pollutant
    !x_emission_subgrid (i,j,n_source)
    real, allocatable :: x_emission_subgrid(:,:,:)
    real, allocatable :: y_emission_subgrid(:,:,:)
    real, allocatable :: lon_emission_subgrid(:,:,:)
    real, allocatable :: lat_emission_subgrid(:,:,:)
    real, allocatable :: xproj_emission_subgrid(:,:,:)
    real, allocatable :: yproj_emission_subgrid(:,:,:)
    
    logical :: use_buffer_zone=.true.
    integer buffer_index(2)
    real    buffer_size(2)
    integer emission_buffer_index(2,n_source_index)
    real    emission_buffer_size(2,n_source_index)
    integer init_emission_buffer_index(2,n_source_index)
    real    init_emission_buffer_size(2,n_source_index)
    integer integral_buffer_index(2)
    real    integral_buffer_size(2)

    integer  hsurf_integral_subgrid_index,hmix_integral_subgrid_index,hsurf_average_subgrid_index,n_integral_subgrid_index
    parameter (hsurf_integral_subgrid_index=1,hmix_integral_subgrid_index=2,hsurf_average_subgrid_index=3,n_integral_subgrid_index=3)

    integer integral_subgrid_dim(n_dim_index)
    real :: integral_subgrid_delta_ref=0.
    real :: integral_subgrid_delta(2)=0.
    real integral_subgrid_min(2),integral_subgrid_max(2)  !Only x and y
    !emission_subgrid (i,j,t,n_inegral_type,n_source,n_pollutant)
    real, allocatable :: integral_subgrid(:,:,:,:,:,:)
    !x_emission_subgrid (i,j,n_source)
    real, allocatable :: x_integral_subgrid(:,:)
    real, allocatable :: y_integral_subgrid(:,:)
    real, allocatable :: lon_integral_subgrid(:,:)
    real, allocatable :: lat_integral_subgrid(:,:)
    real, allocatable :: xproj_integral_subgrid(:,:)
    real, allocatable :: yproj_integral_subgrid(:,:)
    real, allocatable :: meteo_nc_xproj_integral_subgrid(:,:)
    real, allocatable :: meteo_nc_yproj_integral_subgrid(:,:)

    integer population_subgrid_dim(2)
    real population_subgrid_delta(2),population_subgrid_min(2),population_subgrid_max(2)  !Only x and y
    real, allocatable :: population_subgrid(:,:,:)
    real, allocatable :: x_population_subgrid(:,:)
    real, allocatable :: y_population_subgrid(:,:)
    real, allocatable :: lon_population_subgrid(:,:)
    real, allocatable :: lat_population_subgrid(:,:)
    real, allocatable :: xproj_population_subgrid(:,:)
    real, allocatable :: yproj_population_subgrid(:,:)

    !Initial emission grid, can be different for different sources so specified individually
    !emission_subgrid(i,j,value_type)
    !integer x_emission_subgrid_index,y_emission_subgrid_index,lon_emission_subgrid_index,lat_emission_subgrid_index
    !parameter (x_emission_subgrid_index=1,y_emission_subgrid_index=2,lon_emission_subgrid_index=3,lat_emission_subgrid_index=4)
    !integer n_possible_emission_subgrids
    !parameter (n_possible_emission_subgrids=5)
    !integer proxy_emission_subgrid_index(n_possible_emission_subgrids) !5 possible emission subgrids for each emission source
    !integer :: n_emission(n_source_index)=1 !Initialise the number of possible emission subgrids to 1 for all subsources
    !integer n_emission_subgrid_index
    !parameter (n_emission_subgrid_index=9) !4+5
    
    !integer traffic_emission_subgrid_dim(2)
    !real traffic_emission_subgrid_delta(2),traffic_emission_subgrid_min(2),traffic_emission_subgrid_max(2)
    !real, allocatable :: traffic_emission_subgrid(:,:,:)
    !integer shipping_emission_subgrid_dim(2)
    !real shipping_emission_subgrid_delta(2),shipping_emission_subgrid_min(2),shipping_emission_subgrid_max(2)
    !real, allocatable :: shipping_emission_subgrid(:,:,:)
    !integer agriculture_emission_subgrid_dim(2)
    !real agriculture_emission_subgrid_delta(2),agriculture_emission_subgrid_min(2),agriculture_emission_subgrid_max(2)
    !real, allocatable :: agriculture_emission_subgrid(:,:,:)
    !integer heating_emission_subgrid_dim(2)
    !real heating_emission_subgrid_delta(2),heating_emission_subgrid_min(2),heating_emission_subgrid_max(2)
    !real, allocatable :: heating_emission_subgrid(:,:,:)
    
    !
    integer, allocatable :: crossreference_target_to_emep_subgrid(:,:,:) !(i,j,dim)
    integer, allocatable :: crossreference_target_to_localfraction_subgrid(:,:,:,:) !(i,j,dim,n_lf_grids)
    integer, allocatable :: crossreference_integral_to_emep_subgrid(:,:,:) !(i,j,dim)
    integer, allocatable :: crossreference_integral_to_meteo_nc_subgrid(:,:,:) !(i,j,dim)
    integer, allocatable :: crossreference_target_to_integral_subgrid(:,:,:) !(i,j,dim)
    !integer, allocatable :: crossreference_emission_to_target_subgrid(:,:,:,:) !(i,j,dim,n_source)
    integer, allocatable :: crossreference_target_to_emission_subgrid(:,:,:,:) !(i,j,dim,n_source)
    integer, allocatable :: crossreference_integral_to_emission_subgrid(:,:,:,:) !(i,j,dim,n_source)
    integer, allocatable :: crossreference_emission_to_emep_subgrid(:,:,:,:) !(i,j,dim,n_source)
    integer, allocatable :: crossreference_emission_to_integral_subgrid(:,:,:,:) !(i,j,dim,n_source)
    integer, allocatable :: crossreference_target_to_population_subgrid(:,:,:) !(i,j,dim)
    !integer, allocatable :: crossreference_shipping_emission_subgrid(:,:,:)
    !integer, allocatable :: crossreference_agriculture_emission_subgrid(:,:,:)
    !integer, allocatable :: crossreference_heating_emission_subgrid(:,:,:)
    integer, allocatable :: crossreference_emission_to_deposition_subgrid(:,:,:,:) !(i,j,dim,n_source)
    integer, allocatable :: crossreference_emission_to_landuse_subgrid(:,:,:,:) !(i,j,dim,n_source)
    integer, allocatable :: crossreference_target_to_deposition_subgrid(:,:,:)!(i,j,dim)
    integer, allocatable :: crossreference_deposition_to_emep_subgrid(:,:,:) !(i,j,dim)
    
    real :: min_link_size=50.
    real :: min_adt=1000.
    real :: H_emep=90. !Height of lowest level in EMEP
    real :: H_meteo=45. !Height of the gridded meteo values 
    
    logical :: hourly_calculations=.false.
    logical :: annual_calculations=.false.
    integer :: start_month_in_annual_calculations=1
    integer :: end_month_in_annual_calculations=12
    
    !Pseudo dispersion parameters
    real z_rec(n_source_index,n_possible_subsource)
    real ay(n_source_index,n_possible_subsource),by(n_source_index,n_possible_subsource),az(n_source_index,n_possible_subsource),bz(n_source_index,n_possible_subsource)
    real sig_y_0(n_source_index,n_possible_subsource),sig_z_0(n_source_index,n_possible_subsource)
    !To be set at input
    real sig_y_00(n_source_index,n_possible_subsource),sig_z_00(n_source_index,n_possible_subsource),h_emis(n_source_index,n_possible_subsource)
    integer stability_scheme_flag
    
    real :: FF_min_dispersion=0.1
    integer :: emission_timeprofile_hour_shift=1 !Winter European time
    
    real pi
    parameter (pi=3.141592)

    !Near neighbour arrays
    !character(1) NNi_str(3),NNj_str(3)
    !character(256) NNpre_str
    !character(256) NNsource_str(n_source_index)
    !character(256) NN_name_nc(n_source_index,3,3)
    !integer NN_index(3,3)
    !integer num_NN_nc
    !parameter (num_NN_nc=9)                  ! number of readable near neighbours

    integer UTM_projection_index,RDM_projection_index,LCC_projection_index,LL_projection_index,LAEA_projection_index,LTM_projection_index,PS_projection_index
    parameter (UTM_projection_index=1,RDM_projection_index=2,LCC_projection_index=3,LL_projection_index=4,LAEA_projection_index=5,LTM_projection_index=6,PS_projection_index=7)
    integer :: projection_type=UTM_projection_index
    integer :: EMEP_projection_type=LCC_projection_index
    double precision :: EMEP_projection_attributes(10)
    double precision :: projection_attributes(10)
    double precision :: population_nc_projection_attributes(10)
    integer :: meteo_nc_projection_type=LCC_projection_index
    double precision :: meteo_nc_projection_attributes(10)
    logical :: use_alternative_LCC_projection_flag=.false.

    
    !Filename index for files produced by uEMEP
    integer proxy_emission_file_index(n_source_index),emission_file_index(n_source_index),proxy_file_index(n_source_index),proxy_integral_file_index(n_source_index)
    integer emep_subgrid_file_index(n_source_index),emep_subgrid_nonlocal_file_index(n_source_index),emep_subgrid_local_file_index(n_source_index),emep_subgrid_frac_file_index(n_source_index)
    integer subgrid_local_file_index(n_source_index),subgrid_total_file_index(n_source_index)
    integer emep_additional_subgrid_nonlocal_file_index(n_source_index),emep_additional_subgrid_local_file_index(n_source_index)
    !Filename index for meteorological parameters
    integer subgrid_ugrid_file_index,subgrid_vgrid_file_index,subgrid_u10_file_index,subgrid_v10_file_index,subgrid_hmix_file_index,subgrid_kz_file_index,subgrid_logz0_file_index,subgrid_invL_file_index,subgrid_FF10_file_index,subgrid_FFgrid_file_index
    integer subgrid_invFF10_file_index,subgrid_invFFgrid_file_index,subgrid_ustar_file_index,subgrid_J_file_index,subgrid_meteo_file_index
    integer subgrid_DD10_file_index,subgrid_DDgrid_file_index,subgrid_t2m_file_index
    !Filename index for grid auto grid parameters
    integer use_subgrid_file_index(n_source_index)
    integer emep_emission_subgrid_file_index(n_source_index)
    
    character(256) :: source_file_str(n_source_nc_index)=''
    real :: unit_conversion(n_source_index)=1.
    
    real :: emission_factor_conversion(n_compound_nc_index,n_source_index,n_possible_subsource)=0.
    real :: emission_factor(n_compound_nc_index,n_source_index,n_possible_subsource)=1.
    real :: ratio_truck_car_emission(n_compound_nc_index)=10.
    
    integer :: integral_subgrid_step=1
    integer :: weighting_step=1

    real :: limit_shipping_delta=250.
    real :: limit_heating_delta=250.
    real :: limit_industry_delta=250.
    real :: limit_population_delta=250.
    real :: traj_step_scale=2.
    
    integer :: start_time_nc_index=1
    integer :: end_time_nc_index=1
    integer :: start_time_meteo_nc_index=1
    integer :: end_time_meteo_nc_index=1
    integer :: ref_year_EMEP=1900
    integer :: ref_year_meteo=1970

    integer :: EMEP_emission_grid_interpolation_flag=0
    logical :: subgrid_emission_distribution_flag=.false.  !If true then distributes the EMEP emissions to the existing emission subgrid
    logical :: use_downwind_position_flag=.false.           !If true then searches the upwind EMEP grid position for emissions
    logical :: use_trajectory_flag(n_source_index)=.false.
    integer :: no2_chemistry_scheme_flag=1
    integer :: wind_level_flag=3
    integer :: wind_level_integral_flag=3
    logical :: use_receptor_positions_for_auto_subgrid_flag=.false.
    logical :: interpolate_subgrids_flag=.false.
    logical :: use_aggregated_shipping_emissions_flag=.true.
    logical :: calculate_aggregated_shipping_emissions_flag=.false.
    logical :: average_zc_h_in_Kz_flag=.true.
    logical :: wind_level_zc_flag=.false. !This will use the centre of mass wind no matter what type of wind_level_flag is used

    
    integer n_receptor,n_receptor_in,n_receptor_max,n_valid_receptor,n_valid_receptor_in
    parameter (n_receptor_max=20000)
    real lon_receptor(n_receptor_max),lat_receptor(n_receptor_max),x_receptor(n_receptor_max),y_receptor(n_receptor_max),height_receptor(n_receptor_max)
    real lon_receptor_in(n_receptor_max),lat_receptor_in(n_receptor_max),x_receptor_in(n_receptor_max),y_receptor_in(n_receptor_max),height_receptor_in(n_receptor_max)
    integer i_receptor_subgrid(n_receptor_max),j_receptor_subgrid(n_receptor_max)
    character(256) name_receptor(n_receptor_max,2)
    character(256) name_receptor_in(n_receptor_max,2)
    logical :: use_receptor(n_receptor_max)=.true.
    integer :: use_receptor_region=1 !Surrounding grid region when just running for receptors
    integer valid_receptor_index(n_receptor_max)
    integer valid_receptor_inverse_index(n_receptor_max)
    
    !Indicies for SSB building and population data
    integer dwelling_index,population_index,establishment_index,school_index,kindergaten_index,home_index,municipality_index,RWC_heating_index,n_population_index
    parameter(dwelling_index=1,population_index=2,establishment_index=3,school_index=4,kindergaten_index=5,home_index=6,municipality_index=7,RWC_heating_index=8,n_population_index=8)
    integer population_file_index(n_population_index)
    
    character(256) filename_population(n_population_index),pathname_population(n_population_index),pathfilename_population(n_population_index)
    
    !Is a temporary variable set when reading SSB data
    integer :: SSB_data_type=dwelling_index
    
    logical :: calculate_population_exposure_flag=.false.
    logical :: use_population_positions_for_auto_subgrid_flag=.false.
    integer :: population_data_type=population_index
    
    logical :: use_multiple_receptor_grids_flag=.false.
    integer :: n_receptor_grid
    integer start_grid_loop_index,end_grid_loop_index
    integer g_loop
    
    logical :: use_last_meteo_in_dispersion=.false.
    logical :: use_meandering_in_dispersion=.false.
    logical :: use_traffic_for_sigma0_flag=.false.
!    logical :: use_traffic_for_minFF_flag=.false.
    logical :: use_alternative_meteorology_flag=.false.
    character(256) :: alternative_meteorology_type='meps'
    logical :: use_alternative_z0_flag=.false.
    logical :: save_netcdf_file_flag=.false.
    logical :: save_netcdf_receptor_flag=.false.
    logical :: save_netcdf_fraction_as_contribution_flag=.false.
    logical :: calculate_tiling_flag=.false.
    logical :: calculate_region_tiling_flag=.false.
    
    !Some testing and scaling values
    real :: replace_z0=NODATA_value  !Will not replace z0 when it has a NODATA value
    real :: replace_invL=NODATA_value  !Will not replace invL when it has a NODATA value
    real :: replace_hmix=NODATA_value  !Will not replace mix when it has a NODATA value
	real :: FF_scale=NODATA_value
	real :: FF10_offset=NODATA_value
	real :: DD_offset=NODATA_value
	real :: J_scale=NODATA_value
    
    real :: hmix_max=2000.
    real :: hmix_min=25.
    real :: ustar_min=0.001

    character(256) :: pathname_tiles=''
    character(256) :: filename_tiles=''
    character(256) :: tile_tag=''
    character(256) :: save_tile_tag=''
    
    !Correction output time array converting days 1900 to seconds 2000
    integer(4), allocatable :: time_seconds_output(:)
    
    !Residential wood combustion variables
    integer n_RWC_grids
    real, allocatable :: RWC_grid_emission(:,:)
    real, allocatable :: RWC_grid_HDD(:,:)
    integer*8, allocatable :: RWC_grid_id(:)
    integer, allocatable :: RWC_region_id(:)
    real, allocatable :: RWC_grid_height(:,:)
    real, allocatable :: DMT_EMEP_grid_nc(:,:,:)
    integer :: HDD_threshold_value=15
    real :: DMT_min_value=-20. !Minimum allowable daily mean temperature for heating degree day calculation
    logical :: use_RWC_emission_data=.false.
    character(256) :: pathfilename_region_heating_scaling=''
    character(256) :: inpath_region_heating_scaling=''
    character(256) :: infile_region_heating_scaling=''
    
    !Forecast hour string for writing to files
    character(256) :: forecast_hour_str='00'
    character(256) :: NORTRIP_hour_str='01'
    
    !Scenario calculator variables
    character(256) :: pathname_rl_change=''
    character(256) :: filename_rl_change=''
    
    real aqi_hourly_limits(n_compound_index,1:3),aqi_daily_limits(n_compound_index,1:3),aqi_annual_limits(n_compound_index,1:3)
    
    logical :: include_o3_in_aqi_index=.false.

    integer :: n_kz_iterations=2
    
    !Special source allocation for no2 based on leaving out the source in the chemistry calculation
    real, allocatable :: comp_source_subgrid(:,:,:,:,:)
    real, allocatable :: comp_source_additional_subgrid(:,:,:,:,:)
    real, allocatable :: comp_source_EMEP_subgrid(:,:,:,:,:)
    real, allocatable :: comp_source_EMEP_additional_subgrid(:,:,:,:,:)
    
    logical :: save_emissions_for_EMEP(n_source_index)=.false.
    character(256) :: pathname_emissions_for_EMEP=''
    integer :: save_emissions_start_index=1
	integer :: save_emissions_end_index=24
    character(256) :: save_emissions_for_EMEP_projection='lambert'
    character(256) :: save_emissions_for_EMEP_region='NO'

    logical :: read_weekly_shipping_data_flag=.false.
    logical :: read_monthly_and_daily_shipping_data_flag=.false.
    
    logical :: use_tunnel_deposition_flag=.false.
    logical :: use_tunnel_emissions_flag=.true.
    real :: ventilation_factor=1.
    real :: windspeed_tunnel=1.
    real :: min_length_ventilation_factor=0.
    real :: min_ADT_ventilation_factor=0.
    
    real :: tunnel_sig_z_00=5.
    !Bridge height not in use yet
    real :: bridge_h_emis=10.
    
    real :: sigy_0_subgid_width_scale=0.25
    real :: lowest_stable_L=1.e6
    real :: lowest_unstable_L=-10.
    
    logical :: use_traffic_nox_emission_temperature_dependency=.false.
    real :: traffic_nox_emission_temperature_ref_temperature(2)
    real :: traffic_nox_emission_temperature_ref_scaling(2)
    
    !Output data saving flags
    logical :: save_compounds=.true.,save_source_contributions=.true.,save_wind_vectors=.false.,save_other_meteo=.false.
    logical :: save_emep_source_contributions=.false.,save_emep_original=.true.,save_emissions=.false.,save_for_chemistry=.false.
    logical :: save_population=.false.,save_no2_source_contributions=.true.,save_o3_source_contributions=.true.
    logical :: save_aqi=.true.
    logical :: save_emep_species=.false.
    logical :: save_emep_OP_species=.false.
    logical :: save_deposition=.false.
    logical :: save_seasalt=.false.

    !Region ID file names
    character(256) :: pathfilename_region_id=''
    character(256) :: pathname_region_id=''
    character(256) :: filename_region_id=''
    character(256) :: region_name=''
    integer :: region_id=0
    integer :: region_index=0
    real :: region_subgrid_delta=50.
    logical :: use_region_select_and_mask_flag=.false.
    real :: max_interpolation_subgrid_size=1000.
    
    !Set the scaling factors for the auto gridding routine
    integer use_subgrid_step_delta(0:10)
    
    integer outside_region_index,outside_interpolation_region_index,inside_region_index
    parameter (outside_region_index=-1,outside_interpolation_region_index=-2,inside_region_index=0)

    !Variables for saving averages
    integer :: n_var_av=100  !Maximum number of variables to be saved as averages
    logical :: save_netcdf_average_flag=.false.
    real, allocatable :: val_array_av(:,:,:)
    integer(8), allocatable :: time_seconds_output_av(:)
    integer :: counter_av=0

    !Species variables
    integer pm10_sp_index,pm25_sp_index,pmco_sp_index,n_pmxx_sp_index
    parameter (pm10_sp_index=1,pm25_sp_index=2,pmco_sp_index=3,n_pmxx_sp_index=3) !pmco_sp_index is just for reading
    integer sp_soa_index,sp_sia_index,sp_dust_index,sp_seasalt_index,sp_ffire_index,sp_ppm_index,sp_water_index,sp_pm_index,n_sp_index
    parameter (sp_soa_index=1,sp_sia_index=2,sp_dust_index=3,sp_seasalt_index=4,sp_ffire_index=5,sp_ppm_index=6,sp_water_index=7,sp_pm_index=8)
    parameter (n_sp_index=8)
    !Additional BBOA species used in the OP calculations
    integer sp_BBOA_index,sp_BBOA_RES_index,sp_asoa_index,sp_bsoa_index,n_sp_OP_index
    parameter (sp_BBOA_index=9,sp_BBOA_RES_index=10,sp_asoa_index=11,sp_bsoa_index=12)
    parameter (n_sp_OP_index=12)
    !These are used just for reading
    integer sp_no3_index,sp_so4_index,sp_nh4_index,sp_dust_sah_index,sp_dust_wb_index,sp_ffire_bc_index,sp_ffire_rem_index,n_sp_all_index
    parameter (sp_no3_index=13,sp_so4_index=14,sp_nh4_index=15,sp_dust_sah_index=16,sp_dust_wb_index=17,sp_ffire_bc_index=18,sp_ffire_rem_index=19)
    !Alternative input names so the other names are reserved for otuput
    integer sp_soa_in_index,sp_sia_in_index,sp_dust_in_index,sp_seasalt_in_index,sp_ffire_in_index,sp_ppm_in_index,sp_water_in_index,sp_pm_in_index
    parameter (sp_soa_in_index=20,sp_sia_in_index=21,sp_dust_in_index=22,sp_seasalt_in_index=23,sp_ffire_in_index=24,sp_ppm_in_index=25,sp_water_in_index=26,sp_pm_in_index=27)
    !Alternative input names for OP so the other names are reserved for otuput
    integer sp_POM_RES_in_index,sp_EC_RES_NEW_in_index,sp_EC_RES_AGE_in_index,sp_REM_RES_in_index,sp_FFIRE_OM_in_index,sp_FFIRE_BC_in_index,sp_FFIRE_REM_in_index,sp_EC_RES_in_index,sp_asoa_in_index,sp_bsoa_in_index
    parameter (sp_POM_RES_in_index=28,sp_EC_RES_NEW_in_index=29,sp_EC_RES_AGE_in_index=30,sp_REM_RES_in_index=31,sp_FFIRE_OM_in_index=32,sp_FFIRE_BC_in_index=33,sp_FFIRE_REM_in_index=34,sp_EC_RES_in_index=35,sp_asoa_in_index=36,sp_bsoa_in_index=37)
    parameter (n_sp_all_index=37) !For array dimensions only
    
    real, allocatable :: species_var3d_nc(:,:,:,:,:) !(x,y,t,n_pmxx_sp_index,n_species_loop_index)
    real, allocatable :: species_EMEP_subgrid(:,:,:,:,:) !(x,y,t,n_pmxx_sp_index,n_species_loop_index)
    integer :: species_loop_index(n_sp_all_index)
    integer :: n_species_loop_index=n_sp_index !Variable length of species list, set in uEMEP_set_species_loop
    
    !Dimmension with the largest possible, including OP
    character(256) species_name_nc(n_pmxx_sp_index,n_sp_all_index)
    
    !Deposition and land use
    real, allocatable :: orig_EMEP_deposition_subgrid(:,:,:,:,:)
    real, allocatable :: depo_var3d_nc(:,:,:,:,:)
    integer deposition_subgrid_dim(n_dim_index)
    real :: deposition_subgrid_delta(2)=0
    real deposition_subgrid_min(2),deposition_subgrid_max(2)  !Only x and y
    !deposition_subgrid (i,j,t,n_deposition_index,n_pollutant_loop)
    integer vd_index,drydepo_index,wetdepo_index,n_deposition_index
    parameter (vd_index=1,drydepo_index=2,wetdepo_index=3,n_deposition_index=3)
    real, allocatable :: deposition_subgrid(:,:,:,:,:)
    real, allocatable :: x_deposition_subgrid(:,:)
    real, allocatable :: y_deposition_subgrid(:,:)
    real, allocatable :: lon_deposition_subgrid(:,:)
    real, allocatable :: lat_deposition_subgrid(:,:)
    real, allocatable :: xproj_deposition_subgrid(:,:)
    real, allocatable :: yproj_deposition_subgrid(:,:)
    integer deposition_subgrid_loop_index(2)
    integer deposition_buffer_index(2)
    real deposition_buffer_size(2)
    
    real wetdepo_scavanging_rate(n_compound_index)
    real drydepo_vd_default(n_compound_index)
    
    integer landuse_subgrid_dim(n_dim_index)
    real :: landuse_subgrid_delta(2)=0
    real landuse_subgrid_min(2),landuse_subgrid_max(2)  !Only x and y
    !landuse_subgrid (i,j,n_landuse_index) Fraction of landuse type
    integer temp_conif_index,temp_decid_index,med_needle_index,med_broadleaf_index,temp_crop_index,med_crop_index,root_crop_index
    integer moorland_index,grass_index,medscrub_index,wetlands_index,tundra_index,desert_index,water_index,ice_index,urban_index,grid_index,clc_index,n_landuse_index
    parameter (temp_conif_index=1,temp_decid_index=2,med_needle_index=3,med_broadleaf_index=4,temp_crop_index=5,med_crop_index=6,root_crop_index=7)
    parameter (moorland_index=8,grass_index=9,medscrub_index=10,wetlands_index=11,tundra_index=12,desert_index=13,water_index=13,ice_index=14,urban_index=15,grid_index=16,clc_index=17,n_landuse_index=17)
    real, allocatable :: landuse_subgrid(:,:,:)
    real, allocatable :: x_landuse_subgrid(:,:)
    real, allocatable :: y_landuse_subgrid(:,:)
    real, allocatable :: lon_landuse_subgrid(:,:)
    real, allocatable :: lat_landuse_subgrid(:,:)
    real, allocatable :: xproj_landuse_subgrid(:,:)
    real, allocatable :: yproj_landuse_subgrid(:,:)
    integer landuse_subgrid_loop_index(2)
    integer landuse_buffer_index(2)
    real landuse_buffer_size(2)

    logical :: calculate_deposition_flag=.false.
    logical :: calculate_source_depletion_flag=.false.
    logical :: read_landuse_flag=.false.
    logical :: adjust_wetdepo_integral_to_lowest_layer_flag=.false.
    logical :: use_plume_dispersion_deposition_flag=.false.

    !Definition of the landuse file to be read.
    character(256) :: filename_landuse=''
    character(256) :: pathname_landuse=''
    character(256) :: pathfilename_landuse=''  !Combined path and filename

    character(256) deposition_name_nc(n_landuse_index,n_compound_nc_index)

    real depo_scale_nc(n_compound_nc_index)
    logical :: auto_adjustment_for_summertime=.true.
    
    logical :: use_EMEP_surface_ozone_flag=.false.
    logical :: use_EMEP_surface_compounds_flag=.false.
    logical :: use_water_in_EMEP_surface_pm_flag=.false.
    
    logical :: save_compounds_as_ascii=.false.
    
    logical :: first_g_loop=.true.

    logical :: use_GNFR_emissions_from_EMEP_flag=.false.
    logical :: use_alphabetic_GNFR_emissions_from_EMEP_flag=.false.
    logical :: use_GNFR19_emissions_from_EMEP_flag=.false.
    
    logical :: use_emission_naming_template_flag=.false.
    character(256) :: emission_naming_template_str='Sec<n>_Emis_mgm2_'
    logical :: read_OSM_roadlink_data_flag=.false.
    logical :: no_header_roadlink_data_flag=.false.

    integer :: EMEP_surface_level_nc=1
    integer :: EMEP_surface_level_nc_2=1
    
    !Define the source sector match between uEMEP and EMEP
    logical :: use_user_specified_sectors_flag=.false.
    integer :: uEMEP_to_EMEP_sector(n_source_nc_index)=0
    integer :: uEMEP_to_EMEP_replace_sector(n_source_nc_index)=0
    character(2) :: uEMEP_to_EMEP_sector_str(n_source_nc_index)=''
    character(2) :: uEMEP_to_EMEP_emis_sector_str(n_source_nc_index)=''
    
    !Define the aggregation period for EMEP emissions when these are to be used in calculations. Annual is 365*24=8760 or 8784 for leap years
    real :: EMEP_emission_aggregation_period=1.

    logical :: read_population_from_netcdf_flag=.false.
    logical :: read_population_from_netcdf_local_flag=.false.
    integer :: population_nc_projection_type=LL_projection_index
    
    logical :: auto_select_OSM_country_flag=.false.
    character(256) :: pathfilename_boundingbox=''
    character(256) :: pathname_boundingbox=''
    character(256) :: filename_boundingbox=''
    character(256) :: select_country_by_name=''

	logical :: select_latlon_centre_domain_position_flag=.false.
	real :: select_lat_centre_position=60.
	real :: select_lon_centre_position=11.
	real :: select_domain_width_EW_km=20.
	real :: select_domain_height_NS_km=20.
    
    real :: osm_adt_power_scale=1.
    
    real :: romberg_parameters(3)=0.
    real :: SRM_parameters(3)=0.
    
    real :: sig_y_scaling_factor=2.0
    
    logical :: read_shipping_from_netcdf_flag=.false.
    real :: min_proxy_emission_shipping_value=0.
    
    real :: population_power_scale=1.
    
    logical :: read_RWC_file_with_extra_HDD=.false.
    logical :: read_RWC_file_with_extra_HDD_and_height=.false.
    
    logical :: use_alternative_traveltime_weighting=.false.
    real :: traveltime_power=1.
    logical :: use_straightline_traveltime_distance=.false.
    
    !Provides a test control for adjusting the traveltime
    real :: traveltime_scaling=1.
    
    integer :: no2_background_chemistry_scheme_flag=0
    real :: f_no2_emep=0.1
    
    logical :: limit_emep_grid_interpolation_region_to_calculation_region=.false.
    
    !Additional multiple local fraction variables
    logical :: use_local_fraction_naming_template_flag=.false.
    logical :: use_local_fraction_grid_size_in_template_flag=.false.
    character(256) :: local_fraction_naming_template_str='sec<n>_local_fraction'
    integer :: n_local_fraction_grids=1
    integer max_n_local_fraction_grids
    parameter (max_n_local_fraction_grids=3)
    integer :: local_fraction_grid_size(max_n_local_fraction_grids)=1
    integer frac_nc_loop_index(max_n_local_fraction_grids),local_nc_loop_index(max_n_local_fraction_grids)
    integer lc_frac_nc_loop_index(max_n_local_fraction_grids),lc_local_nc_loop_index(max_n_local_fraction_grids)
    integer min_frac_nc_loop_index,max_frac_nc_loop_index
    integer min_lc_frac_nc_loop_index,max_lc_frac_nc_loop_index
    !integer convert_local_to_fraction_loop_index(max_n_local_fraction_grids*2)
    integer convert_frac_to_lc_frac_loop_index(num_var_nc_name)
    
    integer :: local_fraction_grid_for_EMEP_grid_interpolation=1
    integer :: local_fraction_grid_for_EMEP_grid_interpolation_source(n_source_index)=1
    integer :: local_fraction_grid_for_EMEP_additional_grid_interpolation=1
    real :: local_fraction_grid_size_scaling=1.
    real :: EMEP_grid_interpolation_size_original=1.
    real :: EMEP_grid_interpolation_size_source(n_source_index)=1.
    real :: local_fraction_additional_grid_size_scaling=1.
    real :: EMEP_additional_grid_interpolation_size_original=0.

    logical :: save_traffic_emissions_for_EMEP_as_exhaust_nonexhaust_flag=.false.
    
    character(256) :: finished_filename=''
    character(256) :: finished_file=''
    character(256) :: finished_file_rec=''
    character(256) :: finished_subpath='finished/'
    
    logical :: use_annual_mean_pdf_chemistry_correction=.false.
    logical :: quick_annual_mean_pdf_chemistry_correction=.true.
    real :: ox_sigma_ratio_pdf=0.
    real :: nox_sigma_ratio_pdf=0.
    real :: max_bin_pdf=1000.
    real :: log10_step_bin_pdf=0.05
    
    !Landuse proxy
    logical :: use_landuse_as_proxy=.false.
    logical :: read_rivm_landuse_flag=.false.
    logical :: use_rivm_agricuture_emission_data=.false.
    logical :: read_subgrid_emission_data=.false.
    logical :: use_rivm_subgrid_emission_format=.false.
    
    integer n_clc_landuse_index
    parameter (n_clc_landuse_index=44)   
    real :: landuse_proxy_weighting(n_source_index,n_clc_landuse_index)=0.
    
    !Benzene split from VOC
    logical :: extract_benzene_from_voc_emissions=.false.
    real benzene_split_voc_in_GNFR_sectors(13)
    !Default
    !BENZENE emission is scaled from VOC: sec01 * 4.0899% + sec02 * 1.5077% + sec03 * 6.6153% + sec04 * 0.975% + sec05 * 0 + sec06 * 2.4058% + sec07 * 2% + sec08 * 2.1458% + sec09 * 1.7078% + sec10 * 3.6234% + sec11 * 6.8% + sec12 * 6.8%
    !data benzene_split_voc_in_GNFR_sectors /4.0899e-2, 1.5077e-2, 6.6153e-2, 0.975e-2, 0.0, 2.4058e-2, 2.0e-2, 2.1458e-2, 1.7078e-2, 3.6234e-2, 6.8e-2, 6.8e-2, 0.0/
    !Average of countries
    data benzene_split_voc_in_GNFR_sectors /0.0449, 0.0212, 0.0668, 0.0084, 0.0, 0.0266, 0.0226, 0.0214, 0.0223, 0.0362, 0.068, 0.0601, 0.068/

    logical :: use_phi_for_invL=.false.
    real :: z_invL=10.
    
!1	0.0449
!2	0.0212
!3	0.0668
!4	0.0084
!5	0
!6	0.0266
!7	0.0226
!8	0.0214
!9	0.0223
!10	0.0362
!11	0.068
!12	0.0601
!13	0.068
!14	0.0449
!15	0.0449
!16	0.0372
!17	0.02
!18	0
!19	0.01

    real :: scale_GNFR_emission_source(n_source_index)=1.
    
    logical :: save_EMEP_somo35=.false.
    logical :: save_EMEP_comax=.false.
    logical :: save_EMEP_o3max=.false.
    logical :: save_EMEP_o3_26th=.false.
    logical :: save_EMEP_so2=.false.
    
    real :: subgrid_receptor_offset(2)=0.
    
    logical :: derive_SOA_from_other_species=.false.
    
    !1 is O'Brian, 2 is Troen
    integer :: Kz_scheme=2
    
    !Not used
    logical :: EMEP_grid_interpolation_simple_flag=.false.
    
    !Definitions of the grid when saving emissions
    integer save_emission_subgrid_dim(n_dim_index)
    real save_emission_subgrid_delta(2),save_emission_subgrid_min(2)  !Only x and y

    logical :: trace_emissions_from_in_region=.false.
    real, allocatable :: subgrid_from_in_region(:,:,:,:,:,:)
    real, allocatable :: EMEP_grid_fraction_in_region(:,:,:,:)
    real, allocatable :: lf_EMEP_grid_fraction_in_region(:,:,:,:,:,:)
    logical :: save_netcdf_fraction_as_contribution_from_in_region_flag=.false.
    logical, allocatable :: use_subgrid_region(:,:,:)    !Specifies the region emissions will be carried from for subgrid_from_in_region
    real, allocatable :: comp_subgrid_from_in_region(:,:,:,:)
    
    real, allocatable :: comp_source_subgrid_from_in_region(:,:,:,:,:)
    real, allocatable :: comp_source_additional_subgrid_from_in_region(:,:,:,:,:)
    real, allocatable :: comp_source_EMEP_subgrid_from_in_region(:,:,:,:,:)
    real, allocatable :: comp_source_EMEP_additional_subgrid_from_in_region(:,:,:,:,:)

    !Setting this to true is for diagnostic puroses. Gived the integrated lowest grid average concentration instead of the receptor
    logical :: calc_grid_vertical_average_concentration_annual_flag=.false.
    
    logical :: save_emep_region_mask=.false.
    logical :: wind_vectors_10m_available=.false.
    
    logical :: use_alternative_ppm_variable_for_lf=.false.
    integer :: alternative_ppm_variable_for_lf_dim=4
    
    end module uEMEP_definitions
    
    
