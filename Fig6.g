// This script plots the 4 simulated
// two-step experiments in Fig. 6
// Long vs short pause and control vs catechol
// Cadmium is applied in all cases (no Ca2+)

float PI = 3.141592654

int	i
float dt = 1e-5
float sim_time = 2
setclock 0 {dt}
setclock 1 0.0001
setmethod 11
//setmethod 0

float NMDA=0.0
float AMPA=0.0

include library
include finish

make_cell dissociated_cell.p neuron

include xout_fig6

// if hsolve is used
call /neuron SETUP

reset

str comp
foreach comp ({el /neuron/##[OBJECT=compartment]})
  setfield {comp}/Ca_N Gbar 0
  setfield {comp}/Ca_L Gbar 0
end


float	I
float Imax = {3.14159};


// Steps with short interval

// First "control":
 
 step 0.020 -t

 float inj = 0.9e-9;

 setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0.0
 step 2e-3 -t   
 setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0
 step 250e-3 -t

// then "catechol", blocks 97% of Kt and KNaF:

float factor=0.03

str oldKt_s, oldKt_i, oldKNaF
oldKt_s = {getfield /neuron/soma/Kt Gbar}
oldKt_i = {getfield /neuron/is/Kt Gbar}
oldKNaF = {getfield /neuron/soma/KNa_fast Gbar}

setfield /neuron/soma/Kt   Gbar {{factor}*oldKt_s}
setfield /neuron/is/Kt   Gbar {{factor}*oldKt_i}
setfield /neuron/soma/KNa_fast Gbar {{factor}*oldKNaF}

 setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0.0
 step 2e-3 -t   
 setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0
 step 250e-3 -t

// Now two steps with longer pause, 
// first "control":

setfield /neuron/soma/Kt   Gbar {oldKt_s}
setfield /neuron/is/Kt   Gbar {oldKt_i}
setfield /neuron/soma/KNa_fast Gbar {oldKNaF}


 setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0.0
 step 13e-3 -t      // 13 msec 
  setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0
 step 250e-3 -t

// then "catechol":


setfield /neuron/soma/Kt   Gbar {{factor}*oldKt_s}
setfield /neuron/is/Kt   Gbar {{factor}*oldKt_i}
setfield /neuron/soma/KNa_fast Gbar {{factor}*oldKNaF}


 setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0.0
 step 13e-3 -t      // 13 msec 
  setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0
 step 250e-3 -t






































