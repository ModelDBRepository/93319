// Cell model with new geometry
// Primary, secondary & tertiary dendrites
   
*lambda_warn
*relative
*cartesian
*asymmetric

*set_compt_param	EREST_ACT -0.078
*set_compt_param        ELEAK -0.078
   
*set_global                     RA			1 
*set_global			CM			0.01 
*set_global			RM			1

   
*start_cell /library/tert_dend 
   tert_dend none 30 0 0 2 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA   0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   tert_dend2 . 30 0 0 2 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   tert_dend3 . 30 0 0 2 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   tert_dend4 . 30 0 0 2 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   tert_dend5 . 30 0 0 2 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   tert_dend6 . 30 0 0 2 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   tert_dend7 . 30 0 0 2 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   tert_dend8 . 30 0 0 2 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   
*makeproto /library/tert_dend
   
*start_cell /library/sec_dend
   sec_dend none 37 0 0 3 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   sec_dend2 . 37 0 0 3 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   sec_dend3 . 37 0 0 3 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
   sec_dend4 . 37 0 0 3 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 fshNa 0 fshNa-is 0 AMPA_bath 0
    
*makeproto /library/sec_dend

*start_cell /library/prim_dend
   prim_dend       none 45 0 0 5 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600 NMDA 0 Ca_NMDA 0 KCa_NMDA    0 Ca_LVA 575 Ca_N 80 AMPA_bath 0 fshNa 0 fshNa-is 0 AMPA_bath 0 
   prim_dend2 prim_dend 45 0 0 5 fshNa-dend 320 Ks 40 Kt 20 KNa_slow 52 KNa_fast 150 Ca_L 2 KCa_N 600  NMDA 0 Ca_NMDA 0 KCa_NMDA   0 Ca_LVA 575 Ca_N 80 AMPA_bath 0 fshNa 0 fshNa-is 0 AMPA_bath 0

*makeproto /library/prim_dend

*start_cell 
   
   soma	none	0   0   20 20  fshNa 320 Ks 40  NMDA 0     Ca_NMDA 0   Ca_N 80 Kt 50 KCa_N 60 KNa_fast 50 Ca_L 4  KCa_NMDA 0 KNa_slow 5.2 Ca_LVA 0 fshNa-is 0 fshNa-dend 0 AMPA_bath 0
   
is soma 0 0 50   5 fshNa-is 20000 Ks 0   NMDA 0 Kt 6000 Ca_N 0 KCa_N 0 Ca_NMDA 0 KCa_NMDA 0 KNa_fast 0 KNa_slow 0 fshNa 0 fshNa-dend 0 Ca_LVA 0 Ca_L 0 AMPA_bath 0

*compt /library/prim_dend
   primdend1 soma 45 0 0 5
   primdend2 soma 45 0 0 5
  
*compt /library/sec_dend
   secdend1 primdend1/prim_dend2 37 0 0 3
   secdend2 primdend1/prim_dend2 37 0 0 3
   secdend3 primdend2/prim_dend2 37 0 0 3
   secdend4 primdend2/prim_dend2 37 0 0 3
  
 *compt /library/tert_dend
   tertdend1 secdend1/sec_dend4 30 0 0 2
   tertdend2 secdend1/sec_dend4 30 0 0 2
   tertdend3 secdend2/sec_dend4 30 0 0 2
   tertdend4 secdend2/sec_dend4 30 0 0 2
   tertdend5 secdend3/sec_dend4 30 0 0 2
   tertdend6 secdend3/sec_dend4 30 0 0 2
   tertdend7 secdend4/sec_dend4 30 0 0 2
   tertdend8 secdend4/sec_dend4 30 0 0 2
   
