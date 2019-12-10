@defcomp damages begin
    regions = Index()

    DAMFRAC = Variable(index=[time, regions]) # Damages as % of GDP

    TATM = Parameter(index=[time]) # Increase temperature of atmosphere (degrees C from 1900)
    SLRDAMAGES = Parameter(index=[time, regions])
    a1 = Parameter(index=[regions]) # Damage intercept
    a2 = Parameter(index=[regions]) # Damage quadratic term
    a3 = Parameter(index=[regions]) # Damage exponent

    function run_timestep(p, v, d, t)

        #Define function for DAMFRAC
        for r in d.regions
            v.DAMFRAC[t,r] = (((p.a1[r] * p.TATM[t]) + (p.a2[r] * p.TATM[t]^p.a3[r])) / 100) + (p.SLRDAMAGES[t,r] / 100)
        end
    end
end
