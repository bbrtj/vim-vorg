function! s:export_json(data, header)
	if a:header
		let newdata = []
		let header = a:data[0]

		for row in a:data[1:]
			let row_dict = {}
			let index = 0
			for column in row
				let row_dict[header[index]] = column
				let index += 1
			endfor
			call add(newdata, row_dict)
		endfor

		return json_encode(newdata)
	else
		return json_encode(a:data)
	endif
endfunction

function! s:export_csv(data, header)
	let lines = []
	for row in a:data
		let row = map(row, {
			\i, val -> substitute(val, '"', '\\"', "g")
		\})
		call add(lines, '"' . join(row, '","') . '"')
	endfor
	return lines
endfunction

function! s:export_html(data, header)
	let lines = ["<table>"]
	let ind = &g:et ? repeat(" ", &g:sw) : "\t"
	let is_header = a:header

	for row in a:data
		call add(lines, ind . "<tr>")
		for column in row
			if is_header
				call add(lines, ind . ind . "<th>" . column . "</th>")
			else
				call add(lines, ind . ind . "<td>" . column . "</td>")
			endif
		endfor
		call add(lines, ind . "</tr>")

		let is_header = 0
	endfor

	call add(lines, "</table>")
	return lines
endfunction

function! vorgmd#exporters#getExporter(format)
	let fname = "s:export_" . tolower(a:format)
	if !exists("*" . fname)
		throw "no exporter for format " . a:format
	endif
	let Func = function(fname)
	return Func
endfunction

