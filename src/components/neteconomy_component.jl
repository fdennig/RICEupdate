@defcomp neteconomy begin
    regions = Index()

    Y = Variable(index=[time, regions]) # Gross world product net of abatement and damages (trillions 2005 USD per year)
    I = Variable(index=[time, regions]) # Investment (trillions 2005 USD per year)
    C = Variable(index=[time, regions]) # Consumption (trillions 2005 US dollars per year)
    CPC = Variable(index=[time, regions]) # Per capita consumption (thousands 2005 USD per year)

    ABATEFRAC = Parameter(index=[time, regions]) # Share of output lost from abatement activity
    YGROSS = Parameter(index=[time, regions]) # Gross world product GROSS of abatement and damages (trillions 2005 USD per year)
    DAMFRAC = Parameter(index=[time, regions]) # Damages as fraction of gross output
    S = Parameter(index=[time, regions]) # Gross savings rate as fraction of gross world product
    l = Parameter(index=[time, regions]) # Level of population and labour

    function run_timestep(p, v, d, t)

        #Define function for YNET
        for r in d.regions
                v.Y[t,r] = (1-p.ABATEFRAC[t,r])*p.YGROSS[t,r]/(1+p.DAMFRAC[t,r])
        end

        #Define function for I
        for r in d.regions
            v.I[t,r] = p.S[t,r] * v.Y[t,r]
        end

        #Define function for C
        for r in d.regions
            if t.t != 60
                v.C[t,r] = v.Y[t,r] - v.I[t,r]
            else
                v.C[t,r] = v.C[t-1, r]
            end
        end

        #Define function for CPC
        for r in d.regions
            v.CPC[t,r] = 1000 * v.C[t,r] / p.l[t,r]
        end
    end
end
