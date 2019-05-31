/* Lamprey ion channel definitions  */

// CONSTANTS potentials in V, Area in m^2
float 	Vrest = -0.078
float 	VNa = 0.050
float 	VK = -0.085
float	Vnmda = 0.0
float	VCa_fast = 0.050
float	VCa_slow = 0.020
float	SOMA_A = 2.6e-9

/*
* Make_fast_Na_h_shifted_orig */

function make_fast_Na_h_shifted_orig(dVh,dVm,tfactor_act,tfactor_inact,act_slope,chanpath)

//========================================================================
//	generic Tabchan Na channel with scaled taus and shifted inactivation 
//========================================================================

	float	dVh,dVm, tfactor
	str chanpath

	if (({exists {chanpath}}))
		echo "channel "{chanpath}" already exists, I will not erase the first one !"
		echo "                                  and  nor will I create the 2nd one !"
		return
	end

	create tabchannel {chanpath}
	setfield ^ Ek {VNa} Gbar 1.0 Ik 0 Gk 0 Xpower 3 Ypower 1 Zpower 0

    float A_alpha_m = 0.2e6
    float B_alpha_m = {0.025+Vrest+dVm} // 
    float C_alpha_m = {act_slope*1e-3} // 1e-3
    float A_beta_m = 0.06e6 // Has to do with recovery from inactivation.
    float B_beta_m = {0.016+Vrest+dVm}
    float C_beta_m = {20e-3}

	setupalpha {chanpath} X {A_alpha_m*(B_alpha_m)} -{A_alpha_m}  \
		-1.0 {-1.0*(B_alpha_m)} -{C_alpha_m}  \
		{-{A_beta_m}*{B_beta_m}} {A_beta_m} -1.0 {-1.0*{B_beta_m}} {C_beta_m}

	setfield {chanpath} X_A->table[1100] {200}
	setfield {chanpath} X_B->table[1100] {200 + 950.1813676}	//X_B[V0x]
	setfield {chanpath} X_B->table[920] {0.22165557 + 1200} 	//X_B[V0y]

    float A_alpha_h = 0.05e5
    float B_alpha_h = {0.025+Vrest+dVh}
    float C_alpha_h = 1e-3
    float A_beta_h = 0.4e3
    float B_beta_h = {0.029+Vrest+dVh}
    float C_beta_h = 2.0e-3

	setupalpha {chanpath} Y {-{A_alpha_h}*{B_alpha_h}} {A_alpha_h} -1.0	\
	    {-1.0*{B_alpha_h}} {C_alpha_h} {A_beta_h} 0.0 1.0	\
	    {-1.0*{B_beta_h}} -{C_beta_h}

	setfield {chanpath} Y_A->table[{{0.1+0.025+Vrest+dVh}/0.00005}] {80}
	setfield {chanpath} Y_B->table[{{0.1+0.025+Vrest+dVh}/0.00005}] {80 + 47.6811682}

	scaletabchan {chanpath} X tau 1.0 {1/tfactor_act} 0.0 0.0 // activation
	scaletabchan {chanpath} Y tau 1.0 {1/tfactor_inact} 0.0 0.0 // inactivation 

end
// }}}

/*
* Make_Ks */

function make_Ks(tfactor)

	str chanpath = "Ks"
	if (({exists {chanpath}}))
		return
	end

	create tabchannel {chanpath}

	setfield ^ Ek {VK} Gbar {83*SOMA_A} Ik 0 Gk 0	Xpower 1 Ypower 0 Zpower 0

	call {chanpath} TABCREATE X 3000 -0.1 0.05

	float V

    float dV = 0e-3
 
	float A_alpha_n = {1.4449e+03} 
	float B_alpha_n = {-0.03 + dV}
	float C_alpha_n = 2e-3 
	float A_beta_n =   {1.0913e+03}
	float B_beta_n =  {0.0474 + dV}
	float C_beta_n =  2e-3


