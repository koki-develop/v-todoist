module rest

import json

pub enum ProjectViewStyle {
	list
	board
}

pub struct Project {
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

pub fn (c Client) get_projects() ![]Project {
	req := c.new_request(.get, '/v2/projects', '')
	resp := req.do()!
	if resp.status() != .ok {
		return error(resp.body)
	}

	projects := json.decode([]Project, resp.body)!
	return projects
}

pub fn (c Client) get_project(id string) !Project {
	req := c.new_request(.get, '/v2/projects/${id}', '')
	resp := req.do()!
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

pub fn (c Client) create_project(params CreateProjectParams) !Project {
	req := c.new_request(.post, '/v2/projects', json.encode(params))
	resp := req.do()!
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

pub fn (c Client) update_project(id string, params UpdateProjectParams) !Project {
	req := c.new_request(.post, '/v2/projects/${id}', json.encode(params))
	resp := req.do()!
	if resp.status() != .ok {
		return error(resp.body)
	}

	project := json.decode(Project, resp.body)!
	return project
}
