using Mimi

# Load RICE+AIR source code.
include("src/mRICE2010.jl")

m = get_model()
run(m)

explore(m)

# say you want to change some parameter
#like the discount rate
m[:welfare,:rho] = 1.5
#or the mitigation fraction, this is how we input the control variable in the optimisation
m[:emissions,:MIU] = 0.5*ones(60,12)