float i
	for(i=0;i<=3000;i=i+1)
		V=-0.1+i*0.00005

               setfield {chanpath} X_A->table[{i}] {{A_alpha_n*(V-B_alpha_n)}/{(1-{exp {{B_alpha_n-V}/C_alpha_n}})} }
		setfield {chanpath} X_B->table[{i}] {{getfield {chanpath} X_A->table[{i}]}+{{A_beta_n*(B_beta_n-V)}/{(1-{exp {{V-B_beta_n}/C_beta_n}})} }}

	end

	// Take care of the singularities

	int alpha_idx = {{0.1+B_alpha_n}/0.00005};
	int beta_idx = {{0.1+B_beta_n}/0.00005};

	setfield {chanpath}	X_A->table[{alpha_idx}] { 0.5 * {{{ getfield {chanpath} X_A->table[{alpha_idx-1}]}} + {{ getfield {chanpath} X_A->table[{alpha_idx+1}]}}}}
	setfield {chanpath}	X_B->table[{alpha_idx}] { 0.5 * {{{ getfield {chanpath} X_B->table[{alpha_idx-1}]}} + {{ getfield {chanpath} X_B->table[{alpha_idx+1}]}}}}
	setfield {chanpath}	X_B->table[{beta_idx}] { 0.5 * {{{ getfield {chanpath} X_B->table[{beta_idx-1}]}} + {{ getfield {chanpath} X_B->table[{beta_idx+1}]}}}}

	scaletabchan {chanpath} X tau 1.0 {1/tfactor} 0.0 0.0

end

/*
* Make_Kt */

function make_Kt(tfactor_act,tfactor_inact)

	int i=0
	float V=0
	float Vo=-0.053

	str chanpath = "Kt"

	if (({exists {chanpath}}))
		return
	end
	create tabchannel {chanpath}

	setfield ^ Ek {VK} Gbar 1.0 Ik 0 Gk 0 Xpower 3 Ypower 1 Zpower 0

	call {chanpath} TABCREATE X 3000 -0.1 0.05
	call {chanpath} TABCREATE Y 3000 -0.1 0.05

	float V

    float dV = -0e-3;

	float A_alpha_m = {8.9371e5*0.2} 
	float B_alpha_m = {0.0267 + dV} 
	float C_alpha_m = 14.3e-3 
	float A_beta_m =  {2.9207e4*0.2} 
	float B_beta_m =  {0.0440 + dV} 
	float C_beta_m =  6e-3 

	float A_alpha_h = {3*185.1544*6}
	float B_alpha_h = {0.0292 - 0.01 }
	float C_alpha_h = 6e-3 
    float A_beta_h =  {16.4762*6}
	float B_beta_h =  {-0.0085 - 0.01}
	float C_beta_h =  7.6e-3

	for(i=0;i<=3000;i=i+1)
		V=-0.1+i*0.00005

    // Activation

	setfield {chanpath} X_A->table[{i}] {{A_alpha_m*(V-B_alpha_m)}/{(1-{exp {{B_alpha_m-V}/C_alpha_m}})} }
	
    if ( {abs {V-B_beta_m}} < 1e-10 )
        echo "Singularity in activation function at index " {i}
    else
         setfield {chanpath} X_B->table[{i}] {{getfield {chanpath} X_A->table[{i}]}+{{A_beta_m*(B_beta_m-V)}/{(1-{exp {{V-B_beta_m}/C_beta_m}})} }}
    end

		// Inactivation
	setfield {chanpath} Y_A->table[{i}] {{A_alpha_h*(B_alpha_h-V)}/{(1-{exp {{V-B_alpha_h}/C_alpha_h}})} }
	setfield {chanpath} Y_B->table[{i}] {{getfield {chanpath} Y_A->table[{i}]}+{{A_beta_h}/{(1+{exp {{B_beta_h-V}/C_beta_h}})} }}
	end

	// Take care of the singularities

	int alpha_idx = {{0.1+B_alpha_m}/0.00005};
	int beta_idx = {{0.1+B_beta_m}/0.00005};
	int alpha_h_idx = {{0.1+B_alpha_h}/0.00005};

	setfield {chanpath}	X_A->table[{alpha_idx}] { 0.5 * {{{ getfield {chanpath} X_A->table[{alpha_idx-1}]}} + {{ getfield {chanpath} X_A->table[{alpha_idx+1}]}}}}
	setfield {chanpath}	X_B->table[{alpha_idx}] { 0.5 * {{{ getfield {chanpath} X_B->table[{alpha_idx-1}]}} + {{ getfield {chanpath} X_B->table[{alpha_idx+1}]}}}}
	setfield {chanpath}	X_B->table[{beta_idx}] { 0.5 * {{{ getfield {chanpath} X_B->table[{beta_idx-1}]}} + {{ getfield {chanpath} X_B->table[{beta_idx+1}]}}}}

    // Check that the singularity was removed
    echo "Removed singularity at index" {beta_idx} "; set function value to" {getfield {chanpath} X_B->table[{beta_idx}]}

	setfield {chanpath}	Y_A->table[{alpha_h_idx}] { 0.5 * {{{ getfield {chanpath} Y_A->table[{alpha_h_idx-1}]}} + {{ getfield {chanpath} Y_A->table[{alpha_h_idx+1}]}}}} 
	setfield {chanpath}	Y_B->table[{alpha_h_idx}] { 0.5 * {{{ getfield {chanpath} Y_B->table[{alpha_h_idx-1}]}} + {{ getfield {chanpath} Y_B->table[{alpha_h_idx+1}]}}}}

	// Scaling

	scaletabchan {chanpath} X tau 1.0 {1/tfactor_act} 0.0 0.0
	scaletabchan {chanpath} Y tau 1.0 {1/tfactor_inact} 0.0 0.0

