######################################################################################################################
# This file runs (and optimises) RICE in its Mimi implementation. 
# The only difference to Excel is that the damage deflator is now 1/(1+D)
# Some changes in allocation of variables and parameters across components have been implemented relative to MimiRICE2010
##############################################################################################################

# Load required Julia packages.
using NLopt # for optimisation

# Load RICE+AIR source code.
include("src/mRICE2010.jl")

# this is how you initiate an instance m of the model
m = get_rice() #default if get_rice(objective = "Neutral") set objective = "Negishi" for that objective
# then you run the model
run(m)

# say you want to change some parameter
#like the discount rate
m[:welfare,:rho] = 1.5
#or the mitigation fraction, this is how we input the control variable in the optimisation
m[:emissions,:MIU] = 0.5*ones(60,12)

# the way the optimisation works is that we construc the model, and set a bunch of user defined paramaters, and from that construct the objective

mod = get_rice()

# number of periods of control
t_choice = 29
# Maximum time in seconds to run local optimization (in case optimization does not converge).
local_stop_time = 500
# Relative tolerance criteria for global optimization convergence (will stop if |Δf| / |f| < tolerance from one iteration to the next.)
local_tolerance = 1e-12
objective = construct_RICE_objective(m,t_choice)
constraint = retConstraint(m,t_choice)
# set up optimisation# Create an NLopt optimization object.
opt_object = Opt(:LN_SBPLX, t_choice*12)
# set up constraint

# bounds on the control variable
lower_bounds!(opt_object, zeros(12*t_choice))
upper_bounds!(opt_object, ones(12*t_choice))
# Set maximum run time.
maxtime!(opt_object, local_stop_time)
# Set convergence tolerance.
ftol_rel!(opt_object, local_tolerance)
# Set objective function.
max_objective!(opt_object, (x, grad) -> objective(x))
inequality_constraint!(ot_object, (x, grad) -> constraint(x)-0.5)
max_welfare, optimal_rates, convergence_flag = optimize(opt_object, 0.5*ones(12*t_choice))