@defcomp welfareNeutral begin

    regions      = Index()                                     # Index for RICE regions.

    eta          = Parameter()                                 # Elasticity of marginal utility of consumption.
    rho          = Parameter()                                 # Pure rate of time preference.
    l            = Parameter(index=[time, regions])            # population levels for each region.
    CPC          = Parameter(index=[time, regions, quintiles]) # Post-damage, post-abatement cost consumption (thousands 2005 USD yr⁻¹).

    welfare      = Variable()                                    # Total economic welfare.


    function run_timestep(p, v, d, t)

        if is_first(t)
            # Calculate period 1 welfare.
            v.welfare = sum((p.CPC[t,:] .^ (1.0 - p.eta)) ./ (1.0 - p.eta) .* p.l[t,:]) / (1.0 + p.rho)^(10*(t.t-1))
        else
            # Calculate cummulative welfare over time.
            v.welfare = v.welfare + sum((p.CPC[t,:,:] .^ (1.0 - p.eta)) ./ (1.0 - p.eta) .* p.l[t,:]) / (1.0 + p.rho)^(10*(t.t-1))
        end
    end
end
