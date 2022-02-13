function! s:isTable(lnum)
	return getline(a:lnum) =~ '^\s*|.*|\s*$'
endfunction

function! s:cleanColumn(column)
	let col = vorgmd#util#trim(a:column)
	let col = substitute(l:col, '^\s\+$', "", "g")
	let col = substitute(l:col, '^--\+$', "--", "g")
	return l:col
endfunction

function! s:getCellLocations(lnum)
	let cells = split(getline(a:lnum), '|', 1)
	let current = strlen(cells[0]) + 1
	let cell_positions = []
	for cell in cells[1:-2]
		let len = strlen(cell)
		call add(cell_positions, [current, current + len])
		let current += len + 1
	endfor
	return cell_positions
endfunction

function! s:tableCondition(data, lnum)
	return a:data.level == indent(a:lnum) && s:isTable(a:lnum)
endfunction

function! s:tableParse(data, lnum)
	let line = substitute(getline(a:lnum), '^\s*|\||\s*$', "", "g")
	let columns = map(split(line, '|', 1), {
		\i, val -> s:cleanColumn(val)
	\})

	let data = {"level": indent(a:lnum), "cols": columns}
	return data
endfunction

function! s:tableAlign(step, column, coln, max_widths)
	let length = strchars(a:column)
	if a:step ==# "count"
		if len(a:max_widths) < a:coln + 1
			call add(a:max_widths, length)
		elseif a:max_widths[a:coln] < length
			let a:max_widths[a:coln] = length
		endif
	elseif a:step ==# "align"
		let rchar = " "
		if a:column =~ '^--\+$'
			let rchar = '-'
		endif
		return rchar . a:column . repeat(rchar, a:max_widths[a:coln] - length + 1)
	endif
	return 0
endfunction

function! s:tableAlignLoop(table)
	let max_widths = []
	for step in ["count", "align"]
		let rown = 0
		for row in a:table
			let coln = 0
			for column in row[1].cols
				let ret = s:tableAlign(step, column, coln, max_widths)
				if step ==# "align"
					let a:table[rown][1].cols[coln] = ret
				endif
				let coln += 1
			endfor
			let rown += 1
		endfor
	endfor
endfunction

function! s:tableSetRow(lnum, data)
	call setline(a:lnum, repeat(" ", a:data.level) .
		\"|" . join(a:data.cols, "|") . "|"
	\)
endfunction

function! s:getTable(lnum)
	let row_data = s:tableParse({}, a:lnum)
	let table = vorgmd#util#parseLinesAround(a:lnum, {a -> row_data}, function("s:tableCondition"), function("s:tableParse"))
	call add(table, [a:lnum, row_data])
	return table
endfunction

function! vorgmd#table#align()
	let line = line(".")
	if s:isTable(line)
		let table = s:getTable(line)
		call s:tableAlignLoop(table)
		for row in table
			call s:tableSetRow(row[0], row[1])
		endfor
	endif
endfunction

function! vorgmd#table#jumpCell(direction)
	let line = line(".")

	if s:isTable(line)
		let column = col(".")
		let cells = s:getCellLocations(line)
		let cur_col = -1

		for [cell_s, cell_e] in cells
			if column >= cell_s && cur_col == -1
				let cur_col = 0
			endif
			if column <= cell_e
				break
			endif
			let cur_col += 1
		endfor
		let cur_col += a:direction

		if cur_col >= len(cells) || cur_col < 0
			let line += a:direction
			if s:isTable(line)
				let cur_col = (-1 + a:direction) / 2
				let cells = s:getCellLocations(line)
			else
				return
			endif
		endif

		call cursor(line, cells[cur_col][0] + 2)
	endif
endfunction

function! vorgmd#table#export(format)
	let line = line(".")

	if s:isTable(line)
		" sort by row number
		let table = sort(s:getTable(line), {
			\i1, i2 -> i1[0] - i2[0]
		\})

		" map for column values only
		let table = map(table, {
			\i, val -> val[1].cols
		\})

		" export
		try
			call vorgmd#util#export(table, a:format)
			let &filetype = a:format
		catch /^no exporter/
			echoe v:exception
		endtry
	endif
endfunction

