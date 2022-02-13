# vorg-md
Markdown-compilant plain text organizer for vim / neovim.

## What it brings to the table?

vorg-md is a collection of vimscript tools that make using markdown as your personal organizer easy and fun.

_Looking for the old vorg? Check out the 1.0 branch._

### Checkboxes
Use `-[`, `+[` or `*[` abbreviation to create a bullet point with unchecked checkbox `[ ]`
Checkboxes can be toggled with `cx` normal mode mapping, both individually and in groups (visual mode or range).

A section caption text which ends with colon `:` and contains checkboxes will be folded and show the number of tasks completed and total tasks, for example [ 1 / 2 done ]

```
# Section:
  - [ ] First Priority Task
  - [x] Second Priority Task
```

### Tables
Any line that starts and ends with a pipe symbol `|` will be treated as a table row.
Tables feature automated aligning, cell text objects, cell navigation and exporting.
Tables can also be exported with `:call VorgmdTableExport` into csv, json or html.

_Note about exporting: if the second row consists of all columns being fully separators (filled with -) then json will be exported as an array of objects, and html will be exported with first row having \<th\> instead of \<td\>. No such separator rows are ever exported_

```
| Person | Phone       | Email          |
|--------|-------------|----------------|
| Frank  | 123 456 789 | frank@mail.com |
| Rob    | 555 556 557 | rob@mail.com   |
```

### Dates
Abbreviations are in place that make inserting dates fun:
- `dd` inserts today's date
- `dt` inserts today's datetime
- `dnX` will insert the date of the next day of the week X. `dn1` will insert next monday, while `dn6` will insert next saturday
- `dpX` does the same as `dnX`, but into the past.

vorg-md plugin uses dates in format: `YYYY-MM-DD HH:II`. Time part is optional
The plugin will try to normalize the date and the time part, but it's best to keep this convention.

### Agenda
vorg-md allows you to show an additional window that summarizes the dates in your file. Use `??` normal mode mapping to show the agenda window.
When inside the window, use `o` or `Enter` to jump to line containing the scheduled item. Use `q` to close the window.
Only dates which start or end the line will be taken into account in the agenda window.

Cheatsheet
---------

### insert mode abbreviations
- `-[` begin a new task with `-` bullet point
- `*[` begin a new task with `*` bullet point
- `-[` begin a new task with `+` bullet point
- `dd` add the current date
- `dt` add the current datetime
- `dn1 to dn7` add the date of the next closest weekday (monday to sunday)
- `dp1 to dp7` add the date of the previous closest weekday (monday to sunday)

### normal mode
- `cx` toggle a task checkbox (works with count)
- `=` force table alignment
- `Tab` jump to next table cell
- `Shift-Tab` jump to previous table cell
- `??` show agenda

### visual mode
- `cx` toggle all checkboxes in lines

### text objects
- `ic` inner table cell
- `ac` outer table cell

### agenda window
- `o` jump to line
- `q` close the window

Commands
--------
These commands are not bound to a specific keymap

- `VorgmdTableExport` - exports a table under cursor to a prompted format. Currently supported formats are csv, html and json. A new buffer is opened with the export result
- `VorgmdPandocExport` - exports the file using `pandoc` into the prompted format. If used in visual mode, exports that part of the file instead. A new buffer is opened with the export result

Vim requirements
----------------

Works under Vim (version 8+) and Neovim.

Authors
---------------
Developed by Bartosz Jarzyna <https://github.com/bbrtj>, licensed under BSD 2-clause.
The initial vorg plugin idea by Ithai Levi <https://github.com/rlofc>

