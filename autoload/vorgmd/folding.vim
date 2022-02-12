let s:markdown_point_match = "^\\s*[*+-]"

function! vorgmd#folding#foldText()
	let foldlines = getline(v:foldstart, v:foldend)
	let header = substitute(foldlines[0], ":$", '', '')
	let text = repeat(' ', indent(v:foldstart)) . header

	let total_boxes = 0
	let total_checked = 0
	for line in foldlines
		if line =~? "\\[ \\]"
			let total_boxes += 1
		elseif line =~? "\\[[xX]\\]"
			let total_boxes += 1
			let total_checked += 1
		endif
	endfor
	if total_boxes > 0
		let text .= " [ " . total_checked . " / " . total_boxes . " done ]"
	endif
	return text . ' '
endfunction

function! vorgmd#folding#foldExpr(lnum)
	let line = getline(a:lnum)

	# empty line - no folding
	if line =~ "^\\s*$"
		return 0
	endif

	if line =~ ":$"
		let curline = a:lnum + 1
		while curline <= line('$')
			let next_line = getline(curline)

			if next_line !~? s:markdown_point_match
				return 0
			endif

			if next_line =~? s:markdown_point_match . " \\[[ x]\\]"
				return 1
			endif

			let curline = curline + 1
		endwhile

		return 0
	endif

	if line =~? s:markdown_point_match
		return '='
	endif

	return 0
endfunction

