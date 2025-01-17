module FerriteMeshParser
using Ferrite
# Convenience when debugging
const DEBUG_PARSE = false

# Mesh formats
struct AutomaticMeshFormat end
struct AbaqusMeshFormat end

# Exceptions
struct UndetectableMeshFormatError <: Exception
    filename::String
end
Base.showerror(io::IO, e::UndetectableMeshFormatError) = println(io, "Couldn't automatically detect mesh format in $(e.filename)")

struct UnsupportedElementType <: Exception
    elementtype::String
end
Base.showerror(io::IO, e::UnsupportedElementType) = println(io, "The element type \"$(e.elementtype)\" is not supported or given in user_elements")

struct InvalidFileContent <: Exception
    msg::String
end
Base.showerror(io::IO, e::InvalidFileContent) = println(io, e.msg)

include("rawmesh.jl")
include("elements.jl")
include("reading_utils.jl") 
include("abaqusreader.jl")
include("gridcreator.jl")

"""
    function get_ferrite_grid(
        filename; 
        meshformat=AutomaticMeshFormat(), 
        user_elements=Dict{String,DataType}(), 
        generate_facesets=true
        )

Create a `Ferrite.Grid` by reading in the file specified by `filename`.

Optional arguments:
* `meshformat`: Which format the mesh 
    is given in, normally automatically detected by the file extension
* `user_elements`: Used to add extra elements not supported,
    might require a separate cell constructor.
* `generate_facesets`: Should facesets be automatically generated from all nodesets?

"""
function get_ferrite_grid(filename; meshformat=AutomaticMeshFormat(), user_elements::Dict{String,DataType}=Dict{String,DataType}(), generate_facesets::Bool=true)
    detected_format = detect_mesh_format(filename, meshformat)
    mesh = read_mesh(filename, detected_format)
    checkmesh(mesh)
    grid = create_grid(mesh, detected_format, user_elements)
    generate_facesets && generate_facesets!(grid)
    return grid
end

"""
    create_faceset(
        grid::Ferrite.AbstractGrid, 
        nodeset::Set{Int}, 
        cellset::Union{UnitRange{Int},Set{Int}}=1:getncells(grid)
        )

Find the faces in the grid for which all nodes are in `nodeset`. Return them as a `Set{FaceIndex}`.
A `cellset` can be given to only look only for faces amongst those cells to speed up the computation. 
Otherwise the search is over all cells.

This function is normally only required when calling `get_ferrite_grid` with `generate_facesets=false`. 
The created `faceset` can be added to the grid as `addfaceset!(grid, "facesetkey", faceset)`
"""
function create_faceset(grid::Ferrite.AbstractGrid, nodeset::Set{Int}, cellset=1:getncells(grid))
    faceset = sizehint!(Set{FaceIndex}(), length(nodeset))
    for (cellid, cell) in enumerate(getcells(grid))
        cellid ∈ cellset || continue
        if any(n-> n ∈ nodeset, cell.nodes)
            for (faceid, face) in enumerate(Ferrite.faces(cell))
                if all(n -> n ∈ nodeset, face)
                    push!(faceset, FaceIndex(cellid, faceid))
                end
            end
        end
    end
    return faceset
end

detect_mesh_format(_, meshformat) = meshformat
function detect_mesh_format(filename, ::AutomaticMeshFormat)
    if endswith(filename, ".inp")
        return AbaqusMeshFormat()
    else
        throw(UndetectableMeshFormatError(filename))
    end
end

export get_ferrite_grid, create_faceset

end