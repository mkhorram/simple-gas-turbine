
function [nozzle_out_flow, exit_velocity] = nozzle_solver(turbine_out_flow, nozzle, ram_air_pressure)
	
	%%%%%%%%%% extract inputs of combustor
	m_dot = turbine_out_flow.m_dot;
	cp    = turbine_out_flow.cp;
	gama  = turbine_out_flow.gama;
	T1    = turbine_out_flow.T;
	P1    = turbine_out_flow.P;
	ro1   = turbine_out_flow.ro;
	M1    = turbine_out_flow.M;
	
	efficiency        = nozzle.efficiency;
	
	%%%%% the out flow of nozzle
	P_ratio = ram_air_pressure / P1;
	
	P2 = ram_air_pressure;
	T2 = T1 * P_ratio ^ ((gama-1)/gama);
	ro2 = ro1 * P_ratio ^ (1/gama);
	
	% [T1,P1,ro1, P1/T1/ro1;T2,P2,ro2, P2/T2/ro2]
	
	nozzle_out_flow = turbine_out_flow;
	nozzle_out_flow.P = P2;
	nozzle_out_flow.T = T2;
	nozzle_out_flow.ro = ro2;
	
	%%%%% exit flow velocity
	
	dT = T2 - T1;
	
	exit_velocity = sqrt( abs( 2*cp*dT ) );
	
end
