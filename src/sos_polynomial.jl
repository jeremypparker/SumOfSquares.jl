function build_gram_matrix(q::Vector{MOI.VariableIndex},
                           monos::AbstractVector{<:MP.AbstractMonomial})
    return build_gram_matrix([MOI.SingleVariable(vi) for vi in q], monos)
end
function build_gram_matrix(q::Vector,
                           monos::AbstractVector{<:MP.AbstractMonomial})
    return GramMatrix(MultivariateMoments.SymMatrix(q, length(monos)),
                         monos)
end

function add_gram_matrix(model::MOI.ModelLike, matrix_cone_type::Type,
                         monos::AbstractVector{<:MP.AbstractMonomial})
    Q, cQ = MOI.add_constrained_variables(model, matrix_cone(matrix_cone_type, length(monos)))
    q = build_gram_matrix(Q, monos)
    return q, Q, cQ
end
function add_gram_matrix(model::MOI.ModelLike, matrix_cone_type::Type,
                         monos::Vector{<:AbstractVector{<:MP.AbstractMonomial}})
    qQcQ = add_gram_matrix.(model, matrix_cone_type, monos)
    return SparseGramMatrix(getindex.(qQcQ, 1)), getindex.(qQcQ, 2), getindex.(qQcQ, 3)
end

function build_moment_matrix(q::Vector,
                             monos::AbstractVector{<:MP.AbstractMonomial})
    return MomentMatrix(MultivariateMoments.SymMatrix(q, length(monos)),
                        monos)
end

struct SOSPolynomialSet{DT <: AbstractSemialgebraicSet,
                        MT <: MP.AbstractMonomial,
                        MVT <: AbstractVector{MT},
                        CT <: Certificate.AbstractCertificate} <: MOI.AbstractVectorSet
    domain::DT
    monomials::MVT
    certificate::CT
end
MOI.dimension(set::SOSPolynomialSet) = length(set.monomials)
