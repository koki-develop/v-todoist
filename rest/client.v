module rest

import net.http

const (
	base_url = 'https://api.todoist.com/rest'
)

pub struct Client {
pub mut:
	token string [required]
}

pub fn new(token string) Client {
	return Client{
		token: token
	}
}

fn (c Client) new_request(method http.Method, pathname string, data string) http.Request {
	url := rest.base_url + pathname
	mut req := http.new_request(method, url, data)
	req.add_header(.authorization, 'Bearer ${c.token}')

	match method {
		.post {
			req.add_header(.content_type, 'application/json')
		}
		else {}
	}

	return req
}
