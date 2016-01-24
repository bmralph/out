MODULE TYPES

! Definitions of various derived data types

USE PRECISION_PARAMETERS
USE GLOBAL_CONSTANTS, ONLY : NULL_BOUNDARY,NEUMANN, MAX_SPECIES,IAXIS,JAXIS,KAXIS,MAX_DIM,NOD1,NOD2,IBM_MAX_WSTRIANG_SEG

IMPLICIT NONE

TYPE LAGRANGIAN_PARTICLE_CLASS_TYPE
   CHARACTER(LABEL_LENGTH) :: ID,SPEC_ID,DEVC_ID='null',CTRL_ID='null',QUANTITIES(10),SMOKEVIEW_BAR_LABEL(10),&
                    SURF_ID='null',PROP_ID='null',&
                    RADIATIVE_PROPERTY_TABLE_ID='null',CNF_RAMP_ID='null',DISTRIBUTION='ROSIN-RAMMLER-LOGNORMAL',&
                    BREAKUP_DISTRIBUTION='ROSIN-RAMMLER-LOGNORMAL',BREAKUP_CNF_RAMP_ID='null'
   CHARACTER(60) :: SMOKEVIEW_LABEL(10),QUANTITIES_SPEC_ID(10)
   REAL(EB) :: HEAT_OF_COMBUSTION,ADJUST_EVAPORATION, &
               LIFETIME,DIAMETER,MINIMUM_DIAMETER,MAXIMUM_DIAMETER,GAMMA,KILL_RADIUS, &
               TMP_INITIAL,SIGMA,VERTICAL_VELOCITY,HORIZONTAL_VELOCITY,DRAG_COEFFICIENT(3), &
               SURFACE_TENSION,BREAKUP_RATIO,BREAKUP_GAMMA,BREAKUP_SIGMA,DENSE_VOLUME_FRACTION, PERMEABILITY(3),&
               REAL_REFRACTIVE_INDEX,COMPLEX_REFRACTIVE_INDEX,TOL_INT,DENSITY=-1._EB,FTPR,FREE_AREA_FRACTION,&
               POROUS_VOLUME_FRACTION
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: R_CNF,CNF,CVF,BREAKUP_R_CNF,BREAKUP_CNF,BREAKUP_CVF,W_CNF,R50,LAMBDA,SOLID_ANGLE
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: WQABS,WQSCA
   INTEGER :: SAMPLING,N_QUANTITIES,QUANTITIES_INDEX(10),QUANTITIES_Y_INDEX(10)=-1,QUANTITIES_Z_INDEX(10)=-1,ARRAY_INDEX=0,&
              RGB(3),RADIATIVE_PROPERTY_INDEX=0,SURF_INDEX=0,DRAG_LAW=1,DEVC_INDEX=0,CTRL_INDEX=0,PROP_INDEX=-1,&
              ORIENTATION_INDEX=0,N_ORIENTATION,Z_INDEX=-1,N_STRATA=7, &
              Y_INDEX=-1,CNF_RAMP_INDEX=-1,BREAKUP_CNF_RAMP_INDEX=-1,N_STORAGE_REALS,N_STORAGE_INTEGERS,N_STORAGE_LOGICALS
   INTEGER,  ALLOCATABLE, DIMENSION(:) :: IL_CNF,IU_CNF
   LOGICAL :: STATIC=.FALSE.,MASSLESS_TRACER=.FALSE.,MASSLESS_TARGET=.FALSE.,LIQUID_DROPLET=.FALSE.,SOLID_PARTICLE=.FALSE., &
              MONODISPERSE=.FALSE.,TURBULENT_DISPERSION=.FALSE.,BREAKUP=.FALSE.,CHECK_DISTRIBUTION=.FALSE.,FUEL=.FALSE., &
              PERIODIC_X=.FALSE.,PERIODIC_Y=.FALSE.,PERIODIC_Z=.FALSE.
END TYPE LAGRANGIAN_PARTICLE_CLASS_TYPE

