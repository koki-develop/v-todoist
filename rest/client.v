module rest

pub struct Client {
pub mut:
	token string [required]
}

pub fn new(token string) Client {
	return Client{
		token: token
	}
}
