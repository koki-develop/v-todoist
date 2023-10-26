module main

import cli
import os
import rest

fn print_table(columns []string, rows [][]string) {
	mut widthes := []int{len: columns.len, init: 0}

	for row in rows {
		for i, column in row {
			length := column.len_utf8()
			if length > widthes[i] {
				widthes[i] = length
			}
		}
	}

	for i, column in columns {
		if i > 0 {
			print(' ')
		}

		print(column)
		print(' '.repeat(widthes[i] - column.len_utf8()))
	}

	print('\n')

	for row in rows {
		for i, column in row {
			if i > 0 {
				print(' ')
			}

			print(column)
			print(' '.repeat(widthes[i] - column.len_utf8()))
		}

		print('\n')
	}
	flush_stdout()
}

fn main() {
	client := rest.new(os.getenv('TODOIST_API_TOKEN'))

	mut app := cli.Command{
		name: 'todoist'
		commands: [
			cli.Command{
				name: 'projects'
				commands: [
					cli.Command{
						name: 'list'
						execute: fn [client] (_ cli.Command) ! {
							projects := client.get_projects()!
							print_table(['ID', 'NAME'], projects.map([it.id, it.name]))
						}
					},
				]
			},
		]
	}

	app.setup()
	app.parse(os.args)
}
