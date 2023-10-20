module rest

import net.http

interface IHttpClient {
	do(req http.Request) !http.Response
}

struct HttpClient {}

fn (c HttpClient) do(req http.Request) !http.Response {
	return req.do()!
}

struct MockHttpClient {
	expected_request http.Request
	returns          http.Response
}

fn (c MockHttpClient) do(req http.Request) !http.Response {
	assert c.expected_request.method == req.method
	assert c.expected_request.url == req.url
	assert c.expected_request.data == req.data
	assert c.expected_request.header == req.header

	return c.returns
}
