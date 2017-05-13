
function [intake_out_flow, A1, A2] = intake_solver(ram_air, intake)
	
	%%%%%%%%%% extract inputs
	m_dot = ram_air.m_dot;
	cp    = ram_air.cp;
	gama  = ram_air.gama;
	T1    = ram_air.T;
	P1    = ram_air.P;
	ro1   = ram_air.ro;
	M1    = ram_air.M;
	
	M2  = intake.M_out;
	efficiency = intake.efficiency;
	
	R = cp * (1-1/gama);
	
	%%%%%%%%%% input area of intake
	V1 = M1 * sqrt(gama*R*T1);
	if ( (ro1*V1)>0 )
		A1 = m_dot / (ro1*V1);
	else
		A1 = inf;
	end
	
	%%%%%%%%%% out flow of intake
	T0T1 = 1 + (gama-1)/2 * M1^2;
	T0T2 = 1 + (gama-1)/2 * M2^2;
	T2T1 = T0T1/T0T2;
	
	T2 = T1 * T2T1;
	ro2 = ro1 * T2T1^(1/(gama-1));
	P2  = P1  * T2T1^(gama/(gama-1));
	
	% considering efficiency
	P2  = P2  * efficiency;
	ro2 = ro2 * efficiency;
	
	intake_out_flow = ram_air;
	intake_out_flow.T = T2;
	intake_out_flow.P = P2;
	intake_out_flow.ro = ro2;
	intake_out_flow.M = M2;
	
	%%%%%%%%%% output area of intake
	V2 = M2 * sqrt(gama*R*T2);
	A2 = m_dot / (ro2*V2);
	
end

