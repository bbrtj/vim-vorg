function! vorgmd#dates#nextWeekdayTimestamp(nDays)
	let dir  = a:nDays < 0 ? -1 : 1
	let day  = abs(a:nDays) % 7
	let sday = 60 * 60 * 24 * dir
	let time = localtime() + sday
	while strftime('%w', time) != day
		let time += sday
	endwhile
	return time
endfunction

function! vorgmd#dates#nextWeekday(nDays)
	return strftime('%Y-%m-%d', vorgmd#dates#nextWeekdayTimestamp(a:nDays))
endfunction

function! vorgmd#dates#today()
	return strftime('%Y-%m-%d', localtime())
endfunction

function! vorgmd#dates#normalize(date, ...)
	let date = split(a:date, "-")
	if strlen(date[2]) == 4
		let [date[0], date[2]] = [date[2], date[0]]
	endif
	return join(date, a:0 > 0 ? a:1 : "-")
endfunction

function! vorgmd#dates#compare(d1, d2)
	let dates = []
	for date in [a:d1, a:d2]
		call add(dates, vorgmd#dates#normalize(date, ""))
	endfor
	return dates[0] - dates[1]
endfunction

function! vorgmd#dates#commonName(date)
	let date_dist = vorgmd#dates#compare(a:date, vorgmd#dates#today())

	let date = a:date
	if date_dist == -1
		let date = "Yesterday"
	elseif date_dist == 0
		let date = "Today"
	elseif date_dist == 1
		let date = "Tomorrow"
	elseif date_dist > 0 && date_dist < 7
		let oldlang = v:lc_time
		language time en_US.UTF-8
		let date = substitute(strftime("%A", vorgmd#dates#nextWeekdayTimestamp(date_dist)), '\<.', '\u&', "")
		execute 'language time ' . oldlang
	endif

	return date
endfunction

