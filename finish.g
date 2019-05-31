function update_msg(path)

   str path, comp
    

// HVA calcium pool

	 addmsg {path}/Ca_N/     {path}/Ca_N/Ca_N_pool	I_Ca Ik
	 addmsg {path}/Ca_N/Ca_N_pool	{path}/KCa_N 	CONCEN	Ca

// Sodium pool(s)
    // If comp = initial segment

     str l = {strlen {path}}
     str twolast = {substring {path} {l-2}}

     if ( {strcmp {twolast} "is"} ==0)

     echo "Fixing channel communication for initial segment"
          
     addmsg {path}/fshNa-is/	{path}/fshNa-is/Na_pool		I_Ca	Ik
     addmsg {path}/fshNa-is/	{path}/fshNa-is/Na_slow_pool		I_Ca	Ik

	 addmsg {path}/fshNa-is/Na_pool	{path}/KNa_fast	CONCEN  Ca
	 addmsg {path}/fshNa-is/Na_slow_pool	{path}/KNa_slow	CONCEN  Ca
     
end

     if ( {strcmp {twolast} "ma"} ==0)
        
        echo "Fixing channel communication for soma"

        // Soma

        addmsg {path}/fshNa/	{path}/fshNa/Na_pool		I_Ca	Ik
        addmsg {path}/fshNa/	{path}/fshNa/Na_slow_pool		I_Ca	Ik
        
        addmsg {path}/fshNa/Na_pool	{path}/KNa_fast	CONCEN  Ca
        addmsg {path}/fshNa/Na_slow_pool	{path}/KNa_slow	CONCEN  Ca

    end

    str nexttolast = {substring {path} {l-2} {l-2}}
    str scdnexttolast = {substring {path} {l-3} {l-3}}

    if  (({strcmp {nexttolast} "d"} ==0) || ({strcmp {scdnexttolast} "d"} ==0))

        // echo "Fixing channel communication for" {path}

        // Dendrites

        addmsg {path}/fshNa-dend/	{path}/fshNa-dend/Na_pool		I_Ca	Ik
        addmsg {path}/fshNa-dend/	{path}/fshNa-dend/Na_slow_pool		I_Ca	Ik
        
        addmsg {path}/fshNa-dend/Na_pool	{path}/KNa_fast	CONCEN  Ca
        addmsg {path}/fshNa-dend/Na_slow_pool	{path}/KNa_slow	CONCEN  Ca

     end
end

function fix_bath_channels (path)

// Bath AMPA, NMDA, NMDA calcium and NMDA synapses 

	float	Area = PI*{getfield {path} dia}*{getfield {path} len} // Approximation
	
    setfield	{path}/AMPA_bath		gbar	{Area*AMPA}
    
    str l = {strlen {path}}
    str twolast = {substring {path} {l-2}}

    if ( {strcmp {twolast} "ma"} ==0)    

        float NMDA_factor = 30;
        float Ca_NMDA_factor = 2;
        float KCa_NMDA_dens = 0.175;

    else // assume dendrites; the NMDA conductances are set to 0 on the initial segment later

        float NMDA_factor = 5;
        float Ca_NMDA_factor = 1;
        float KCa_NMDA_dens = 1.75;

    end

    setfield	{path}/NMDA		    Gbar	{Area*NMDA_factor*NMDA}
    setfield	{path}/Ca_NMDA		Gbar	{Area*Ca_NMDA_factor*NMDA}
    setfield	{path}/KCa_NMDA		Gbar	{Area*KCa_NMDA_dens}
    
    addmsg {path}/Ca_NMDA {path}/Ca_NMDA/Ca_NMDA_pool 	I_Ca	Ik
    addmsg {path}/Ca_NMDA/Ca_NMDA_pool {path}/KCa_NMDA CONCEN Ca

end

function make_cell(file,path)
	str file,path,comp
	readcell {file} /{path} -hsolve
//	readcell {file} /{path} 

	foreach comp ({el /{path}/##[OBJECT=compartment]})
	   update_msg {comp}
       fix_bath_channels {comp}
	end

// Initial segment

    setfield /{path}/is/NMDA Gbar 0
    setfield /{path}/is/Ca_NMDA Gbar 0
    setfield /{path}/is/KCa_NMDA Gbar 0

end








