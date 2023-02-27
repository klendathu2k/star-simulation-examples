#! /usr/local/bin/tcsh -f
# first argument is a serial number
# for output file: evgen.<serialNumber>.nt 
if (! $?STAR) source ${GROUP_DIR}/.starver DEV
set iset = $1
if (! $iset) set iset = 999

if ($2 == "test" ) then
 set maxEvts = 100
 set myEnergy  = 200
 set myBeamAZ  = ( 197 79 )  #gold
 set myTargAZ  = ( 197 79 )  #gold
 set myImpact  = ( 0 20 )  
endif


#-------------------------------------------------------------------
#set maxEvts = 100
if (! ${?maxEvts} ) then
  echo "*** ERROR: hijing.csh: maxEvts not defined ***"
  exit 1
endif
echo "*** INFO: hijing.csh: maxEvts=$maxEvts ***"
#-------------------------------------------------------------------
#set myEnergy  = 9.2
if (! ${?myEnergy} ) then
  echo "*** ERROR: hijing.csh: myEnergy not defined ***"
  exit 2
endif
echo "*** INFO: hijing.csh: myEnergy=$myEnergy ***"
#-------------------------------------------------------------------

#set myBeamAZ  = ( 197 79 )  #gold
if (! ${?myBeamAZ} ) then
  echo "*** ERROR: hijing.csh: myBeamAZ not defined ***"
  exit 2
endif
echo "*** INFO: hijing.csh: myBeamAZ=$myBeamAZ ***"
#-------------------------------------------------------------------

#set myTargAZ  = ( 197 79 )  #gold
if (! ${?myTargAZ} ) then
  echo "*** ERROR: hijing.csh: myTargAZ not defined ***"
  exit 2
endif
echo "*** INFO: hijing.csh: myTargAZ=$myTargAZ ***"
#-------------------------------------------------------------------

#set myImpact  = ( 0 20 )  
if (! ${?myImpact} ) then
  echo "*** ERROR: hijing.csh: myImpact not defined ***"
  exit 2
endif
echo "*** INFO: hijing.csh: myImpact=$myImpact ***"
#-------------------------------------------------------------------
set inp = /tmp/$iset.$$.hijev.inp
if (-e $inp) rm $inp
cat <<EOF > $inp
'  ====================================================== '   
'  =====         Hijing Control file                ===== '   
'  ====================================================== ' 
' Events                          '  ${maxEvts}
' Frame/Energy                    '  'CMS'  ${myEnergy}              
' Projectile  type/A/Z            '  'A'  ${myBeamAZ}              
' Target      type/Z/Z            '  'A'  ${myTargAZ}         
' Impact parameter min/max (fm)   '  ${myImpact}                  
' Jet quenching (1=yes/0=no)      '  0                        
' Hard scattering/pt jet          '  0   2.0                   
' Max # jets per nucleon (D=10)   '  10                        
' Set ihpr2(11) and ihpr2(12)     '  1   1
' Set ihpr2(21) and ihpr2(18)     '  1   0
' set B production                '  1.5  
' istat=1 old istat>1 new         '  2                                    
EOF

$STAR_BIN/hijing_382 -run $iset -inp $inp
rm $inp
exit                                    
