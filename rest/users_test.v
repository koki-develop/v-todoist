module rest

import net.http

fn test_client_get_collaborators() ! {
	project_id := '1'

	mut client := new('TOKEN')
	client.http_client = MockHttpClient{
		expected_request: http.Request{
			url: 'https://api.todoist.com/rest/v2/projects/${project_id}/collaborators'
			method: .get
			data: ''
			header: http.new_header(http.HeaderConfig{
				key: .authorization
				value: 'Bearer TOKEN'
			})
		}
		returns: http.Response{
			status_code: int(http.Status.ok)
			body: '[{ "id": "1" }, { "id": "2" }]'
		}
	}

	users := client.get_collaborators(project_id)!
	assert users == [
		User{
			id: '1'
		},
		User{
			id: '2'
		},
	]
}
