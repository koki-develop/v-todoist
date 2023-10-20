module rest

import json

struct User {
	id    string [json: 'id']
	name  string [json: 'name']
	email string [json: 'email']
}

pub fn (c Client) get_collaborators(project_id string) ![]User {
	req := c.new_request(.get, '/v2/projects/${project_id}/collaborators', '')
	resp := req.do()!
	if resp.status() != .ok {
		return error(resp.body)
	}

	users := json.decode([]User, resp.body)!
	return users
}
