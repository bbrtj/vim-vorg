if exists('g:loaded_vorgmd')
	finish
endif

command VorgmdTableExport :call vorgmd#table#export(input("Export format: "))
command -range=% VorgmdPandocExport <line1>,<line2>call vorgmd#pandoc#export(input("Export format: "))

augroup vorgmd_tables
	autocmd!
	autocmd InsertLeave *.md call vorgmd#table#align()
augroup END

let g:loaded_vorgmd = 1

