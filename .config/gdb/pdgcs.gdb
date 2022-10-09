define pstmt
	if $argc == 0
		help pstmt
	else
		set $vec = Stmt_base.m_vector
		set $size = $vec._M_impl._M_finish - $vec._M_impl._M_start
		set $capacity = $vec._M_impl._M_end_of_storage - $vec._M_impl._M_start
		set $size_max = $size - 1
	end
	if $argc == 1
		set $idx = $arg0
		if $idx < 0 || $idx > $size_max
			printf "idx1, idx2 are not in acceptable range: [0..%u].\n", $size_max
		else
			printf "elem[%u]: ", $idx
			p *($vec._M_impl._M_start + $idx)
		end
	end
end

document pstmt
	Prints Stmt_base information.
	Syntax: pstmt <idx1>
	Note: idx must be in acceptable range [0..<Stmt_base>.size()-1].
	Examples: pstmt 0
	Prints element[idx] from Stmt_base
end

define pexp
	if $argc == 0
		help pexpr
	else
		p print_exp_info($arg0)
	end
end

document pexp
	Prints EXP_INFO object.
	Syntax: pexpr <exp_info>
	Examples: pexpr use_obj
	Prints the use_obj object using print_exp_info function
end