end

/*
* Make_NMDA */

function make_NMDA

	str chanpath = "NMDA"
	if (({exists {chanpath}}))
		return
	end

	create tabchannel {chanpath}
	setfield ^ Ek {Vnmda} Gbar {75*SOMA_A} Ik 0 Gk 0	Xpower 1 Ypower 0 Zpower 0

	setupalpha {chanpath} X 0.7e3 0.0 0.0 0.0 -17e-3 \
							{1.8*5.6} 0.0 0.0 0.0 17e-3

end

/*
* Make_Ca_L */

function make_Ca_L

	str chanpath = "Ca_L"
	if (({exists {chanpath}}))
		return
	end

    float V
    int i 

	create tabchannel {chanpath}

// Version with one gate, minf/tau formalism, and constant tau

	call {chanpath} TABCREATE X 30 -0.100 0.050
	call {chanpath} TABCREATE Y 30 -0.100 0.050

	setfield ^ Ek {VCa_fast} Gbar 0 Ik 0 Gk 0 Xpower 1 Ypower 0 Zpower 0

	for(i=1;i<=30;i=i+1)
		// echo {i}
        V = -0.1+i*0.005
        setfield {chanpath} X_A->table[{i}] 0.003     // constant tau of 3 ms
        setfield {chanpath} X_B->table[{i}] {1/ {1+ {exp {{({V}+0.025)}/-0.005}} } }    
    end

    tweaktau {chanpath} X

    call {chanpath} TABFILL X 3000 0
    call {chanpath} TABFILL Y 3000 0

end

/*
* Make_Ca_LVA */

