#! /usr/local/bin/tcsh -f
if (! $?STAR) source ${GROUP_DIR}/.starver DEV

# Number of arguements
set nA = $#
if (! $nA) then
   echo "Usage:"
   echo "   runHigherMoments.csh SET NEV ENERGY"
   echo ""
   echo "   SET -- is a unique number for each job"
   echo "   NEV -- is the total number of events to generate [default 100]"
   echo "   ENE -- is the CMS energy [default 200.0]"
   exit
endif

# first argument is a serial number
# for output file: evgen.<serialNumber>.nt
set iset = $1
if (! $iset) set iset = 999

# second arguement is the maximum number of events
set nevents = $2
if (! $nevents) set nevents = 100

# third arguement is the energy
set energy  = $3
if ( $nA<3 ) then
   set energy = 19.6
endif
#if (! $energy) set energy = 200.0

set beamAZ  = ( 197 79 ) # gold
set targAZ  = ( 197 79 ) # gold

set inp = control.$iset.hijing
if (-e $inp) rm $inp
cat <<EOF > $inp
'  ====================================================== '
'  =====         Hijing Control file                ===== '
'  ====================================================== '
' Events                          '  ${nevents}
' Frame/Energy                    '  'CMS'  ${energy}
' Projectile  type/A/Z            '  'A'  ${beamAZ}
' Target      type/Z/Z            '  'A'  ${targAZ}
' Impact parameter min/max (fm)   '  0.   999.
' Jet quenching (1=yes/0=no)      '  0
' Hard scattering/pt jet          '  0   2.0
' Max # jets per nucleon (D=10)   '  10
' Set ihpr2(11) and ihpr2(12)     '  1   1
' Set ihpr2(21) and ihpr2(18)     '  1   0
' set B production                '  1.5
' istat=1 old istat>1 new         '  2
EOF
cat $inp
$STAR_BIN/hijing_382 -run $iset -inp $inp

cat <<EOF > runHijingEvents.kumac
MACRO runHijingEvents set=1 energy=19.6 nevents=100 base=rcf12011 tag=y2011a

*************************************************************
** Configuration
**
   NAME    =                       [base]_[set]_[nevents]evts

   LIBRARY =                                        $STAR_LIB
   BINARY  =                                        $STAR_BIN
   FIELD   =                                             -5.0

**  mean and sigma for Vx Vy Vz
**  0.31  -0.35  -1.4  and 0.91   0.77   33.68   respectively .

   XVERTEX =                                            0.31
   YVERTEX =                                           -0.35
   ZVERTEX =                                           -1.40

   XSIGMA  =                                            0.910
   YSIGMA  =                                            0.770
   ZSIGMA  =                                           36.680

   PTmin   =                                            0.000
   PTmax   =                                          100.000
   ETAmin  =                                           -4.500
   ETAmax  =                                           +2.500
   Zmin    =                                         -100.000
   Zmax    =                                         +100.000

**
*************************************************************


*************************************************************


*************************************************************
** Setup random number generator with a unique, reproducible
** random number seed
   RANLUX [set] 3



*************************************************************
** Setup Geometry
   DETP GEOM [TAG] field=[FIELD]
   GEXEC [LIBRARY]/geometry.so
   GEXEC [LIBRARY]/gstar.so
   GCLOS all



*************************************************************
** Setup interaction region
   GVERTEX [XVERTEX] [YVERTEX] [ZVERTEX]
   GSPREAD [XSIGMA]  [YSIGMA]  [ZSIGMA]



*************************************************************
** Setup data input
   GKINE -1 0 [PTmin] [PTmax] [ETAmin] [ETAmax] 0.000 6.283 [Zmin] [Zmax]
   USER/INPUT please evgen.[set].nt

*************************************************************
** Setup output file and generate events
   GFILE o [NAME].fzd
   DO i=0, [nevents]
     TRIG 1
   ENDDO

   EXIT

RETURN
EOF

# Run simulation
starsim -w 0 -b runHijingEvents set=${iset} energy=${energy} nevents=${nevents}

# Remove the macro
rm runHijingEvents.kumac

exit
