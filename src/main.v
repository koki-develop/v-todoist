module main

import cli
import math
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
		print(' '.repeat(math.max(widthes[i] - column.len_utf8(), 0)))
	}

	print('\n')

	for row in rows {
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
					cli.Command{
						name: 'get'
						required_args: 1
						execute: fn [client] (command cli.Command) ! {
							project := client.get_project(command.args[0])!
							print_table(['ID', 'NAME'], [[project.id, project.name]])
						}
					},
				]
			},
		]
	}

	app.setup()
	app.parse(os.args)
}
