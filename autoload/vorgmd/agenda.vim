let s:scheduled_match = '\(\s\|^\)\@<=[~]\d*[/-]\d*[/-]\d*\( @ \d*:\d*\)\?\(\s\|$\)\@='

function! s:showAgendaWindow()
	vertical rightbelow new

	vertical resize 50
	setlocal filetype=markdown buftype=nofile nobuflisted bufhidden=wipe

	map <buffer> <silent> q :q<CR>
	map <buffer> <silent> o :call vorgmd#agenda#jump()<CR>
	unmap <buffer> ??
endfunction

function! s:entangleWindows()
	let from = [win_getid(winnr()), bufnr("%")]
	let agenda = []
	let b:agenda = agenda
	let changedtick = b:changedtick
	call s:showAgendaWindow()
	let b:from = from
	let agenda += [win_getid(winnr()), bufnr("%")]
	let b:from_changedtick = changedtick
	autocmd BufEnter <buffer> call vorgmd#agenda#reload()
	execute "autocmd BufUnload,BufDelete,BufWipeout <buffer=" . from[1] . "> call vorgmd#agenda#close([" . join(agenda, ",") . "])"
endfunction

function! s:makePrintableStructure(data)
	let dates = {}

	for [lnum, text, date] in a:data
		let text = vorgmd#util#trim(text)
		let date = date[1:]

		let date_time = split(date, ' @ ')
		if len(date_time) > 1
			let date = date_time[0]
			let text = date_time[1] . " - " . text
		endif

		let date = vorgmd#dates#normalize(date)
		let dict_item = get(dates, date, [])
		call add(dict_item, [lnum, text])
		let dates[date] = dict_item
	endfor

	let dates = map(dates, {
		\i, val -> sort(val)
	\})

	return sort(items(dates), {
		\d1, d2 -> vorgmd#dates#compare(d1[0], d2[0])
	\})
endfunction

function! s:fillAgendaWindow(data)
	let view = winsaveview()
	setlocal modifiable
	execute "1," . line('$') . "delete _"
	let b:meta = {}
	let line = 1

	let fopen = []
	for [date, texts] in s:makePrintableStructure(a:data)
		let date = vorgmd#dates#commonName(date)

		if date =~? '^[a-zA-Z\u0100-\uFFFF]\+$' && date !=? "yesterday"
			call add(fopen, line)
			let this_week = 1
		endif

		call setline(line, "# " . date)
		let texts_copy = copy(texts)
		call append(line, map(texts_copy, {i, val -> "- " . val[1]}))

		let line += 1
		for [lnum, text] in texts
			let b:meta[line] = lnum
			let line += 1
		endfor

		call setline(line, '')
		let line += 1
	endfor

	setlocal nomodifiable
	call winrestview(view)
endfunction

function! s:gatherFromLine(line, lnum, items)
	let match = matchstr(a:line, s:scheduled_match)
	if strlen(match) > 0
		let line = substitute(a:line, s:scheduled_match, "", "")
		call add(a:items, [a:lnum, line, match])
	endif
endfunction

function! s:gather(buf)
	let items = []
	let lnum = 1
	for line in getbufline(a:buf, 1, '$')
		call s:gatherFromLine(line, lnum, items)
		let lnum += 1
	endfor
	return items
endfunction

function! s:focusBuffer(from)
	if !bufexists(a:from[1])
		return 0
	endif

	if !win_gotoid(a:from[0])
		return 0
	endif

	if bufnr("%") != a:from[1]
		execute "buffer " . a:from[1]
	endif
	return 1
endfunction

function! vorgmd#agenda#show()
	if &filetype !=? "markdown"
		echoe "Agenda is only available for markdown files"
		return
	endif

	if !exists("b:agenda") || !s:focusBuffer(copy(b:agenda))
		call s:entangleWindows()
		let items = s:gather(b:from[1])
		call s:fillAgendaWindow(items)
	endif
endfunction

function! vorgmd#agenda#close(bufdata)
	if s:focusBuffer(a:bufdata)
		q
	endif
endfunction

function! vorgmd#agenda#reload()
	if !exists("b:from")
		return
	endif

	let parent_info = getbufinfo(b:from[1])
	let changedtick = parent_info[0].changedtick
	if changedtick > b:from_changedtick
		let items = s:gather(b:from[1])
		call s:fillAgendaWindow(items)
		let b:from_changedtick = changedtick
	endif
endfunction

function! vorgmd#agenda#jump()
	let lnum = line(".")
	if exists("b:from")
		let vorg_lnum = get(b:meta, lnum, 0)

		if vorg_lnum > 0
			if s:focusBuffer(copy(b:from))
				call setpos(".", [0, vorg_lnum, 0])
				let fl = foldlevel(vorg_lnum)
				while fl > 0
					foldo
					let fl -= 1
				endwhile
			else
				echoe "Cannot find entangled window"
			endif
		endif
	endif
endfunction