TYPE (LAGRANGIAN_PARTICLE_CLASS_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: LAGRANGIAN_PARTICLE_CLASS

! Note: If you change the number of scalar variables in ONE_D_M_AND_E_XFER_TYPE, adjust the numbers below

INTEGER, PARAMETER :: N_ONE_D_SCALAR_REALS=13,N_ONE_D_SCALAR_INTEGERS=9,N_ONE_D_SCALAR_LOGICALS=2

TYPE ONE_D_M_AND_E_XFER_TYPE
   REAL(EB), POINTER, DIMENSION(:) :: TMP,LAYER_THICKNESS,X,MASSFLUX_ACTUAL,MASSFLUX
   REAL(EB), POINTER, DIMENSION(:,:) :: RHO,ILW
   INTEGER, POINTER, DIMENSION(:) :: N_LAYER_CELLS
   INTEGER, POINTER :: ARRAY_INDEX,STORAGE_INDEX,II,JJ,KK,IIG,JJG,KKG,IOR
   REAL(EB), POINTER :: AREA,RAREA,HEAT_TRANS_COEF,QCONF,QRADIN,QRADOUT,EMISSIVITY,AREA_ADJUST,T_IGN,TMP_F,TMP_B,UW,UWS
   LOGICAL, POINTER :: BURNAWAY,CHANGE_THICKNESS
END TYPE ONE_D_M_AND_E_XFER_TYPE

! Note: If you change the number of scalar variables in LAGRANGIAN_PARTICLE_TYPE, adjust the numbers below

INTEGER, PARAMETER :: N_PARTICLE_SCALAR_REALS=16,N_PARTICLE_SCALAR_INTEGERS=6,N_PARTICLE_SCALAR_LOGICALS=2

TYPE LAGRANGIAN_PARTICLE_TYPE
   TYPE (ONE_D_M_AND_E_XFER_TYPE) :: ONE_D
   LOGICAL, POINTER :: SHOW,SPLAT
   REAL(EB), POINTER :: X,Y,Z,U,V,W,PWT,ACCEL_X,ACCEL_Y,ACCEL_Z,RE,MASS,T_INSERT,DX,DY,DZ
   INTEGER, POINTER :: TAG,ARRAY_INDEX,STORAGE_INDEX,CLASS_INDEX,ORIENTATION_INDEX,WALL_INDEX,FACE_INDEX
END TYPE LAGRANGIAN_PARTICLE_TYPE


TYPE STORAGE_TYPE
   INTEGER :: N_STORAGE_SLOTS=0,NEXT_AVAILABLE_SLOT=1
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: REALS
   INTEGER, ALLOCATABLE, DIMENSION(:,:) :: INTEGERS
   LOGICAL, ALLOCATABLE, DIMENSION(:,:) :: LOGICALS
END TYPE STORAGE_TYPE

! Note: If you change the number of scalar variables in WALL_TYPE, adjust the numbers below

INTEGER, PARAMETER :: N_WALL_SCALAR_REALS=19,N_WALL_SCALAR_INTEGERS=11,N_WALL_SCALAR_LOGICALS=0

TYPE WALL_TYPE
   TYPE (ONE_D_M_AND_E_XFER_TYPE) :: ONE_D
   REAL(EB), POINTER, DIMENSION(:) :: A_LP_MPUA,LP_CPUA,LP_MPUA,AWM_AEROSOL,RHODW,ZZ_F,VEG_FUELMASS_L,VEG_MOISTMASS_L,VEG_TMP_L
   REAL(EB), POINTER :: AW,DUWDT,EW,KW,RAW,RDN,RHO_F,U_TAU,UVW_GHOST,UW0,XW,Y_PLUS,YW,ZW,VEG_HEIGHT,VEL_ERR_NEW,V_DEP,Q_LEAK, &
                        TMP_F_GAS
   INTEGER, POINTER :: WALL_INDEX,SURF_INDEX,BACK_INDEX,BACK_MESH,BOUNDARY_TYPE,SURF_INDEX_ORIG,OBST_INDEX, &
                       PRESSURE_BC_INDEX,PRESSURE_ZONE,VENT_INDEX,NODE_INDEX
END TYPE WALL_TYPE

TYPE EXTERNAL_WALL_TYPE
   INTEGER :: NOM,NIC_MIN,NIC_MAX,IIO_MIN,IIO_MAX,JJO_MIN,JJO_MAX,KKO_MIN,KKO_MAX
END TYPE EXTERNAL_WALL_TYPE

TYPE BACK_WALL_TYPE
   REAL(EB) :: QRADIN,TMP_GAS
END TYPE BACK_WALL_TYPE

TYPE SPECIES_TYPE
   REAL(EB) :: MW=0._EB,YY0=0._EB,RCON,MAXMASS,MASS_EXTINCTION_COEFFICIENT=0._EB,&
               SPECIFIC_HEAT=-1._EB,REFERENCE_ENTHALPY=-1._EB,&
               REFERENCE_TEMPERATURE,MU_USER=-1._EB,K_USER=-1._EB,D_USER=-1._EB,EPSK=-1._EB,SIG=-1._EB,PR_USER=-1._EB,&
               FLD_LETHAL_DOSE=0._EB,FIC_CONCENTRATION=0._EB,PR_GAS,&
               SPECIFIC_HEAT_LIQUID=-1,DENSITY_LIQUID,VAPORIZATION_TEMPERATURE,HEAT_OF_VAPORIZATION=-1._EB,MELTING_TEMPERATURE,&
               H_F,H_V_REFERENCE_TEMPERATURE=-1._EB,H_V_CORRECTOR=0._EB ,TMP_V=-1._EB,TMP_MELT=-1._EB,ATOMS(118)=0._EB,&
               MEAN_DIAMETER=1.E-6_EB,CONDUCTIVITY_SOLID,DENSITY_SOLID
   LOGICAL ::  ISFUEL=.FALSE.,LISTED=.FALSE.,AGGLOMERATING=.FALSE.,EXPLICIT_H_F=.FALSE.
   CHARACTER(LABEL_LENGTH) :: ID,RAMP_CP,RAMP_CP_L,RAMP_K,RAMP_MU,RAMP_D,RADCAL_ID,RAMP_G_F,PROP_ID
   CHARACTER(100) :: FORMULA
   INTEGER :: MODE=2,RAMP_CP_INDEX=-1,RAMP_CP_L_INDEX=-1,RAMP_K_INDEX=-1,RAMP_MU_INDEX=-1,RAMP_D_INDEX=-1,RADCAL_INDEX=-1,&
              RAMP_G_F_INDEX=-1,AWM_INDEX=-1
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: H_V,C_P_L,C_P_L_BAR,H_L

END TYPE SPECIES_TYPE

TYPE (SPECIES_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: SPECIES

TYPE SPECIES_MIXTURE_TYPE
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: MASS_FRACTION,VOLUME_FRACTION
   REAL(EB) :: MW , RCON, ZZ0=0._EB, MASS_EXTINCTION_COEFFICIENT=0._EB,ADJUST_NU=1._EB,ATOMS(118)=0._EB,MEAN_DIAMETER,&
               SPECIFIC_HEAT=-1._EB,REFERENCE_ENTHALPY=-2.E20_EB,&
               REFERENCE_TEMPERATURE,MU_USER=-1._EB,K_USER=-1._EB,D_USER=-1._EB,PR_USER=-1._EB,EPSK=-1._EB,SIG=-1._EB,&
               FLD_LETHAL_DOSE=0._EB,FIC_CONCENTRATION=0._EB,&
               DENSITY_SOLID,CONDUCTIVITY_SOLID,H_F=-1.E30_EB
   CHARACTER(LABEL_LENGTH), ALLOCATABLE, DIMENSION(:) :: SPEC_ID
   CHARACTER(LABEL_LENGTH) :: ID='null',RAMP_CP,RAMP_CP_L,RAMP_K,RAMP_MU,RAMP_D,RAMP_G_F
   CHARACTER(100) :: FORMULA='null'
   INTEGER :: AWM_INDEX = -1,RAMP_CP_INDEX=-1,SINGLE_SPEC_INDEX=-1,RAMP_K_INDEX=-1,RAMP_MU_INDEX=-1,RAMP_D_INDEX=-1,&
              RAMP_G_F_INDEX=-1
   LOGICAL :: DEPOSITING=.FALSE.,VALID_ATOMS=.TRUE.,EVAPORATING=.FALSE.
END TYPE SPECIES_MIXTURE_TYPE

TYPE (SPECIES_MIXTURE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: SPECIES_MIXTURE

TYPE REACTION_TYPE
   CHARACTER(LABEL_LENGTH) :: FUEL,OXIDIZER,PRODUCTS,ID,RAMP_FS,TABLE_FS,RAMP_CHI_R
   CHARACTER(LABEL_LENGTH), ALLOCATABLE, DIMENSION(:) :: SPEC_ID_NU,SPEC_ID_NU_READ,SPEC_ID_N_S,SPEC_ID_N_S_READ
   REAL(EB) :: C,H,N,O,EPUMO2,HEAT_OF_COMBUSTION,HOC_COMPLETE,A,A_PRIME,A_IN,E,E_IN,K,&
               Y_O2_INFTY,Y_N2_INFTY=0._EB,MW_FUEL,MW_SOOT,&
               CO_YIELD,SOOT_YIELD,H2_YIELD, SOOT_H_FRACTION,RHO_EXPONENT,CRIT_FLAME_TMP,&
               NU_O2=0._EB,NU_N2=0._EB,NU_H2O=0._EB,NU_CO2=0._EB,NU_CO=0._EB,NU_SOOT=0._EB,S=0._EB
   REAL(EB) :: AUTO_IGNITION_TEMPERATURE=0._EB,THRESHOLD_TEMP=0._EB,N_T=0._EB,&
               FLAME_SPEED=-1._EB,FLAME_SPEED_EXPONENT=0._EB,FLAME_SPEED_TEMPERATURE=-1._EB,&
               TURBULENT_FLAME_SPEED_ALPHA=1._EB,TURBULENT_FLAME_SPEED_EXPONENT=2._EB,CHI_R
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: NU,NU_READ,NU_SPECIES,N_S,N_S_READ,NU_MW_O_MW_F
   INTEGER :: FUEL_SMIX_INDEX=-1,AIR_SMIX_INDEX=-1,MODE,N_SMIX,N_SPEC,RAMP_FS_INDEX=0,TABLE_FS_INDEX=0,ALT_INDEX=-1,&
              RAMP_CHI_R_INDEX=0
   LOGICAL :: IDEAL,CHECK_ATOM_BALANCE,FAST_CHEMISTRY=.FALSE.,SERIES_REACTION=.FALSE.,REVERSE=.FALSE.,THIRD_BODY=.FALSE.
   CHARACTER(100) :: FYI='null'
   CHARACTER(255) :: EQUATION
   CHARACTER(100) :: FWD_ID,ALT_REAC_ID
END TYPE REACTION_TYPE

TYPE (REACTION_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: REACTION

TYPE MATERIAL_TYPE
   REAL(EB) :: K_S,C_S,RHO_S,EMISSIVITY,DIFFUSIVITY,KAPPA_S,MOISTURE_FRACTION,TMP_BOIL,POROSITY
   INTEGER :: PYROLYSIS_MODEL
   CHARACTER(LABEL_LENGTH) :: ID
   CHARACTER(LABEL_LENGTH) :: RAMP_K_S,RAMP_C_S
   INTEGER :: N_REACTIONS,PROP_INDEX=-1
   INTEGER, DIMENSION(MAX_REACTIONS) :: N_RESIDUE
   INTEGER, DIMENSION(MAX_MATERIALS,MAX_REACTIONS) :: RESIDUE_MATL_INDEX
   INTEGER, DIMENSION(3) :: RGB
   REAL(EB), DIMENSION(MAX_REACTIONS) :: TMP_REF,TMP_IGN,TMP_THR,RATE_REF,THR_SIGN
   REAL(EB), DIMENSION(MAX_MATERIALS,MAX_REACTIONS) :: NU_RESIDUE
   REAL(EB), DIMENSION(MAX_REACTIONS) :: A,E,H_R,N_S,N_T,N_O2,GAS_DIFFUSION_DEPTH
   REAL(EB), DIMENSION(MAX_REACTIONS) :: HEATING_RATE,PYROLYSIS_RANGE,HEAT_OF_COMBUSTION,TOL_INT
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: NU_GAS,ADJUST_BURN_RATE
   REAL(EB), DIMENSION(MAX_SPECIES,MAX_REACTIONS) :: NU_SPEC
   LOGICAL, DIMENSION(MAX_REACTIONS) :: PCR = .FALSE.
   LOGICAL :: ALLOW_SHRINKING, ALLOW_SWELLING
   CHARACTER(LABEL_LENGTH), DIMENSION(MAX_MATERIALS,MAX_REACTIONS) :: RESIDUE_MATL_NAME
   CHARACTER(LABEL_LENGTH), DIMENSION(MAX_SPECIES,MAX_REACTIONS) :: SPEC_ID
   CHARACTER(100) :: FYI='null'
END TYPE MATERIAL_TYPE

TYPE (MATERIAL_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: MATERIAL

TYPE SURFACE_TYPE
   REAL(EB) :: TMP_FRONT=-1._EB,TMP_BACK=-1._EB,VEL,VEL_GRAD,PLE,Z0,CONVECTIVE_HEAT_FLUX,NET_HEAT_FLUX, &
               VOLUME_FLOW,HRRPUA,MLRPUA,T_IGN,SURFACE_DENSITY,CELL_SIZE_FACTOR, &
               E_COEFFICIENT,TEXTURE_WIDTH,TEXTURE_HEIGHT,THICKNESS,EXTERNAL_FLUX, &
               DXF,DXB,MASS_FLUX_TOTAL,PARTICLE_MASS_FLUX,EMISSIVITY,MAX_PRESSURE, &
               TMP_IGN,H_V,LAYER_DIVIDE,ROUGHNESS,LENGTH=-1._EB,WIDTH=-1._EB, &
               DT_INSERT,H_FIXED=-1._EB,H_FIXED_B=-1._EB,HM_FIXED=-1._EB,EMISSIVITY_BACK,CONV_LENGTH,XYZ(3),FIRE_SPREAD_RATE, &
               MINIMUM_LAYER_THICKNESS,INNER_RADIUS=0._EB,MASS_FLUX_VAR=-1._EB,VEL_BULK,ZETA_FRONT=-1._EB, &
               AUTO_IGNITION_TEMPERATURE=1.E20_EB
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: DX,RDX,RDXN,X_S,DX_WGT,MF_FRAC,PARTICLE_INSERT_CLOCK
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: RHO_0
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: MASS_FRACTION,MASS_FLUX,TAU,ADJUST_BURN_RATE
   INTEGER,  ALLOCATABLE, DIMENSION(:) :: RAMP_INDEX
   INTEGER, DIMENSION(3) :: RGB
   REAL(EB) :: TRANSPARENCY
   REAL(EB), DIMENSION(2) :: VEL_T
   INTEGER, DIMENSION(2) :: LEAK_PATH,DUCT_PATH
   INTEGER :: THERMAL_BC_INDEX,NPPC,SPECIES_BC_INDEX,VELOCITY_BC_INDEX,SURF_TYPE,N_CELLS_INI,N_CELLS_MAX, &
              PART_INDEX,PROP_INDEX=-1,RAMP_T_I_INDEX=-1
   INTEGER :: PYROLYSIS_MODEL,NRA,NSB
   INTEGER :: N_LAYERS,N_MATL
   INTEGER :: N_ONE_D_STORAGE_REALS,N_ONE_D_STORAGE_INTEGERS,N_ONE_D_STORAGE_LOGICALS
   INTEGER :: N_WALL_STORAGE_REALS,N_WALL_STORAGE_INTEGERS,N_WALL_STORAGE_LOGICALS
   INTEGER, DIMENSION(10) :: ONE_D_REALS_ARRAY_SIZE=0,ONE_D_INTEGERS_ARRAY_SIZE=0,ONE_D_LOGICALS_ARRAY_SIZE=0
   INTEGER, DIMENSION(10) :: WALL_REALS_ARRAY_SIZE=0,WALL_LOGICALS_ARRAY_SIZE=0
   INTEGER, ALLOCATABLE, DIMENSION(:) :: N_LAYER_CELLS,LAYER_INDEX,MATL_INDEX
   INTEGER, DIMENSION(MAX_LAYERS,MAX_MATERIALS) :: LAYER_MATL_INDEX
   INTEGER, DIMENSION(MAX_LAYERS) :: N_LAYER_MATL,N_LAYER_CELLS_MAX
   INTEGER, ALLOCATABLE, DIMENSION(:,:,:) :: RESIDUE_INDEX
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: MIN_DIFFUSIVITY
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: LAYER_THICKNESS,INTERNAL_HEAT_SOURCE
   REAL(EB), DIMENSION(MAX_LAYERS) :: LAYER_DENSITY, TMP_INNER, STRETCH_FACTOR
   CHARACTER(LABEL_LENGTH), ALLOCATABLE, DIMENSION(:) :: MATL_NAME
   CHARACTER(LABEL_LENGTH), DIMENSION(MAX_LAYERS,MAX_MATERIALS) :: LAYER_MATL_NAME
   REAL(EB), DIMENSION(MAX_LAYERS,MAX_MATERIALS) :: LAYER_MATL_FRAC
   LOGICAL :: BURN_AWAY,ADIABATIC,THERMALLY_THICK,INTERNAL_RADIATION,USER_DEFINED=.TRUE., &
              FREE_SLIP=.FALSE.,NO_SLIP=.FALSE.,SPECIFIED_NORMAL_VELOCITY=.FALSE.,SPECIFIED_TANGENTIAL_VELOCITY=.FALSE., &
              SPECIFIED_NORMAL_GRADIENT=.FALSE.,CONVERT_VOLUME_TO_MASS=.FALSE.,SPECIFIED_HEAT_SOURCE=.FALSE.
   INTEGER :: GEOMETRY,BACKING,PROFILE,HEAT_TRANSFER_MODEL=0
   CHARACTER(LABEL_LENGTH) :: PART_ID,RAMP_Q,RAMP_V,RAMP_T,RAMP_EF,RAMP_PART,RAMP_V_X,RAMP_V_Y,RAMP_V_Z,RAMP_T_I
   CHARACTER(LABEL_LENGTH), ALLOCATABLE, DIMENSION(:) :: RAMP_MF
   CHARACTER(60) :: ID,TEXTURE_MAP
   CHARACTER(100) :: FYI='null'

   ! Boundary vegetation
   LOGICAL  :: VEGETATION=.FALSE.,VEG_NO_BURN=.FALSE.,VEG_GROUND_ZERO_RAD=.TRUE., &
               VEG_LINEAR_DEGRAD,VEG_ARRHENIUS_DEGRAD
   INTEGER  :: NVEG_L
   REAL(EB) :: VEG_CHARFRAC,VEG_DRAG_INI,VEG_ELEMENT_DENSITY,VEG_HEIGHT,VEG_INITIAL_TEMP,VEG_LOAD, &
               VEG_MOISTURE,VEG_SVRATIO,VEG_PACKING,VEG_KAPPA,FIRELINE_MLR_MAX,VEG_GROUND_TEMP
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: VEG_FUEL_FLUX_L,VEG_MOIST_FLUX_L,VEG_DIVQNET_L
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: VEG_INCM_RADFCT_L,VEG_FINCM_RADFCT_L,VEG_FINCP_RADFCT_L
   !add index for mult veg
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: VEG_SEMISSM_RADFCT_L,VEG_SEMISSP_RADFCT_L !add index for mult veg

   ! Level Set Firespread
   LOGICAL :: VEG_LSET_SPREAD,VEG_LSET_ELLIPSE,VEG_LSET_TAN2
   REAL(EB) :: VEG_LSET_IGNITE_T,VEG_LSET_ROS_HEAD,VEG_LSET_ELLIPSE_HEAD,VEG_LSET_QCON,VEG_LSET_ROS_FLANK,VEG_LSET_ROS_BACK, &
               VEG_LSET_WIND_EXP

   !Veg SAV and height (fuel depth) for Farsite emulation
   REAL(EB) :: VEG_LSET_SIGMA,VEG_LSET_HT,VEG_LSET_BETA

   !HTC Custom
   REAL(EB) :: C_FORCED_CONSTANT=0._EB,C_FORCED_PR_EXP=0._EB,C_FORCED_RE=0._EB,C_FORCED_RE_EXP=0._EB,C_HORIZONTAL,C_VERTICAL

END TYPE SURFACE_TYPE

TYPE (SURFACE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: SURFACE

TYPE OMESH_TYPE
   REAL(EB), ALLOCATABLE, DIMENSION(:,:,:) :: MU,RHO,RHOS,U,V,W,US,VS,WS,H,HS,FVX,FVY,FVZ,D,DS,KRES,IL_S,IL_R
   REAL(EB), ALLOCATABLE, DIMENSION(:,:,:,:) :: ZZ,ZZS
   INTEGER, ALLOCATABLE, DIMENSION(:) :: BOUNDARY_TYPE,IIO_R,JJO_R,KKO_R,IOR_R,IIO_S,JJO_S,KKO_S,IOR_S
   INTEGER, ALLOCATABLE, DIMENSION(:) :: N_PART_ORPHANS,N_PART_ADOPT,BACK_WALL_CELL_INDEX,EXT_BACK_WALL_CELL_INDEX
   INTEGER :: I_MIN_R=-10,I_MAX_R=-10,J_MIN_R=-10,J_MAX_R=-10,K_MIN_R=-10,K_MAX_R=-10,NIC_R=0,N_EXT_BACK_WALL_CELLS=0, &
              I_MIN_S=-10,I_MAX_S=-10,J_MIN_S=-10,J_MAX_S=-10,K_MIN_S=-10,K_MAX_S=-10,NIC_S=0,N_BACK_WALL_CELLS=0
   INTEGER, DIMENSION(7) :: INTEGER_SEND_BUFFER,INTEGER_RECV_BUFFER
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: &
         REAL_SEND_PKG1,REAL_SEND_PKG2,REAL_SEND_PKG3,REAL_SEND_PKG4,REAL_SEND_PKG5,REAL_SEND_PKG6,REAL_SEND_PKG7,&
         REAL_RECV_PKG1,REAL_RECV_PKG2,REAL_RECV_PKG3,REAL_RECV_PKG4,REAL_RECV_PKG5,REAL_RECV_PKG6,REAL_RECV_PKG7
   TYPE (STORAGE_TYPE), ALLOCATABLE, DIMENSION(:) :: ORPHAN_PARTICLE_STORAGE,ADOPT_PARTICLE_STORAGE
   TYPE (BACK_WALL_TYPE), ALLOCATABLE, DIMENSION(:) :: BACK_WALL
END TYPE OMESH_TYPE

TYPE OBSTRUCTION_TYPE
   CHARACTER(LABEL_LENGTH) :: DEVC_ID='null',CTRL_ID='null',PROP_ID='null'
   INTEGER, DIMENSION(-3:3) :: SURF_INDEX=0
   LOGICAL, DIMENSION(-3:3) :: SHOW_BNDF=.TRUE.
   INTEGER, DIMENSION(3) :: RGB=(/0,0,0/)
   INTEGER, DIMENSION(3) :: DIMENSIONS=0
   REAL(EB) :: TRANSPARENCY=1._EB,BULK_DENSITY=-1._EB,VOLUME_ADJUST=1._EB
   REAL(EB), DIMENSION(3) :: TEXTURE=0._EB
   REAL(EB) :: X1=0._EB,X2=1._EB,Y1=0._EB,Y2=1._EB,Z1=0._EB,Z2=1._EB,MASS=1.E6_EB
   REAL(EB), DIMENSION(3) :: FDS_AREA=-1._EB,INPUT_AREA=-1._EB,UNDIVIDED_INPUT_AREA=-1._EB
   INTEGER :: I1=-1,I2=-1,J1=-1,J2=-1,K1=-1,K2=-1,COLOR_INDICATOR=-1,TYPE_INDICATOR=-1,ORDINAL=0
   INTEGER :: DEVC_INDEX=-1,CTRL_INDEX=-1,PROP_INDEX=-1,DEVC_INDEX_O=-1,CTRL_INDEX_O=-1
   LOGICAL :: HIDDEN=.FALSE.,PERMIT_HOLE=.TRUE.,ALLOW_VENT=.TRUE.,CONSUMABLE=.FALSE.,REMOVABLE=.FALSE., &
              HOLE_FILLER=.FALSE.,NOTERRAIN=.FALSE.,OVERLAY=.TRUE.
END TYPE OBSTRUCTION_TYPE

TYPE GEOMETRY_TYPE
   CHARACTER(LABEL_LENGTH) :: ID='geom', SURF_ID='null', MATL_ID='null'
   LOGICAL :: COMPONENT_ONLY, IS_DYNAMIC=.TRUE.
   INTEGER :: N_VERTS_BASE, N_FACES_BASE, N_VOLUS_BASE
   INTEGER :: N_VERTS, N_EDGES, N_FACES, N_VOLUS, NSUB_GEOMS
   INTEGER :: GEOM_TYPE
   LOGICAL :: HAVE_SURF, HAVE_MATL
   CHARACTER(60) :: BNDC_FILENAME='null', GEOC_FILENAME='null' ! for compatibility with existing FDS code
   REAL(EB) :: OMEGA=0._EB                                     ! for compatibility with existing FDS code
   INTEGER, ALLOCATABLE, DIMENSION(:) :: FACES, VOLUS, SUB_GEOMS, SURFS, MATLS
   INTEGER, ALLOCATABLE, DIMENSION(:,:) :: EDGES, FACE_EDGES, EDGE_FACES
   REAL(EB),ALLOCATABLE, DIMENSION(:,:) :: FACES_NORMAL
   REAL(EB),ALLOCATABLE, DIMENSION(:) :: FACES_AREA
   REAL(EB) :: GEOM_VOLUME, GEOM_AREA
   REAL(EB) :: XYZ0(3)
   REAL(EB) :: AZIM_BASE, ELEV_BASE, SCALE_BASE(3), XYZ_BASE(3)
   REAL(EB) :: AZIM,      ELEV,      SCALE(3),      XYZ(3)
   REAL(EB) :: AZIM_DOT, ELEV_DOT, SCALE_DOT(3), XYZ_DOT(3)
   REAL(EB) :: GAXIS(3), GROTATE, GROTATE_DOT, GROTATE_BASE
   REAL(EB) :: XB(6)
   REAL(EB) :: SPHERE_ORIGIN(3), SPHERE_RADIUS
   INTEGER :: IJK(3), N_LEVELS
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: VERTS_BASE, VERTS, TFACES, DAZIM, DELEV, ZVALS
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: DSCALE, DXYZ0, DXYZ

   CHARACTER(60) :: TEXTURE_MAPPING
   REAL(EB) :: TEXTURE_ORIGIN(3), TEXTURE_SCALE(2)
   LOGICAL :: AUTO_TEXTURE
END TYPE GEOMETRY_TYPE

INTEGER :: N_GEOMETRY=0, GEOMETRY_CHANGE_STATE=0
TYPE(GEOMETRY_TYPE), ALLOCATABLE, TARGET, DIMENSION(:) :: GEOMETRY
LOGICAL :: IS_GEOMETRY_DYNAMIC

TYPE VERTEX_TYPE
   REAL(EB) :: X,Y,Z
   REAL(EB) :: XYZ(3) ! this form may be more efficient
END TYPE VERTEX_TYPE

TYPE(VERTEX_TYPE), TARGET, ALLOCATABLE, DIMENSION(:) :: VERTEX

! --- CC_IBM types:
! Edge crossings data structure:
INTEGER, PARAMETER :: IBM_MAXCROSS_EDGE = 10 ! Size definition parameter. Max number of crossings per Cartesian Edge.
TYPE IBM_EDGECROSS_TYPE
   INTEGER :: NCROSS   ! Number of BODINT_PLANE segments - Cartesian edge crossings.
   REAL(EB), DIMENSION(1:IBM_MAXCROSS_EDGE)   ::  SVAR ! Locations along x2 axis of NCROSS intersections.
   INTEGER,  DIMENSION(1:IBM_MAXCROSS_EDGE)   :: ISVAR ! Type of intersection (i.e. SG, GS or GG).
   INTEGER,  DIMENSION(MAX_DIM+1)             ::   IJK ! [ i j k X2AXIS]
END TYPE IBM_EDGECROSS_TYPE

! Cartesian Edge Cut-Edges data structure:
INTEGER, PARAMETER :: IBM_MAXVERTS_EDGE  = 10 ! Size definition parameter. Max number of vertices per Cartesian Edge.
INTEGER, PARAMETER :: IBM_MAXCEELEM_EDGE = 10 ! Size definition parameter. Max number of cut edges per Cartesian Edge.
TYPE IBM_CUTEDGE_TYPE
   INTEGER :: NVERT, NEDGE, STATUS            ! Local Vertices, cut-edges and status of this Cartesian edge.
   REAL(EB), DIMENSION(IAXIS:KAXIS,1:IBM_MAXVERTS_EDGE)           :: XYZVERT  ! Locations of vertices.
   INTEGER,  DIMENSION(NOD1:NOD2,1:IBM_MAXCEELEM_EDGE)            ::  CEELEM  ! Cut-Edge connectivities.
   INTEGER,  DIMENSION(MAX_DIM+2)                                 ::     IJK  ! [ i j k X2AXIS cetype]
   INTEGER,  DIMENSION(IBM_MAX_WSTRIANG_SEG+2,IBM_MAXCEELEM_EDGE) ::  INDSEG  ! [ntr tr1 tr2 ibod]
END TYPE IBM_CUTEDGE_TYPE

! Cartesian Faces Cut-Faces data structure:
INTEGER, PARAMETER :: IBM_MAXVERTS_FACE  = 24 ! Size definition parameter. Max number of vertices per Cartesian Face.
INTEGER, PARAMETER :: IBM_MAXCEELEM_FACE = IBM_MAXVERTS_FACE ! Size definition parameter. Max segments per face.
INTEGER, PARAMETER :: IBM_MAXCFELEM_FACE = 10 ! Size definition parameter. Max number of cut faces per Cartesian Face.
INTEGER, PARAMETER :: IBM_MAXVERT_CUTFACE= 16 ! Size definition parameter.
TYPE IBM_CUTFACE_TYPE
   INTEGER :: NVERT, NFACE, STATUS            ! Local Vertices, cut-faces and status of this Cartesian face.
   REAL(EB), DIMENSION(IAXIS:KAXIS,1:IBM_MAXVERTS_FACE)           :: XYZVERT  ! Locations of vertices.
   INTEGER,  DIMENSION(IBM_MAXVERT_CUTFACE,IBM_MAXCFELEM_FACE)    ::  CFELEM  ! Cut-faces connectivities.
   INTEGER,  DIMENSION(MAX_DIM+1)                                 ::     IJK  ! [ i j k X1AXIS]
   REAL(EB), DIMENSION(IBM_MAXCFELEM_FACE)                        ::    AREA  ! Cut-faces areas.
   REAL(EB), DIMENSION(IAXIS:KAXIS,1:IBM_MAXCFELEM_FACE)          ::  XYZCEN  ! Cut-faces centroid locations.
   !Integrals to be used in cut-cell volume and centroid computations.
   REAL(EB), DIMENSION(IBM_MAXCFELEM_FACE)                        ::  INXAREA, INXSQAREA, JNYSQAREA, KNZSQAREA
   INTEGER,  DIMENSION(1:2,1:IBM_MAXCFELEM_FACE)                  ::  BODTRI
END TYPE IBM_CUTFACE_TYPE

! Cartesian Cells Cut-Cells data structure:
INTEGER, PARAMETER :: IBM_MAXCCELEM_CELL  =  8 ! Size definition parameter. Max number of cut-cell per cart cell.
INTEGER, PARAMETER :: IBM_MAXCFELEM_CELL  = 32 ! Size definition parameter. Max number of cut-faces per cart cell.
INTEGER, PARAMETER :: IBM_MAXVERTS_CELL   = 96
INTEGER, PARAMETER :: IBM_MAXCEELEM_CELL  = IBM_MAXVERTS_CELL
INTEGER, PARAMETER :: IBM_MAXCFACE_CUTCELL= 16 ! Size definition parameter.
INTEGER, PARAMETER :: IBM_NPARAM_CCFACE   =  5 ! [face_type side iaxis cei icf]

TYPE IBM_CUTCELL_TYPE
   INTEGER :: NCELL
   INTEGER, DIMENSION(1:IBM_MAXCFACE_CUTCELL+2,IBM_MAXCCELEM_CELL) ::    CCELEM ! Cut-cells faces connectivities in FACE_LIST.
   INTEGER, DIMENSION(1:IBM_NPARAM_CCFACE,1:IBM_MAXCFELEM_CELL)    :: FACE_LIST ! List of faces, cut-faces.
   REAL(EB), DIMENSION(IBM_MAXCCELEM_CELL)                         ::    VOLUME ! Cut-cell volumes.
   REAL(EB), DIMENSION(IAXIS:KAXIS,1:IBM_MAXCCELEM_CELL)           ::    XYZCEN ! Cut-cell centroid locaitons.
END TYPE IBM_CUTCELL_TYPE

! -----------------------------------------
! http://www.sdsc.edu/~tkaiser/f90.html#Linked lists
TYPE LINKED_LIST_TYPE
   INTEGER :: INDEX                           ! data
   TYPE(LINKED_LIST_TYPE), POINTER :: NEXT    ! pointer to the next element
END TYPE LINKED_LIST_TYPE

TYPE CUTCELL_LINKED_LIST_TYPE
   INTEGER :: INDEX                                   ! data
   TYPE(CUTCELL_LINKED_LIST_TYPE), POINTER :: NEXT    ! pointer to the next element
   REAL(EB) :: AREA                                   ! cutcell area for index
END TYPE CUTCELL_LINKED_LIST_TYPE

TYPE CUTCELL_TYPE
   REAL(EB) :: VOL,RHO,TMP,DIV,A(6),S,N(3)
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: ZZ
   ! identify each face with area contribution to current cutcell
   ! note: this must include the faces and areas of Cartesian cells
   TYPE(CUTCELL_LINKED_LIST_TYPE), POINTER :: CUTCELL_FACE_LIST
END TYPE CUTCELL_TYPE

TYPE FACET_TYPE
   INTEGER :: VERTEX(3)=0,SURF_INDEX=0,BOUNDARY_TYPE
   CHARACTER(LABEL_LENGTH) :: SURF_ID='null'
   REAL(EB) :: NVEC(3)=0._EB,AW,EW,KW,DN,RDN,RHO_F,U_TAU,Y_PLUS,TMP_F,TMP_G,QCONF,HEAT_TRANS_COEF,QRADIN,QRADOUT
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: RHODW,ZZ_F
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: ILW
   TYPE(CUTCELL_LINKED_LIST_TYPE), POINTER :: CUTCELL_LIST
END TYPE FACET_TYPE

TYPE(FACET_TYPE), ALLOCATABLE, TARGET, DIMENSION(:) :: FACET

TYPE VOLUME_TYPE
   INTEGER :: VERTEX(4)=0
   CHARACTER(LABEL_LENGTH) :: MATL_ID='null'
END TYPE VOLUME_TYPE

TYPE(VOLUME_TYPE), ALLOCATABLE, TARGET, DIMENSION(:) :: VOLUME

TYPE CSVF_TYPE
    CHARACTER(256) :: CSVFILE,UVWFILE
END TYPE CSVF_TYPE

TYPE(CSVF_TYPE), ALLOCATABLE, DIMENSION(:) :: CSVFINFO

TYPE VENTS_TYPE
   INTEGER :: I1=-1,I2=-1,J1=-1,J2=-1,K1=-1,K2=-1,BOUNDARY_TYPE=0,IOR=0,SURF_INDEX=0,DEVC_INDEX=-1,CTRL_INDEX=-1, &
              COLOR_INDICATOR=99,TYPE_INDICATOR=0,ORDINAL=0,PRESSURE_RAMP_INDEX=0,TMP_EXTERIOR_RAMP_INDEX=0,NODE_INDEX=-1
   INTEGER, DIMENSION(3) :: RGB=-1
   REAL(EB) :: TRANSPARENCY = 1._EB
   REAL(EB), DIMENSION(3) :: TEXTURE=0._EB
   REAL(EB) :: X1=0._EB,X2=0._EB,Y1=0._EB,Y2=0._EB,Z1=0._EB,Z2=0._EB,FDS_AREA=0._EB, &
               X0=-9.E6_EB,Y0=-9.E6_EB,Z0=-9.E6_EB,FIRE_SPREAD_RATE=0.05_EB,UNDIVIDED_INPUT_AREA=0._EB,INPUT_AREA=0._EB,&
               TMP_EXTERIOR=-1000._EB,DYNAMIC_PRESSURE=0._EB,UVW(3)=-1.E12_EB,RADIUS=-1._EB
   LOGICAL :: ACTIVATED=.TRUE.,GHOST_CELLS_ONLY=.FALSE.
   CHARACTER(LABEL_LENGTH) :: DEVC_ID='null',CTRL_ID='null',ID='null'
   ! turbulent inflow (experimental)
   INTEGER :: N_EDDY=0
   REAL(EB) :: R_IJ(3,3)=0._EB,A_IJ(3,3),SIGMA_IJ(3,3),EDDY_BOX_VOLUME=0._EB, &
               X_EDDY_MIN=0._EB,X_EDDY_MAX=0._EB, &
               Y_EDDY_MIN=0._EB,Y_EDDY_MAX=0._EB, &
               Z_EDDY_MIN=0._EB,Z_EDDY_MAX=0._EB
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: U_EDDY,V_EDDY,W_EDDY
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: X_EDDY,Y_EDDY,Z_EDDY,CU_EDDY,CV_EDDY,CW_EDDY
END TYPE VENTS_TYPE

TYPE TABLES_TYPE
   INTEGER :: NUMBER_ROWS,NUMBER_COLUMNS
   REAL(EB) :: LX,LY,UX,UY
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: X,Y
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: TABLE_DATA,Z
END TYPE TABLES_TYPE

TYPE (TABLES_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: TABLES

TYPE RAMPS_TYPE
   REAL(EB) :: SPAN,RDT,T_MIN,T_MAX
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: INDEPENDENT_DATA,DEPENDENT_DATA,INTERPOLATED_DATA
   INTEGER :: NUMBER_DATA_POINTS,NUMBER_INTERPOLATION_POINTS,DEVC_INDEX=-1,CTRL_INDEX=-1
   CHARACTER(LABEL_LENGTH) :: DEVC_ID='null',CTRL_ID='null'
END TYPE RAMPS_TYPE

TYPE (RAMPS_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: RAMPS

TYPE HUMAN_TYPE
   CHARACTER(60) :: NODE_NAME='null'
   CHARACTER(LABEL_LENGTH) :: FFIELD_NAME='null'
   REAL(EB) :: X=0._EB,Y=0._EB,Z=0._EB,U=0._EB,V=0._EB,W=0._EB,F_X=0._EB,F_Y=0._EB,&
               X_old=0._EB,Y_old=0._EB,X_group=0._EB,Y_group=0._EB, U_CB=0.0_EB, V_CB=0.0_EB
   REAL(EB) :: UBAR=0._EB, VBAR=0._EB, UBAR_Center=0._EB, VBAR_Center=0._EB, T_LastRead_CB=0.0_EB
   REAL(EB) :: Speed=1.25_EB, Radius=0.255_EB, Mass=80.0_EB, Tpre=1._EB, Tau=1._EB, &
               Eta=0._EB, Ksi=0._EB, Tdet=0._EB, Speed_ave=0._EB, T_Speed_ave=0._EB, &
               X_CB=0.0_EB, Y_CB=0.0_EB, X2_CB=0.0_EB, Y2_CB=0.0_EB, UAVE_CB=0.0_EB, VAVE_CB=0.0_EB
   REAL(EB) :: r_torso=0.15_EB, r_shoulder=0.095_EB, d_shoulder=0.055_EB, angle=0._EB, &
               torque=0._EB, m_iner=4._EB
   REAL(EB) :: tau_iner=0.2_EB, angle_old=0._EB, omega=0._EB
   REAL(EB) :: A=2000._EB, B=0.08_EB, C_Young=120000._EB, Gamma=16000._EB, Kappa=40000._EB, &
               Lambda=0.5_EB, Commitment=0._EB
   REAL(EB) :: SumForces=0._EB, IntDose=0._EB, DoseCrit1=0._EB, DoseCrit2=0._EB, SumForces2=0._EB
   REAL(EB) :: TempMax1=0._EB, FluxMax1=0._EB, TempMax2=0._EB, FluxMax2=0._EB, Density=0._EB, DensityR=0._EB, DensityL=0._EB
   REAL(EB) :: P_detect_tot=0._EB, v0_fac=1._EB, D_Walls=0._EB
   REAL(EB) :: T_FallenDown=0._EB, F_FallDown=0._EB, Angle_FallenDown=0._EB, SizeFac_FallenDown=0._EB, T_CheckFallDown=0._EB
   INTEGER  :: IOR=-1, ILABEL=0, COLOR_INDEX=0, INODE=0, IMESH=-1, IPC=0, IEL=0, I_FFIELD=0, I_Target2=0, ID_CB=-1
   INTEGER  :: GROUP_ID=0, DETECT1=0, GROUP_SIZE=0, I_Target=0, I_DoorAlgo=0, I_Door_Mode=0, STRS_Direction = 1
   INTEGER  :: STR_SUB_INDX, SKIP_WALL_FORCE_IOR
   LOGICAL  :: SHOW=.TRUE., NewRnd=.TRUE., CROWBAR_READ_IN=.FALSE., CROWBAR_UPDATE_V0=.FALSE.
   LOGICAL  :: SeeDoorXB1=.FALSE., SeeDoorXB2=.FALSE., SeeDoorXYZ1=.FALSE., SeeDoorXYZ2=.FALSE.
END TYPE HUMAN_TYPE

TYPE HUMAN_GRID_TYPE
! (x,y,z) Centers of the grid cells in the main evacuation meshes
! SOOT_DENS: Smoke density at the center of the cell (mg/m3)
! FED_CO_CO2_O2: Purser's FED for co, co2, and o2
   REAL(EB) :: X,Y,Z,SOOT_DENS,FED_CO_CO2_O2,TMP_G,RADFLUX
   INTEGER :: N, N_old, IGRID, IHUMAN, ILABEL
! IMESH: (x,y,z) which fire mesh, if any
! II,JJ,KK: Fire mesh cell reference
   INTEGER  :: IMESH,II,JJ,KK
END TYPE HUMAN_GRID_TYPE

TYPE SLICE_TYPE
   INTEGER :: I1,I2,J1,J2,K1,K2,INDEX,INDEX2=0,Z_INDEX=-999,Y_INDEX=-999,PART_INDEX=0,VELO_INDEX=0,PROP_INDEX=0,REAC_INDEX=0,IOR=0
   REAL(FB), DIMENSION(2) :: MINMAX
   REAL(EB):: SLICE_AGL
   LOGICAL :: TERRAIN_SLICE=.FALSE.,CELL_CENTERED=.FALSE., FIRE_LINE=.FALSE.,LEVEL_SET_FIRE_LINE=.FALSE.,FACE_CENTERED=.FALSE.
   CHARACTER(60) :: SLICETYPE='STRUCTURED',SMOKEVIEW_LABEL
   CHARACTER(LABEL_LENGTH) :: SMOKEVIEW_BAR_LABEL,ID='null'
END TYPE SLICE_TYPE

TYPE PATCH_TYPE
   INTEGER :: I1,I2,J1,J2,K1,K2,IG1,IG2,JG1,JG2,KG1,KG2,IOR,OBST_INDEX
END TYPE PATCH_TYPE

TYPE BOUNDARY_FILE_TYPE
   INTEGER :: INDEX,PROP_INDEX,Z_INDEX=-999,Y_INDEX=-999,PART_INDEX=0,TIME_INTEGRAL_INDEX=0
   CHARACTER(60) :: SMOKEVIEW_LABEL
   CHARACTER(LABEL_LENGTH) :: SMOKEVIEW_BAR_LABEL,UNITS
   LOGICAL :: CELL_CENTERED=.FALSE.
END TYPE BOUNDARY_FILE_TYPE

TYPE (BOUNDARY_FILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: BOUNDARY_FILE

TYPE BOUNDARY_ELEMENT_FILE_TYPE
   INTEGER :: INDEX,PROP_INDEX,Z_INDEX=-999,Y_INDEX=-999,PART_INDEX=0
   CHARACTER(60) :: SMOKEVIEW_LABEL
   CHARACTER(LABEL_LENGTH) :: SMOKEVIEW_BAR_LABEL
   LOGICAL :: CELL_CENTERED=.TRUE.
END TYPE BOUNDARY_ELEMENT_FILE_TYPE

TYPE (BOUNDARY_ELEMENT_FILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: BOUNDARY_ELEMENT_FILE

TYPE ISOSURFACE_FILE_TYPE
   INTEGER :: INDEX=1,N_VALUES=1,Y_INDEX=-999,Z_INDEX=-999,VELO_INDEX=0
   REAL(FB) :: VALUE(10)
   CHARACTER(60) :: SMOKEVIEW_LABEL
   CHARACTER(LABEL_LENGTH) :: SMOKEVIEW_BAR_LABEL
END TYPE ISOSURFACE_FILE_TYPE

TYPE (ISOSURFACE_FILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: ISOSURFACE_FILE

TYPE PROFILE_TYPE
   REAL(EB) :: X,Y,Z
   INTEGER  :: IOR,IW,ORDINAL,MESH,FORMAT_INDEX=1
   CHARACTER(LABEL_LENGTH) :: ID,QUANTITY
END TYPE PROFILE_TYPE

TYPE (PROFILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: PROFILE

TYPE INITIALIZATION_TYPE
   REAL(EB) :: TEMPERATURE,DENSITY,X1,X2,Y1,Y2,Z1,Z2,MASS_PER_VOLUME,MASS_PER_TIME,DT_INSERT, &
               X0,Y0,Z0,U0,V0,W0,VOLUME,HRRPUV=0._EB,DX=0._EB,DY=0._EB,DZ=0._EB,HEIGHT,RADIUS,DIAMETER=-1._EB, &
               PARTICLE_WEIGHT_FACTOR,AIT=1.E20_EB
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: PARTICLE_INSERT_CLOCK,MASS_FRACTION
   INTEGER  :: PART_INDEX=0,N_PARTICLES,LU_PARTICLE,PROF_INDEX=0,DEVC_INDEX=0,CTRL_INDEX=0,TABL_INDEX=0, &
               N_PARTICLES_PER_CELL=0
   LOGICAL :: ADJUST_DENSITY=.FALSE.,ADJUST_TEMPERATURE=.FALSE.,SINGLE_INSERTION=.TRUE., &
              CELL_CENTERED=.FALSE.
   LOGICAL, ALLOCATABLE, DIMENSION(:) :: ALREADY_INSERTED
   CHARACTER(LABEL_LENGTH) :: SHAPE,DEVC_ID,CTRL_ID,ID
END TYPE INITIALIZATION_TYPE

TYPE (INITIALIZATION_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: INITIALIZATION

TYPE INIT_RESERVED_TYPE
   REAL(EB) :: XYZ(3),DX,DY,DZ
   INTEGER :: N_PARTICLES,DEVC_INDEX
   CHARACTER(LABEL_LENGTH) :: DEVC_ID
END TYPE INIT_RESERVED_TYPE

TYPE (INIT_RESERVED_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: INIT_RESERVED

TYPE P_ZONE_TYPE
   REAL(EB) :: X1,X2,Y1,Y2,Z1,Z2,DPSTAR=0._EB
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: LEAK_AREA
   INTEGER :: N_DUCTNODES,MESH_INDEX=0
   LOGICAL :: EVACUATION=.FALSE.,PERIODIC=.FALSE.
   INTEGER, ALLOCATABLE, DIMENSION(:) :: NODE_INDEX
   CHARACTER(LABEL_LENGTH) :: ID
END TYPE P_ZONE_TYPE

TYPE (P_ZONE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: P_ZONE

TYPE MULTIPLIER_TYPE
   REAL(EB) :: DXB(6),DX0,DY0,DZ0
   INTEGER  :: I_LOWER,I_UPPER,J_LOWER,J_UPPER,K_LOWER,K_UPPER,N_LOWER,N_UPPER,N_COPIES
   CHARACTER(LABEL_LENGTH) :: ID
   LOGICAL :: SEQUENTIAL=.FALSE.
END TYPE MULTIPLIER_TYPE

TYPE (MULTIPLIER_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: MULTIPLIER

TYPE FILTER_TYPE
   INTEGER :: RAMP_INDEX = -1
   CHARACTER(LABEL_LENGTH) :: ID,TABLE_ID
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: EFFICIENCY,MULTIPLIER
   REAL(EB) :: CLEAN_LOSS,LOADING_LOSS
END TYPE FILTER_TYPE

TYPE (FILTER_TYPE), DIMENSION(:), ALLOCATABLE,  TARGET :: FILTER

TYPE DUCTNODE_TYPE
   INTEGER :: FILTER_INDEX=-1, N_DUCTS,VENT_INDEX = -1, MESH_INDEX = -1,ZONE_INDEX=-1
   INTEGER, ALLOCATABLE, DIMENSION(:) :: DUCT_INDEX
   CHARACTER(LABEL_LENGTH) :: ID,TABLE_ID,VENT_ID='null'
   REAL(EB), ALLOCATABLE, DIMENSION(:,:) :: LOSS_ARRAY,FILTER_LOADING
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: ZZ,DIR,ZZ_V
   REAL(EB) :: LOSS, P,P_OLD,TMP,RHO,RSUM,CP,XYZ(3),FILTER_LOSS,TMP_V,RHO_V,RSUM_V,CP_V
   LOGICAL :: UPDATED, READ_IN, FIXED, AMBIENT = .FALSE.,LEAKAGE=.FALSE.,VENT=.FALSE.
   LOGICAL, ALLOCATABLE, DIMENSION(:) :: IN_MESH
END TYPE DUCTNODE_TYPE

TYPE (DUCTNODE_TYPE), DIMENSION(:), ALLOCATABLE,  TARGET :: DUCTNODE

TYPE NODE_BC_TYPE
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: ZZ_V
   REAL(EB) :: TMP_V,RHO_V,RSUM_V,CP_V, P
END TYPE NODE_BC_TYPE

TYPE DUCT_TYPE
   INTEGER :: NODE_INDEX(2)=-1,DEVC_INDEX=-1,CTRL_INDEX=-1,FAN_INDEX=-1,AIRCOIL_INDEX=-1,RAMP_INDEX=0
   REAL(EB) :: ROUGHNESS,LENGTH, DIAMETER, AREA_INITIAL, AREA, CP_D, RHO_D,TMP_D,LOSS(2)=0._EB,VEL(4)=0._EB,RSUM_D=0._EB,&
               DP_FAN=0._EB,TOTAL_LOSS = 0._EB,COIL_Q=0._EB,MASS_FLOW_INITIAL=1.E6_EB,&
               VOLUME_FLOW=1.E6_EB,VOLUME_FLOW_INITIAL=1.E6_EB,TAU=-1._EB
   REAL(EB), ALLOCATABLE, DIMENSION(:) :: ZZ
   LOGICAL :: ROUND = .TRUE.,SQUARE = .FALSE.,DAMPER = .FALSE.,DAMPER_OPEN = .TRUE.,FAN_OPERATING=.TRUE.,COIL_OPERATING=.TRUE.,&
              FIXED=.FALSE.,REVERSE=.FALSE.,UPDATED,LEAKAGE=.FALSE.,LEAK_ENTHALPY=.FALSE.
   CHARACTER(LABEL_LENGTH) :: ID,RAMP_ID
   REAL(EB) :: FAN_ON_TIME = 1.E10_EB,COIL_ON_TIME = 1.E10_EB
END TYPE DUCT_TYPE

TYPE (DUCT_TYPE), DIMENSION(:), ALLOCATABLE,  TARGET :: DUCT

TYPE FAN_TYPE
   INTEGER :: FAN_TYPE,RAMP_INDEX,SPIN_INDEX=0
   REAL(EB) :: VOL_FLOW,MAX_FLOW,MAX_PRES,OFF_LOSS=0._EB,TAU=0._EB
   CHARACTER(LABEL_LENGTH) :: ID,FAN_RAMP
END TYPE FAN_TYPE

TYPE(FAN_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: FAN

TYPE AIRCOIL_TYPE
   REAL(EB) :: COOLANT_TEMPERATURE=293.15_EB,COOLANT_SPECIFIC_HEAT=4186._EB, EFFICIENCY, COOLANT_MASS_FLOW=-9999._EB, &
               FIXED_Q=-1.E10_EB,TAU=0._EB
   INTEGER :: RAMP_INDEX=0
   CHARACTER(LABEL_LENGTH) :: ID,RAMP_ID
END TYPE AIRCOIL_TYPE

TYPE(AIRCOIL_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: AIRCOIL

TYPE NETWORK_TYPE
   INTEGER :: N_DUCTS,N_DUCTNODES,N_MATRIX
   INTEGER, ALLOCATABLE, DIMENSION(:) :: DUCT_INDEX,NODE_INDEX,MATRIX_INDEX
END TYPE NETWORK_TYPE

TYPE(NETWORK_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: NETWORK


END MODULE TYPES
