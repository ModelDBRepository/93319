
// This script imposes simulated spike trains of different frequencies
// (100/66/50/33/25/20 Hz) on the model cell, first in a control case
// and then in Cd2+ (assumed to block all Ca2+ channels) to examine sAHP summation.
// The ratios of the last resulting sAHPs after each train in ctrl/Cd2+
// are plotted in Fig. 4b 


float PI = 3.141592654

int	i
float dt = 1e-5
float sim_time = 10
setclock 0 {dt}
setclock 1 0.0001
setmethod 11
//setmethod 0

float NMDA=0.0
float AMPA=0.0


include library
include finish

make_cell cell.p neuron

include xout_fig4b

// if hsolve is used
call /neuron SETUP

reset

float	Iinj = 6e-9
float Imax = {3.14159};

// 100 Hz imposed spiking

 for(i=1;i<=10;i=i+1) 
 step 0.008 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.200 -t

// 66 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.014 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.200 -t

// 50 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.018 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.200 -t

// 33 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.028 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.200 -t

// 25 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.038 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.200 -t

// 20 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.048 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.200 -t 


// Block calcium channels to simulate cadmium application
// Actually Cd2+ does not fully block LVA channels, but we assume here that it does

str comp
foreach comp ({el /neuron/##[OBJECT=compartment]})
  setfield {comp}/Ca_N Gbar 0
  setfield {comp}/Ca_L Gbar 0
  setfield {comp}/Ca_LVA Gbar 0
end

 float Iinj = 5e-9

 // 100 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.008 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.200 -t 

 // 66 Hz

 step 0.2 -t

 for(i=1;i<=10;i=i+1) 
 step 0.014 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.2 -t

 // 50 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.018 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.2 -t

 // 33 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.028 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.2 -t

 // 25 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.038 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.2 -t
 
 // 20 Hz

 for(i=1;i<=10;i=i+1) 
 step 0.048 -t  
 setfield /neuron/soma inject {Iinj}
 step 0.002 -t
 setfield /neuron/soma inject 0
 end

 step 0.2 -t
































