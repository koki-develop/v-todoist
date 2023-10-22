module rest

import net.http

fn test_client_get_sections_with_params() ! {
	mut client := new('TOKEN')
	client.http_client = MockHttpClient{
		expected_request: http.Request{
			url: 'https://api.todoist.com/rest/v2/sections?project_id=1'
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

	sections := client.get_sections(project_id: '1')!
	assert sections == [
		Section{
			id: '1'
		},
		Section{
			id: '2'
		},
	]
}

fn test_client_get_sections_without_params() ! {
	mut client := new('TOKEN')
	client.http_client = MockHttpClient{
		expected_request: http.Request{
			url: 'https://api.todoist.com/rest/v2/sections'
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

	sections := client.get_sections()!
	assert sections == [
		Section{
			id: '1'
		},
		Section{
			id: '2'
		},
	]
}
