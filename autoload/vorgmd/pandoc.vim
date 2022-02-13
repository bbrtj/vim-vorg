function! vorgmd#pandoc#export(format) range
	let lines = getline(a:firstline, a:lastline)
	let output = systemlist('pandoc -f markdown -t ' . a:format, lines)

	if v:shell_error
		echoe 'pandoc failed with ' . v:shell_error
	else
		enew
		call append(0, output)
	endif
endfunction

