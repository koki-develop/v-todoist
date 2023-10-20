module rest

fn test_new() {
	client := new('TOKEN')

	assert client.token == 'TOKEN'
	assert client.http_client is HttpClient
}
