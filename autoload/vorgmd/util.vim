function! vorgmd#util#parseLinesAround(lnum, fun_start, fun_condition, fun_parse)
	let start_data = a:fun_start(a:lnum)
	let data = []
	for direction in [1, -1]
		let curline = a:lnum + direction
		while a:fun_condition(start_data, curline)
				call add(data, [curline, a:fun_parse(start_data, curline)])
				let curline += direction
		endwhile
	endfor
	return data
endfunction

function! vorgmd#util#export(data, format)
	let rown = 0
	let has_header = 0

	while rown < len(a:data)

		let coln = 0
		let alignment_row = 1
		while coln < len(a:data[rown])
			if a:data[rown][coln] == '--'
				let a:data[rown][coln] = ''
			else
				let alignment_row = 0
			endif
			let coln += 1
		endwhile

		if alignment_row
			if rown == 1
				let has_header = 1
			endif

			call remove(a:data, rown)
		else
			let rown += 1
		endif
	endwhile

	let Exporter = vorgmd#exporters#getExporter(a:format)
	let exported = Exporter(a:data, has_header)

	enew
	call append(0, exported)
endfunction

function! vorgmd#util#trim(string)
	return substitute(a:string, '^\s\+\|\s\+$', "", "g")
endfunction

