//Processing bfc.C
void runBfc_y2019a()
{

  // Run 19 19.6 Production Chain P21ic
  // DbV20210827 P2019a StiCA -beamline3D btof mtd mtdCalib ImpBToFt0Mode BEmcChkStat CorrY -OPr13 EbyET0 PicoVtxDefault PicoCovMtxWrite -evout -hitfilt

  TString chain2019;
  chain2019 += "fzin y2019a AgML BigBig usexgeom ";
  chain2019 += "TpcDB TpcRS TpxClu ";
  chain2019 += "MakeEvent McEvent EvOut -DstOut IdTruth -minimcmk CMuDst ";
  chain2019 += "StiCA NoSsdIt NoSvtIt ";
  chain2019 += "Idst BAna l0 Tree logger ";
  chain2019 += "genvtx beamline VFPPVnoCTB -beamline3D ";
  chain2019 += "bbcSim btofsim btof mtdsim mtd mtdCalib ImpBToFt0Mode BEmcChkStat CorrY -OPr13 EbyET0 emcY2 eefs ";
  chain2019 += "-StiPulls clearmem ";
  //   {"B2019a" ,"","","ry2019a,in,tpcX,UseXgeom,iTpcIT,CorrX,AgML,tpcDB,TpcHitMover,Idst,tags,Tree,picoWrite",
  chain2019 += "tpcX iTpcIt CorrX TpcHitMover ";

  gROOT->LoadMacro("bfc.C");
  bfc(5,chain2019,"pythia8.starsim.fzd");

}
