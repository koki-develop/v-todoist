module rest

import net.http

fn test_client_get_projects() ! {
	mut client := new('TOKEN')
	client.http_client = MockHttpClient{
		expected_request: http.Request{
			url: 'https://api.todoist.com/rest/v2/projects'
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

	projects := client.get_projects()!
	assert projects == [
		Project{
			id: '1'
		},
		Project{
			id: '2'
		},
	]
}
