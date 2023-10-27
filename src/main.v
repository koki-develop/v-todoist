module main

import cli
import os
import rest

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
						flags: [
							cli.Flag{
								name: 'columns'
								flag: .string
								default_value: [['id', 'name'].join(',')]
							},
						]
						execute: fn [client] (command cli.Command) ! {
							columns := command.flags.get_string('columns')!
							projects := client.get_projects()!
							table := projects_table(columns.split(','), projects)!
							table.print()
						}
					},
					cli.Command{
						name: 'get'
						flags: [
							cli.Flag{
								name: 'columns'
								flag: .string
								default_value: [['id', 'name'].join(',')]
							},
						]
						required_args: 1
						execute: fn [client] (command cli.Command) ! {
							columns := command.flags.get_string('columns')!
							project := client.get_project(command.args[0])!
							table := projects_table(columns.split(','), [
								project,
							])!
							table.print()
						}
					},
				]
			},
		]
	}

	app.setup()
	app.parse(os.args)
}