function make_Ca_LVA

	str chanpath = "Ca_LVA"
	if (({exists {chanpath}}))
		return
	end

	create tabchannel {chanpath}

	setfield ^ Ek {VCa_fast} Gbar {75*SOMA_A} Ik 0 Gk 0 Xpower 3 Ypower 1 Zpower 0

	call {chanpath} TABCREATE X 3000 -0.1 0.05
	call {chanpath} TABCREATE Y 3000 -0.1 0.05

	float A_alpha_m = 0.02e6
	float B_alpha_m = -58e-3
	float C_alpha_m = 4.5e-3
	float A_beta_m =  0.05e6
	float B_beta_m =  -61e-3
	float C_beta_m =  4.5e-3

	float A_alpha_h = 0.0001e3
	float B_alpha_h = -63e-3
	float C_alpha_h = 7.8e-2 // Original paper had 7.8e-3, adjusted because of changes in spike threshold
    float A_beta_h =  0.03e3
	float B_beta_h =  -61e-3
	float C_beta_h =  4.8e-3

    float i, V
	for(i=0;i<=3000;i=i+1)
		V=-0.1+i*0.00005

	setfield {chanpath} X_A->table[{i}] {{A_alpha_m*(V-B_alpha_m)}/{(1-{exp {{B_alpha_m-V}/C_alpha_m}})} }
	setfield {chanpath} X_B->table[{i}] {{getfield {chanpath} X_A->table[{i}]}+{{A_beta_m*(B_beta_m-V)}/{(1-{exp {{V-B_beta_m}/C_beta_m}})} }}
		
		// Inactivation
	setfield {chanpath} Y_A->table[{i}] {{A_alpha_h*(B_alpha_h-V)}/{(1-{exp {{V-B_alpha_h}/C_alpha_h}})} }
	setfield {chanpath} Y_B->table[{i}] {{getfield {chanpath} Y_A->table[{i}]}+{{A_beta_h}/{(1+{exp {{B_beta_h-V}/C_beta_h}})} }}

	end

	// Take care of the singularities

	int alpha_idx = {{0.1+B_alpha_m}/0.00005};
	int beta_idx = {{0.1+B_beta_m}/0.00005};
	int alpha_h_idx = {{0.1+B_alpha_h}/0.00005};

	setfield {chanpath}	X_A->table[{alpha_idx}] { 0.5 * {{{ getfield {chanpath} X_A->table[{alpha_idx-1}]}} + {{ getfield {chanpath} X_A->table[{alpha_idx+1}]}}}}
	setfield {chanpath}	X_B->table[{alpha_idx}] { 0.5 * {{{ getfield {chanpath} X_B->table[{alpha_idx-1}]}} + {{ getfield {chanpath} X_B->table[{alpha_idx+1}]}}}}
	setfield {chanpath}	X_B->table[{beta_idx}] { 0.5 * {{{ getfield {chanpath} X_B->table[{beta_idx-1}]}} + {{ getfield {chanpath} X_B->table[{beta_idx+1}]}}}}
	setfield {chanpath}	Y_A->table[{alpha_h_idx}] { 0.5 * {{{ getfield {chanpath} Y_A->table[{alpha_h_idx-1}]}} + {{ getfield {chanpath} Y_A->table[{alpha_h_idx+1}]}}}} 
	setfield {chanpath}	Y_B->table[{alpha_h_idx}] { 0.5 * {{{ getfield {chanpath} Y_B->table[{alpha_h_idx-1}]}} + {{ getfield {chanpath} Y_B->table[{alpha_h_idx+1}]}}}}

end

/*
* Make_Ca_N */

function make_Ca_N

	str chanpath = "Ca_N"
	if (({exists {chanpath}}))
		return
	end

	create tabchannel {chanpath}


// Using m²h format from Booth et al 1997. The equations are expressed in minf and tau.

	call {chanpath} TABCREATE X 30 -0.100 0.050
	call {chanpath} TABCREATE Y 30 -0.100 0.050

	float Vrev = VCa_fast // Reversal potential of calcium from article
	float V = 0

	setfield ^ Ek {Vrev} Gbar {75*SOMA_A} Ik 0 Gk 0 Xpower 2 Ypower 1 Zpower 0

