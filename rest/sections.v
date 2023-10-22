module rest

import json

struct Section {
	id         string [json: 'id']
	project_id string [json: 'project_id']
	order      int    [json: 'order']
	name       string [json: 'name']
}

[params]
struct GetSectionsParams {
	project_id ?string [json: 'project_id']
}

// get_sections returns all sections.
// See https://developer.todoist.com/rest/v2/#get-all-sections for details.
fn (c Client) get_sections(params GetSectionsParams) ![]Section {
	query := to_query(params)!
	req := c.new_request(.get, '/v2/sections', query)
	resp := c.http_client.do(req)!
	if resp.status() != .ok {
		return error(resp.body)
	}

	sections := json.decode([]Section, resp.body)!
	return sections
}
