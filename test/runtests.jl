using MultivariatePolynomials
using JuMP
using SumOfSquares
using PolyJuMP
using FactCheck

include("solvers.jl")

include("certificate.jl")
include("constraint.jl")

include("motzkin.jl")

# SOSTools demos
include("sospoly.jl")
include("sosdemo2.jl")
include("sosdemo3.jl")
include("sosdemo4.jl")
#include("sosdemo5.jl")
include("sosdemo6.jl")
include("sosmatrix.jl")

FactCheck.exitstatus()