// Activation & inactivation; tau and steady-state activation values
// Use a normal distribution for tau for testing purposes
	
 	float tau_act_mu = 0;
	float tau_act_sigma = 100;
	float tau_inact_mu = -0.045;
	float tau_inact_sigma = 0.010;
	float pi = 3.1415926;

// Try with double exponentials

	float A=5e-3; // 11/5 2003 changed from 10e-3
	float B=10e-3;
	float C=120e-3;
	float D=1.6e-3;

    float i
	for(i=1;i<=30;i=i+1)
		V = -0.1+i*0.005        
        setfield {chanpath} X_A->table[{i}] 0.004 
		setfield {chanpath} X_B->table[{i}] {1/ {1+ {exp {{({V}+0.015)}/-0.0055}} } }
		setfield {chanpath} Y_A->table[{i}] 0.3      
		setfield {chanpath} Y_B->table[{i}] {1/ {1+ {exp {{({V}+0.035)}/0.005}}} }
	end

tweaktau {chanpath} X
tweaktau {chanpath} Y

call {chanpath} TABFILL X 3000 0
call {chanpath} TABFILL Y 3000 0

end

/*
* Make_Ca_pools */

function make_Ca_pools  

	create Ca_concen Ca_NMDA/Ca_NMDA_pool
	setfield ^ B {1.25e5} tau 2

	create Ca_concen Ca_N/Ca_N_pool
	setfield ^ B {1.25e5} tau 0.030 // 
	
	// Fast pool (s)
	create Ca_concen fshNa/Na_pool
	setfield ^ B 5e11 tau 0.00015

	// Fast pool (d)
	create Ca_concen fshNa-dend/Na_pool
	setfield ^ B 5e11 tau 0.00015

	// Fast pool (is) 
	create Ca_concen fshNa-is/Na_pool
	setfield ^ B 5e11 tau 0.00015

    // Slow pool (s)
    create Ca_concen fshNa/Na_slow_pool
    setfield ^ B 3e8 tau 0.05

    // Slow pool (dend)
    create Ca_concen fshNa-dend/Na_slow_pool
    setfield ^ B 3e8 tau 0.05

    // A special pool for KNaS (is)
    create Ca_concen fshNa-is/Na_slow_pool
    setfield ^ B 3e8 tau 0.05

end

/*
* Make_Ca_NMDA */

function make_Ca_NMDA

	str chanpath = "Ca_NMDA"

	if (({exists {chanpath}}))
		return
	end

	create tabchannel {chanpath}
	setfield ^ Ek {VCa_slow} Gbar 1  Ik 0 Gk 0	Xpower 1 Ypower 0 Zpower 0

	setupalpha {chanpath} X 0.7e3 0.0 0 {0.07 + Vrest} -17e-3 \
							10.08 0.0 0 {0.07 + Vrest} 17e-3

end

/*
* Make_KCa_NMDA */

function make_KCa_NMDA

	int i

	float dx
	str chanpath = "KCa_NMDA"
	if (({exists {chanpath}}))
		return
	end

	create	tabchannel {chanpath}
	setfield	^	Ek			{VK}		\
					Gbar		40e-9		\
			        	Ik		0			\
					Gk		0			\
					Xpower  	0			\
					Ypower  	0			\
					Zpower  	1			\
					Z		0.0  instant {INSTANTZ}


	call {chanpath} TABCREATE Z 30000 0 1e-4
	dx={{1.0e-4}/30000}
	
	// We need a factor to bring the current into the right range

    float K = 5e-7; 

    // Use a saturating function with K = 5e-7

	for (i=0;i<=30000;i=i+1)
        float conc = i*dx;
		setfield {chanpath} Z_A->table[{i}] {conc/(conc+K)} 
		setfield {chanpath} Z_B->table[{i}] {1}
	end
	
    // echo "Ca_NMDA"
    // echo {getfield {chanpath} Z_A->table[0]}
    // echo {getfield {chanpath} Z_A->table[3000]}
    // echo {getfield {chanpath} Z_A->table[3001]}
    // echo {getfield {chanpath} Z_A->table[5000]}
    // echo "End Ca_NMDA"

    // call {chanpath} TABFILL Z 3000 0
