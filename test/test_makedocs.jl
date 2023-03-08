using QuantumCitations
using Documenter
using Test


@testset "Integration Test" begin

    # we build the complete documentation of QuantumCitations in a test
    # environment

    bib = CitationBibliography(
        joinpath(@__DIR__, "..", "docs", "src", "refs.bib"),
        sorting=:nyt
    )
    mktempdir() do tmpdir
        root = joinpath(@__DIR__, "..", "docs")
        # We're basically doing `makedocs`, but written out for debuggability
        empty!(Documenter.Selectors.selector_subtypes)
        format = Documenter.Writers.HTMLWriter.HTML(; edit_link=nothing, disable_git=true)
        plugins = [bib]
        document = Documenter.Documents.Document(
            plugins;
            format,
            strict=false,
            sitename="QuantumCitations.jl",
            root,
            build=tmpdir
        )
        cd(document.user.root) do
            Documenter.Selectors.dispatch(Documenter.Builder.DocumentPipeline, document)
        end
        html = read(joinpath(tmpdir, "references", "index.html"), String)
        ∈ₛ(needle, haystack) = occursin(needle, haystack)
        @test "Quantum Optimal Control" ∈ₛ html
    end
    @test bib.citations["GoerzQ2022"] == 2

end
