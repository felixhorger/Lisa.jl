
# Load data
gre = read_bart("...");
DIMS = 16
in_dims = Clong[size(gre)..., ones(DIMS - length(size(gre)))...]

# Use the adjusted c-function (default settings)
@ccall Bart.ecalib_felix(
	pointer(gre)::Ptr{ComplexF32},
	in_dims::Ptr{Clong}
)::Ptr{ComplexF32}




# Using calib2()
ecalib_defaults = EcalibConf(
	(6, 6, 6),		# kdims
	0.001,			# threshold
	-1,				# numsv
	-1.0,	   		# percentsv
	false,	 		# weighting
	false,	  		# softcrop
	0.8,			# crop
	true,			# orthiter
	30,				# num_orthiter
	false,			# usegpu
	-1.0,			# perturb
	false,			# intensity
	true,			# rotphase
	-1.0,			# var
	false			# automate
)

kernelsize = Cint[6, 6, 6]
num_kernel = prod(kernelsize)
out_data = Vector{ComplexF32}(undef, prod(out_dims))
eptr = Vector{ComplexF32}(undef, prod(out_dims))
svals = Vector{ComplexF32}(undef, num_kernel)
calreg_dims = Clong[size(gre)..., ones(DIMS - length(size(gre)))...]

#= calib2(
	const struct ecalib_conf* conf,
	const long out_dims[DIMS],
	complex float* out_data,
	complex float* eptr,
	int SN,
	float svals[SN],
	const long calreg_dims[DIMS],
	const complex float* data,
	const long msk_dims[3],
	const bool* msk
)
=#
@ccall Bart.calib2(
	pointer_from_objref(ecalib_defaults)::Ptr{EcalibConf},
	out_dims::Ptr{Clong},
	out_data::Ptr{ComplexF32},
	eptr::Ptr{ComplexF32},
	num_kernel::Cint,
	pointer(svals)::Ptr{ComplexF32},
	pointer(calreg_dims)::Ptr{Clong},
	pointer(gre)::Ptr{ComplexF32},
	C_NULL::Ptr{Nothing},
	C_NULL::Ptr{Nothing}
)::Cvoid

