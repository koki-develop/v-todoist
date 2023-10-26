module rest

import json

pub enum ProjectViewStyle {
	list
	board
}

pub struct Project {
pub:
	id               string           [json: 'id']
	name             string           [json: 'name']
	color            string           [json: 'color']
	parent_id        ?string          [json: 'parent_id']
	order            int              [json: 'order']
	comment_count    int              [json: 'comment_count']
	is_shared        bool             [json: 'is_shared']
	is_favorite      bool             [json: 'is_favorite']
	is_inbox_project bool             [json: 'is_inbox_project']
	is_team_inbox    bool             [json: 'is_team_inbox']
	view_style       ProjectViewStyle [json: 'view_style']
	url              string           [json: 'url']
}

// get_projects returns all user projects.
// See https://developer.todoist.com/rest/v2/#get-all-projects for details.
pub fn (c Client) get_projects() ![]Project {
	req := c.new_request(.get, '/v2/projects', '')
	resp := c.http_client.do(req)!
	if resp.status() != .ok {
		return error(resp.body)
	}

	projects := json.decode([]Project, resp.body)!
	return projects
}

// get_project returns the project related to the given id.
// See https://developer.todoist.com/rest/v2/#get-a-project for details.
pub fn (c Client) get_project(id string) !Project {
	req := c.new_request(.get, '/v2/projects/${id}', '')
	resp := c.http_client.do(req)!
	if resp.status() != .ok {
		return error(resp.body)
	}

	project := json.decode(Project, resp.body)!
	return project
}

[params]
pub struct CreateProjectParams {
	name        string            [json: 'name'; required]
	parent_id   ?string           [json: 'parentId']
	color       ?string           [json: 'color']
	is_favorite ?bool             [json: 'is_favorite']
	view_style  ?ProjectViewStyle [json: 'view_style']
}

// create_project creates a new project and return it.
// See https://developer.todoist.com/rest/v2/#create-a-new-project for details.
pub fn (c Client) create_project(params CreateProjectParams) !Project {
	req := c.new_request(.post, '/v2/projects', json.encode(params))
	resp := c.http_client.do(req)!
	if resp.status() != .ok {
		return error(resp.body)
	}

	project := json.decode(Project, resp.body)!
	return project
}

[params]
pub struct UpdateProjectParams {
	name        ?string           [json: 'name']
	color       ?string           [json: 'color']
	is_favorite ?bool             [json: 'is_favorite']
	view_style  ?ProjectViewStyle [json: 'view_style']
}

// update_project updates the project related to the given id and return it.
// See https://developer.todoist.com/rest/v2/#update-a-project for details.
pub fn (c Client) update_project(id string, params UpdateProjectParams) !Project {
	req := c.new_request(.post, '/v2/projects/${id}', json.encode(params))
	resp := c.http_client.do(req)!
	if resp.status() != .ok {
		return error(resp.body)
	}

	project := json.decode(Project, resp.body)!
	return project
}

// delete_project deletes the project related to the given id.
// See https://developer.todoist.com/rest/v2/#delete-a-project for details.
pub fn (c Client) delete_project(id string) ! {
	req := c.new_request(.delete, '/v2/projects/${id}', '')
	resp := c.http_client.do(req)!
	if resp.status() != .no_content {
		return error(resp.body)
	}
}
