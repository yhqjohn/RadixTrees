using Test, RadixTrees, SafeTestsets

@safetestset "radix creation and insertion test" begin
    include("radix_creation_insertion_test.jl")
end

@safetestset "radix access test" begin
    include("radix_access_test.jl")
end