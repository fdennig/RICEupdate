using Mimi

# Load RICE+AIR source code.
include("src/mRICE2010.jl")

m = get_model()
run(m)

explore(m)
