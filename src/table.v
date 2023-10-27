module main

import arrays
import rest
import math

struct Table {
	columns []string
	rows    [][]string
}

fn projects_table(columns []string, projects []rest.Project) !Table {
	return Table{
		columns: columns
		rows: projects.map(project_row(columns, it))
	}
}

fn project_row(columns []string, project rest.Project) []string {
	return columns.map(match it {
		'id' { project.id }
		'name' { project.name }
		'color' { project.color }
		'parent_id' { project.parent_id or { '' } }
		'order' { project.order.str() }
		'comment_count' { project.comment_count.str() }
		'is_shared' { project.is_shared.str() }
		'is_favorite' { project.is_favorite.str() }
		'is_inbox_project' { project.is_inbox_project.str() }
		'is_team_inbox' { project.is_team_inbox.str() }
		'view_style' { project.view_style.str() }
		'url' { project.url }
		else { '' }
	})
}

fn (t Table) print() {
	mut widthes := []int{len: t.columns.len, init: 0}

	for row in arrays.concat(t.rows, t.columns) {
		for i, column in row {
			length := column.len_utf8()
			if length > widthes[i] {
				widthes[i] = length
			}
		}
	}

	for i, column in t.columns {
		if i > 0 {
			print(' ')
		}

		print(column.to_upper())
		print(' '.repeat(math.max(widthes[i] - column.len_utf8(), 0)))
	}

	print('\n')

	for row in t.rows {
		for i, column in row {
			if i > 0 {
				print(' ')
			}

			print(column)
			print(' '.repeat(math.max(widthes[i] - column.len_utf8(), 0)))
		}

		print('\n')
	}
	flush_stdout()
}
