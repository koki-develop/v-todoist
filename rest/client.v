module rest

import net.http

const (
	base_url = 'https://api.todoist.com/rest'
)

pub struct Client {
pub mut:
	token string [required]
mut:
	http_client IHttpClient // for testing
}

// new returns a new Client with the given token.
pub fn new(token string) Client {
	return Client{
		token: token
		http_client: HttpClient{}
	}
}

fn (c Client) new_request(method http.Method, pathname string, data string) http.Request {
	url := rest.base_url + pathname
	mut req := http.Request{
		method: method
		url: url
		data: data
	}
	req.add_header(.authorization, 'Bearer ${c.token}')

	match method {
		.post {
			req.add_header(.content_type, 'application/json')
		}
		else {}
	}

	return req
}
