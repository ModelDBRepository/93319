// Cell model with new geometry
// Primary, secondary & tertiary dendrites
   
*lambda_warn
*relative
*cartesian
*asymmetric

*set_compt_param	EREST_ACT -0.080
*set_compt_param        ELEAK -0.080
   
*set_global                     RA			1 
*set_global			CM			0.01 
*set_global			RM			1


*start_cell 
   
   soma	none	0   0   20 20  fshNa 320 Ks 40  NMDA 0     Ca_NMDA 0   Ca_N 80 Kt 50 KCa_N 60 KNa_fast 50 Ca_L 4  KCa_NMDA 0 KNa_slow 5.2 Ca_LVA 0 fshNa-is 0 fshNa-dend 0 AMPA_bath 0

is soma 0 0 50   5 fshNa-is 20000 Ks 0   NMDA 0 Kt 6000 Ca_N 0 KCa_N 0 Ca_NMDA 0 KCa_NMDA 0 KNa_fast 0 KNa_slow 0 fshNa 0 fshNa-dend 0 Ca_LVA 0 Ca_L 0 AMPA_bath 0



   
