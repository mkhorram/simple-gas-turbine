
function [SFC, Thrust] = GT_solver_turbojet(ram_air, intake, compressor, combustor, turbine, nozzle, mech_feat)
	
	% disp '********** GT_turbojet_solver **********'
	
	[intake_out_flow, A1, A2] = intake_solver(ram_air, intake);
	
	[compressor_out_flow, compressor_power] = compressor_solver(intake_out_flow, compressor);
	
	[combustor_out_flow, fuel_m_dot] = combustion_chamber_solver(compressor_out_flow, combustor);
	
	% compute the required power from turbine
	power_needs = (compressor_power + mech_feat.APU) / mech_feat.mech_efficiency;
	
	[turbine_out_flow] = turbine_solver(combustor_out_flow, power_needs, turbine);
	
	ram_air_pressure = ram_air.P;
	[nozzle_out_flow, exit_velocity] = nozzle_solver(turbine_out_flow, nozzle, ram_air_pressure);
	
	% compute the thrust
	R1 = ram_air.cp*(1-1/ram_air.gama);
	V1 = ram_air.M * sqrt(ram_air.gama*R1*ram_air.T);
	
	Thrust = nozzle_out_flow.m_dot*exit_velocity - ram_air.m_dot*V1;
	
	% rough estimation of SFC
	SFC = fuel_m_dot * 3600 / Thrust;   % kg/(N.hr)
	
end
