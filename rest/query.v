module rest

import json
import net.http

fn to_query[T](data T) !string {
	str := json.encode(data)
	m := json.decode(map[string]string, str)!
	return http.url_encode_form_data(m)
}
