
function solve_manager_turbojet()
	close(),	clear()
	
	[ram_air, intake, compressor, combustor, turbine, nozzle, mech_feat] = userdata_turbojet();
	
	% [SFC, Thrust] = GT_solver_turbojet(ram_air, intake, compressor, combustor, turbine, nozzle, mech_feat);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	nx = 25; ny = 35;
	
	SFC_matrix = zeros(ny,nx);
	Thrust_matrix = zeros(ny,nx);
	m_dot_matrix = zeros(ny,nx);
	
	T_max_list = linspace(1000,1200,  ny);
	P_ratio_list = linspace(3,5,  nx);
	
	for ii=1:max(size(T_max_list))
		T_max = T_max_list(ii);
		for jj=1:max(size(P_ratio_list))
			P_ratio = P_ratio_list(jj);
			compressor.P_ratio = P_ratio;
			combustor.T_max    = T_max;
			
			%%%% adjusting the mass flow by secant method to achieve 500N thrust
			for kk=1:2
				m_dot1 = ram_air.m_dot;
				[SFC1, Thrust1] = GT_solver_turbojet(ram_air, intake, compressor, combustor, turbine, nozzle, mech_feat);
				er_thrust1 = Thrust1 - 500;
				
				m_dot2 = m_dot1*0.99;		ram_air.m_dot = m_dot2;
				[SFC2, Thrust2] = GT_solver_turbojet(ram_air, intake, compressor, combustor, turbine, nozzle, mech_feat);
				er_thrust2 = Thrust2 - 500;
				
				ram_air.m_dot = m_dot2 - (m_dot1-m_dot2)/(er_thrust1-er_thrust2) * er_thrust2;
				
				% [SFC, Thrust] = GT_solver_turbojet(ram_air, intake, compressor, combustor, turbine, nozzle, mech_feat);
				% [kk,  ram_air.m_dot,  SFC,  Thrust-500]    % checking the convergence
			end
			
			m_dot_matrix(ii,jj) = ram_air.m_dot;
			[SFC, Thrust] = GT_solver_turbojet(ram_air, intake, compressor, combustor, turbine, nozzle, mech_feat);
			SFC_matrix(ii,jj) = SFC;
			Thrust_matrix(ii,jj) = Thrust;
		end
	end
	
	[T_max,P_ratio] = meshgrid(P_ratio_list, T_max_list);
	
	% mark design point of gas turbine on plot
	choosed_design_point = [4,1100];
	
	subplot(1,2,1);
	contourf(T_max,P_ratio,SFC_matrix);    title 'SFC (kg/(N.hr))'
	colorbar("location", "NorthOutside"),	xlabel 'Pressure Ratio',	ylabel 'Temperature (Kelvin)',	grid on
	hold on; h = plot(choosed_design_point(1),choosed_design_point(2),'*r'); set(h,'linewidth', 6)
	
	subplot(1,2,2);
	contourf(T_max,P_ratio,m_dot_matrix);    title 'm_d_o_t (kg/s)'
	colorbar("location", "NorthOutside"),	xlabel 'Pressure Ratio',	ylabel 'Temperature (Kelvin)',	grid on
	hold on; h = plot(choosed_design_point(1),choosed_design_point(2),'*r'); set(h,'linewidth', 6)
	
	
end

