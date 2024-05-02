
module Lisa

	#=
		Can use this to set the number of threads for BLAS used in BART as well
		using LinearAlgebra
		BLAS.set_num_threads(Threads.nthreads())
	=#

	export write_bart, read_bart

	mutable struct EcalibConf
		kdims::NTuple{3, Clong}
		threshold::Cfloat 
		numsv::Cint
		percentsv::Cfloat
		weighting::Cchar
		softcrop::Cchar
		crop::Cfloat
		orthiter::Cchar
		num_orthiter::Cint
		usegpu::Cchar
		perturb::Cfloat
		intensity::Cchar
		rotphase::Cchar
		var::Cfloat
		automate::Cchar
	end

	function write_bart(name::AbstractString, a::Array{ComplexF32, N}) where N
		f = open(name * ".cfl", "w")
		write(f, a)
		close(f)
		f = open(name * ".hdr", "w")
		write(f, "# Dimensions\n" * join(size(a), " "))
		close(f)
		return
	end
	function read_bart(name::AbstractString)
		shape_str = readlines(name * ".hdr")[2]
		shape = parse.(Int, split(shape_str))
		a = Array{ComplexF32, length(shape)}(undef, shape...)
		f = open(name * ".cfl", "r")
		read!(f, a)
		close(f)
		return a
	end

	global bart
	function set_bart_library(path::AbstractString)
		global bart = path
		return
	end
	set_bart_library(expanduser("~/packages/bart/libbart.so"))

end