end

/*
* Make_KCa_N */

function make_KCa_N

	int i

	float dx
	str chanpath = "KCa_N"
	if (({exists {chanpath}}))
		return
	end


   create  tabchannel {chanpath}
   setfield	^		Ek  		{VK}		\
					Gbar		200e-9		\
					Ik			0			\
					Gk			0			\
					Xpower  	0			\
					Ypower  	0			\
					Zpower  	1			\
					Z			0.0   instant {INSTANTZ}


	call {chanpath} TABCREATE Z 30000 0 1e-4
	dx={{1.0e-4}/30000}
  
    float K = 5e-7; 

    // Use a saturating function with K = 5e-7

    // A is just a proportionality constant

 
	for (i=0;i<=30000;i=i+1)
        float conc = i*dx;
		setfield {chanpath} Z_A->table[{i}] {conc/(conc+K)} 
		setfield {chanpath} Z_B->table[{i}] {1}
	end
	
end

/*
* Make_KNa_fast */

function make_KNa_fast

	int i
	float dx
	str chanpath = "KNa_fast"
	if (({exists {chanpath}}))
		return
	end

   create  tabchannel {chanpath}
   setfield	^ Ek  {VK} Gbar	200e-9	Ik 0 Gk	0 Xpower 0 Ypower 0 Zpower  1 Z	0.0 // instant {INSTANTZ}

    float lowlimit = 0e-3
    float highlimit = 1000e-3 

	call {chanpath} TABCREATE Z 3000 {lowlimit} {highlimit}
	float dx, x
    float span = {highlimit-lowlimit};
    float A = 1;
    float delayfactor = 6000; // measures the delay; the inverse time constant 
    dx={span/3000}
	x = 0
    float n = 1; // Hill coefficient
    float K = 100e-3; // Half-activation
	float conc, conc_mM, K_mM, d;

    for (i=0;i<=3000;i=i+1)
        conc = {i*dx};
        conc_mM = 1000*conc;
        K_mM = 1000*K;
        
        if (conc_mM > 0)
            d = {exp {n*{log {conc_mM}}}}
        else
            d = 0
        end

        float Kd = {exp {n*{log {K_mM}}}}
  
        setfield {chanpath} Z_A->table[{i}] { {delayfactor*d} / { {d} + {Kd} } }
        setfield {chanpath} Z_B->table[{i}] { delayfactor }
        
    end
	call {chanpath} TABFILL Z 3000 0

end

/* make_KNa_slow */

function make_KNa_slow

	int i

	str chanpath = "KNa_slow"
	if (({exists {chanpath}}))
		return
	end


   create  tabchannel {chanpath}
   setfield	^		Ek  		{VK}		\
					Gbar		200e-9		\
					Ik			0			\
					Gk			0			\
					Xpower  	0			\
					Ypower  	0			\
					Zpower  	1			\
					Z			0.0   instant {INSTANTZ}


	call {chanpath} TABCREATE Z 3000 0.0 1.0
	float dx={{1e1}/3000}

    float K = 100e-3; 

	for (i=0;i<=3000;i=i+1)
        float conc = i*dx;
        setfield {chanpath} Z_A->table[{i}] {conc/(conc+K)} 
		setfield {chanpath} Z_B->table[{i}] {1}
	end
	
end

/* Bath AMPA */

function make_bath_AMPA

create vdep_channel AMPA_bath

// The bath-AMPA conductance is set by finish.g.

      setfield AMPA_bath Ek     {0} gbar   {0}
         
end

























