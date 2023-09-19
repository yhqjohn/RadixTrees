using Test, RadixTrees, SafeTestsets

@safetestset "radix creation and insertion test" begin
    include("radix_creation_insertion_test.jl")
end

@safetestset "radix access test" begin
    include("radix_access_test.jl")
end

@safetestset "radix set creation test" begin
    include("radix_set_creation_test.jl")
end