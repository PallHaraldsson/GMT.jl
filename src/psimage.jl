"""
    image(cmd0::String="", arg1=nothing; kwargs...)

Place images or EPS files on maps.

Full option list at [`psimage`]($(GMTdoc)image.html)

Parameters
----------

- $(GMT.opt_B)
- **D** | **pos** | **position** :: [Type => Str]

    Sets reference point on the map for the image using one of four coordinate systems.
    ($(GMTdoc)image.html#d)
- **F** | **box** :: [Type => Str | []]

    Without further options, draws a rectangular border around the image using MAP_FRAME_PEN.
    ($(GMTdoc)image.html#f)
- **I** | **invert_1bit** :: [Type => Str | Number]

    Invert 1-bit image before plotting.
    ($(GMTdoc)image.html#i)
- $(GMT.opt_J)
- $(GMT.opt_Jz)
- **M** | **monochrome** :: [Type => Bool]

    Convert color image to monochrome grayshades using the (television) YIQ-transformation.
    ($(GMTdoc)image.html#m)
- $(GMT.opt_R)
- $(GMT.opt_U)
- $(GMT.opt_V)
- $(GMT.opt_X)
- $(GMT.opt_Y)
- $(GMT.opt_p)
- $(GMT.opt_t)
"""
function image(cmd0::String="", arg1=nothing; first=true, kwargs...)

	gmt_proggy = (IamModern[1]) ? "image "  : "psimage "
	length(kwargs) == 0 && return monolitic(gmt_proggy, cmd0, arg1)

	d = KW(kwargs)
	help_show_options(d)		# Check if user wants ONLY the HELP mode
	K, O = set_KO(first)		# Set the K O dance

	cmd, opt_B, opt_J, opt_R = parse_BJR(d, "", "", O, " -JX12c/12c")
	cmd, = parse_common_opts(d, cmd, [:F :UVXY :JZ :c :p :t :params], first)
	cmd  = parse_these_opts(cmd, d,  [[:G :bit_color], [:I :invert_1bit], [:M :monochrome]])
	#cmd  = parse_type_anchor(d, cmd, [[:D :ref_point]])
	cmd = parse_type_anchor(d, cmd, [:D :pos :position],
	                        (map=("g", nothing, 1), inside=("j", nothing, 1), paper=("x", nothing, 1), anchor=("", arg2str, 2), dpi="+r", width=("+w", arg2str), justify="+j", replicate=("+n", arg2str), offset=("+o", arg2str)), 'j')

	cmd, got_fname, arg1 = find_data(d, cmd0, cmd, arg1)		# Find how data was transmitted

	return finish_PS_module(d, gmt_proggy * cmd, "", K, O, true, arg1)
end

# ---------------------------------------------------------------------------------------------------
image!(cmd0::String="", arg1=nothing; kw...) = image(cmd0, arg1; first=false, kw...)

# ---------------------------------------------------------------------------------------------------
const psimage  = image			# Alias
const psimage! = image!			# Alias